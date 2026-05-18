-- 人才匹配資料庫管理系統：查詢與報表範例

-- 01 驗證每張表筆數
SELECT 'company' AS table_name, COUNT(*) AS row_count FROM company
UNION ALL SELECT 'recruiter', COUNT(*) FROM recruiter
UNION ALL SELECT 'job_position', COUNT(*) FROM job_position
UNION ALL SELECT 'candidate', COUNT(*) FROM candidate
UNION ALL SELECT 'skill', COUNT(*) FROM skill
UNION ALL SELECT 'candidate_skill', COUNT(*) FROM candidate_skill
UNION ALL SELECT 'job_skill', COUNT(*) FROM job_skill
UNION ALL SELECT 'application', COUNT(*) FROM application
UNION ALL SELECT 'match_score', COUNT(*) FROM match_score
UNION ALL SELECT 'interview', COUNT(*) FROM interview;

-- 02 綜合查詢：應徵紀錄、媒合分數、面試追蹤
SELECT
  a.application_id,
  c.candidate_name,
  jp.job_title,
  co.company_name,
  ms.overall_score,
  ms.match_level,
  i.interview_datetime,
  i.interview_result
FROM application a
JOIN candidate c ON a.candidate_id = c.candidate_id
JOIN job_position jp ON a.job_id = jp.job_id
JOIN company co ON jp.company_id = co.company_id
LEFT JOIN match_score ms ON a.application_id = ms.application_id
LEFT JOIN interview i ON a.application_id = i.application_id
ORDER BY ms.overall_score DESC, a.apply_date;

-- 03 基礎查詢：求職者前 5 筆
SELECT *
FROM candidate
ORDER BY candidate_id
LIMIT 5;

-- 04 基礎查詢：Open 狀態職缺
SELECT job_id, job_title, work_city, salary_max
FROM job_position
WHERE status = 'Open'
ORDER BY posted_date DESC;

-- 05 基礎查詢：年資 >= 3 年求職者
SELECT candidate_id, candidate_name, education, years_exp
FROM candidate
WHERE years_exp >= 3
ORDER BY years_exp DESC;

-- 06 基礎查詢：某企業全部職缺
SELECT job_id, job_title, work_city, status
FROM job_position
WHERE company_id = 'co001';

-- 07 基礎查詢：技能或職缺名稱模糊查詢
SELECT 'skill' AS data_type, skill_id AS record_id, skill_name AS record_name
FROM skill
WHERE skill_name LIKE '%SQL%'
UNION ALL
SELECT 'job', job_id, job_title
FROM job_position
WHERE job_title LIKE '%資料%';

-- 08 基礎查詢：高薪職缺排序
SELECT job_id, job_title, work_city, salary_min, salary_max
FROM job_position
WHERE salary_max > 60000
ORDER BY salary_max DESC;

-- 09 基礎查詢：高熟練度求職者技能
SELECT
  cs.candidate_id,
  c.candidate_name,
  s.skill_name,
  cs.proficiency
FROM candidate_skill cs
JOIN candidate c ON cs.candidate_id = c.candidate_id
JOIN skill s ON cs.skill_id = s.skill_id
WHERE cs.proficiency >= 4
ORDER BY cs.proficiency DESC;

-- 10 中階查詢：技能在求職者中的出現次數與平均熟練度
SELECT
  s.skill_id,
  s.skill_name,
  COUNT(cs.candidate_id) AS candidate_count,
  ROUND(AVG(cs.proficiency), 2) AS avg_proficiency
FROM skill s
LEFT JOIN candidate_skill cs ON s.skill_id = cs.skill_id
GROUP BY s.skill_id, s.skill_name
ORDER BY candidate_count DESC, avg_proficiency DESC;

-- 11 中階查詢：每個職缺的應徵人數
SELECT
  jp.job_id,
  jp.job_title,
  co.company_name,
  COUNT(a.application_id) AS application_count
FROM job_position jp
JOIN company co ON jp.company_id = co.company_id
LEFT JOIN application a ON jp.job_id = a.job_id
GROUP BY jp.job_id, jp.job_title, co.company_name
ORDER BY application_count DESC;

-- 12 中階查詢：求職者平均媒合分數與應徵筆數
SELECT
  c.candidate_id,
  c.candidate_name,
  COUNT(a.application_id) AS application_count,
  ROUND(AVG(ms.overall_score), 2) AS avg_match_score
FROM candidate c
LEFT JOIN application a ON c.candidate_id = a.candidate_id
LEFT JOIN match_score ms ON a.application_id = ms.application_id
WHERE c.candidate_id = 'ca002'
GROUP BY c.candidate_id, c.candidate_name;

-- 13 中階查詢：沒有任何人投遞的職缺
SELECT jp.job_id, jp.job_title, co.company_name
FROM job_position jp
JOIN company co ON jp.company_id = co.company_id
LEFT JOIN application a ON jp.job_id = a.job_id
WHERE a.job_id IS NULL;

-- 14 中階查詢：每位求職者最早與最近投遞日期
SELECT
  c.candidate_id,
  c.candidate_name,
  MIN(a.apply_date) AS first_apply_date,
  MAX(a.apply_date) AS latest_apply_date
FROM candidate c
LEFT JOIN application a ON c.candidate_id = a.candidate_id
GROUP BY c.candidate_id, c.candidate_name;

-- 15 中階查詢：每個職缺所需技能清單
SELECT
  jp.job_id,
  jp.job_title,
  GROUP_CONCAT(
    CONCAT(s.skill_name, '(Lv', js.required_level, ', w=', js.weight, ')')
    ORDER BY js.weight DESC SEPARATOR '、'
  ) AS skill_requirements
FROM job_position jp
JOIN job_skill js ON jp.job_id = js.job_id
JOIN skill s ON js.skill_id = s.skill_id
GROUP BY jp.job_id, jp.job_title;

-- 16 進階查詢：同時具備 Python 與 SQL 技能的求職者
SELECT c.candidate_id, c.candidate_name
FROM candidate c
JOIN candidate_skill cs ON c.candidate_id = cs.candidate_id
JOIN skill s ON cs.skill_id = s.skill_id
WHERE s.skill_name IN ('Python', 'SQL')
GROUP BY c.candidate_id, c.candidate_name
HAVING COUNT(DISTINCT s.skill_name) = 2;

-- 17 進階查詢：各職缺媒合分數最高的一筆應徵
WITH ranked_match AS (
  SELECT
    jp.job_id,
    jp.job_title,
    c.candidate_name,
    a.application_id,
    ms.overall_score,
    ROW_NUMBER() OVER (
      PARTITION BY jp.job_id
      ORDER BY ms.overall_score DESC
    ) AS rn
  FROM job_position jp
  JOIN application a ON jp.job_id = a.job_id
  JOIN candidate c ON a.candidate_id = c.candidate_id
  JOIN match_score ms ON a.application_id = ms.application_id
)
SELECT *
FROM ranked_match
WHERE rn = 1;

-- 18 進階查詢：各求職者相鄰兩次投遞間隔天數
WITH apply_sequence AS (
  SELECT
    candidate_id,
    application_id,
    apply_date,
    LAG(apply_date) OVER (
      PARTITION BY candidate_id
      ORDER BY apply_date
    ) AS previous_apply_date
  FROM application
)
SELECT
  candidate_id,
  application_id,
  apply_date,
  previous_apply_date,
  DATEDIFF(apply_date, previous_apply_date) AS gap_days
FROM apply_sequence
ORDER BY candidate_id, apply_date;

-- 19 進階查詢：建立高媒合候選人 View
DROP VIEW IF EXISTS high_match_candidate;

CREATE VIEW high_match_candidate AS
SELECT
  c.candidate_id,
  c.candidate_name,
  jp.job_id,
  jp.job_title,
  co.company_name,
  ms.overall_score,
  ms.match_level
FROM match_score ms
JOIN application a ON ms.application_id = a.application_id
JOIN candidate c ON a.candidate_id = c.candidate_id
JOIN job_position jp ON a.job_id = jp.job_id
JOIN company co ON jp.company_id = co.company_id
WHERE ms.overall_score >= 80;

SELECT *
FROM high_match_candidate
ORDER BY overall_score DESC;

-- 20 進階查詢：有應徵但無媒合分數或無面試追蹤的異常資料
SELECT 'NO_MATCH_SCORE' AS issue_type, a.application_id
FROM application a
LEFT JOIN match_score ms ON a.application_id = ms.application_id
WHERE ms.application_id IS NULL
UNION ALL
SELECT 'NO_INTERVIEW_RECORD' AS issue_type, a.application_id
FROM application a
LEFT JOIN interview i ON a.application_id = i.application_id
WHERE i.application_id IS NULL;

-- 21 決策報表：媒合分數排名前 3 的應徵、企業與職缺
SELECT
  a.application_id,
  co.company_name,
  jp.job_title,
  c.candidate_name,
  ms.overall_score
FROM match_score ms
JOIN application a ON ms.application_id = a.application_id
JOIN job_position jp ON a.job_id = jp.job_id
JOIN company co ON jp.company_id = co.company_id
JOIN candidate c ON a.candidate_id = c.candidate_id
ORDER BY ms.overall_score DESC
LIMIT 3;
