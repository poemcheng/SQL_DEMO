-- 中醫診所門診資料庫管理系統：查詢與報表範例

-- 01 驗證每張表筆數
SELECT 'clinic' AS table_name, COUNT(*) AS row_count FROM clinic
UNION ALL SELECT 'staff', COUNT(*) FROM staff
UNION ALL SELECT 'clinic_schedule', COUNT(*) FROM clinic_schedule
UNION ALL SELECT 'patient', COUNT(*) FROM patient
UNION ALL SELECT 'appointment', COUNT(*) FROM appointment
UNION ALL SELECT 'visit_record', COUNT(*) FROM visit_record
UNION ALL SELECT 'diagnosis_code', COUNT(*) FROM diagnosis_code
UNION ALL SELECT 'treatment_item', COUNT(*) FROM treatment_item
UNION ALL SELECT 'prescription', COUNT(*) FROM prescription
UNION ALL SELECT 'payment', COUNT(*) FROM payment;

-- 02 完整門診 JOIN 報表
SELECT
  a.appointment_id,
  a.appointment_datetime,
  p.patient_name,
  st.staff_name,
  d.diagnosis_name,
  pay.total_amount,
  pay.payment_status
FROM appointment a
JOIN patient p ON a.patient_id = p.patient_id
JOIN staff st ON a.staff_id = st.staff_id
LEFT JOIN visit_record v ON a.appointment_id = v.appointment_id
LEFT JOIN diagnosis_code d ON v.diagnosis_id = d.diagnosis_id
LEFT JOIN payment pay ON a.appointment_id = pay.appointment_id
ORDER BY a.appointment_datetime;

-- 03 基礎查詢：病患前 5 筆
SELECT *
FROM patient
ORDER BY patient_id
LIMIT 5;

-- 04 基礎查詢：查詢醫師
SELECT staff_name, specialty
FROM staff
WHERE role_name = 'Physician'
  AND is_active = 1;

-- 05 基礎查詢：找出年齡 >= 65 歲病患
SELECT patient_name, gender, birth_date
FROM patient
WHERE TIMESTAMPDIFF(YEAR, birth_date, CURDATE()) >= 65;

-- 06 基礎查詢：某日掛號
SELECT appointment_id, patient_id, staff_id
FROM appointment
WHERE DATE(appointment_datetime) = '2025-05-19'
ORDER BY appointment_datetime;

-- 07 基礎查詢：主訴包含腰痛
SELECT visit_id, patient_id, chief_complaint
FROM visit_record
WHERE chief_complaint LIKE '%腰痛%';

-- 08 基礎查詢：Morning 診醫師與診所
SELECT DISTINCT st.staff_name, c.clinic_name
FROM clinic_schedule cs
JOIN staff st ON cs.staff_id = st.staff_id
JOIN clinic c ON cs.clinic_id = c.clinic_id
WHERE cs.session_name = 'Morning';

-- 09 中階查詢：各治療項目使用次數與總金額
SELECT
  t.treatment_name,
  COUNT(p.prescription_id) AS use_count,
  SUM(p.subtotal_fee) AS total_fee
FROM treatment_item t
LEFT JOIN prescription p ON t.treatment_id = p.treatment_id
GROUP BY t.treatment_id, t.treatment_name
ORDER BY total_fee DESC;

-- 10 中階查詢：每位醫師看診人數與收費總額
SELECT
  st.staff_id,
  st.staff_name,
  COUNT(DISTINCT a.appointment_id) AS visit_count,
  SUM(pay.total_amount) AS total_revenue
FROM staff st
JOIN appointment a ON st.staff_id = a.staff_id
LEFT JOIN payment pay ON a.appointment_id = pay.appointment_id
WHERE st.role_name = 'Physician'
GROUP BY st.staff_id, st.staff_name
ORDER BY total_revenue DESC;

-- 11 中階查詢：病患累積看診金額與看診次數
SELECT
  p.patient_id,
  p.patient_name,
  COUNT(DISTINCT a.appointment_id) AS visit_count,
  SUM(pay.total_amount) AS total_spending
FROM patient p
JOIN appointment a ON p.patient_id = a.patient_id
LEFT JOIN payment pay ON a.appointment_id = pay.appointment_id
WHERE p.patient_id = 'pt002'
GROUP BY p.patient_id, p.patient_name;

-- 12 中階查詢：從未被使用過的治療項目
SELECT t.treatment_id, t.treatment_name
FROM treatment_item t
LEFT JOIN prescription p ON t.treatment_id = p.treatment_id
WHERE p.prescription_id IS NULL;

-- 13 中階查詢：每位病患最早與最近看診日期
SELECT
  p.patient_id,
  p.patient_name,
  MIN(DATE(a.appointment_datetime)) AS first_visit,
  MAX(DATE(a.appointment_datetime)) AS latest_visit
FROM patient p
LEFT JOIN appointment a ON p.patient_id = a.patient_id
GROUP BY p.patient_id, p.patient_name
ORDER BY p.patient_id;

-- 14 中階查詢：同一天看診 2 次以上
SELECT
  patient_id,
  DATE(appointment_datetime) AS visit_date,
  COUNT(*) AS visit_count
FROM appointment
GROUP BY patient_id, DATE(appointment_datetime)
HAVING COUNT(*) >= 2;

-- 15 中階查詢：同一次看診的處方串接
SELECT
  v.visit_id,
  GROUP_CONCAT(
    CONCAT(t.treatment_name, ':', pr.herb_name, '/', pr.days, '天')
    ORDER BY pr.prescription_id SEPARATOR '，'
  ) AS prescription_summary
FROM visit_record v
JOIN prescription pr ON v.visit_id = pr.visit_id
JOIN treatment_item t ON pr.treatment_id = t.treatment_id
GROUP BY v.visit_id;

-- 16 進階查詢：各病患最新一次看診與金額
WITH ranked_visit AS (
  SELECT
    p.patient_id,
    p.patient_name,
    a.appointment_id,
    a.appointment_datetime,
    pay.total_amount,
    ROW_NUMBER() OVER (
      PARTITION BY p.patient_id
      ORDER BY a.appointment_datetime DESC
    ) AS rn
  FROM patient p
  JOIN appointment a ON p.patient_id = a.patient_id
  LEFT JOIN payment pay ON a.appointment_id = pay.appointment_id
)
SELECT *
FROM ranked_visit
WHERE rn = 1;

-- 17 進階查詢：病患相鄰回診間隔天數
WITH visit_seq AS (
  SELECT
    patient_id,
    appointment_id,
    appointment_datetime,
    LAG(appointment_datetime) OVER (
      PARTITION BY patient_id
      ORDER BY appointment_datetime
    ) AS prev_visit_time
  FROM appointment
  WHERE status = 'Completed'
)
SELECT
  patient_id,
  appointment_id,
  appointment_datetime,
  TIMESTAMPDIFF(DAY, prev_visit_time, appointment_datetime) AS days_between_visits
FROM visit_seq;

-- 18 進階查詢：建立高頻診斷 View
DROP VIEW IF EXISTS frequent_diagnosis;

CREATE VIEW frequent_diagnosis AS
WITH dx_count AS (
  SELECT
    d.diagnosis_id,
    d.diagnosis_name,
    COUNT(v.visit_id) AS visit_count
  FROM diagnosis_code d
  LEFT JOIN visit_record v ON d.diagnosis_id = v.diagnosis_id
  GROUP BY d.diagnosis_id, d.diagnosis_name
), avg_dx AS (
  SELECT AVG(visit_count) AS avg_count
  FROM dx_count
)
SELECT dc.*
FROM dx_count dc
CROSS JOIN avg_dx a
WHERE dc.visit_count > a.avg_count;

SELECT *
FROM frequent_diagnosis;

-- 19 進階查詢：有掛號但沒有看診或付款的異常資料
SELECT 'NO_VISIT_RECORD' AS issue_type, a.appointment_id
FROM appointment a
LEFT JOIN visit_record v ON a.appointment_id = v.appointment_id
WHERE v.appointment_id IS NULL
UNION ALL
SELECT 'NO_PAYMENT' AS issue_type, a.appointment_id
FROM appointment a
LEFT JOIN payment p ON a.appointment_id = p.appointment_id
WHERE p.appointment_id IS NULL;

-- 20 管理報表：每日收入
SELECT
  DATE(paid_at) AS pay_date,
  SUM(total_amount) AS daily_revenue
FROM payment
WHERE payment_status = 'Paid'
GROUP BY DATE(paid_at)
ORDER BY pay_date;
