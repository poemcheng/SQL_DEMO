-- 中醫診所門診資料庫管理系統：建表腳本
-- MySQL teaching example.

DROP TABLE IF EXISTS payment;
DROP TABLE IF EXISTS prescription;
DROP TABLE IF EXISTS visit_record;
DROP TABLE IF EXISTS appointment;
DROP TABLE IF EXISTS treatment_item;
DROP TABLE IF EXISTS diagnosis_code;
DROP TABLE IF EXISTS patient;
DROP TABLE IF EXISTS clinic_schedule;
DROP TABLE IF EXISTS staff;
DROP TABLE IF EXISTS clinic;

CREATE TABLE clinic (
  clinic_id   VARCHAR(10) PRIMARY KEY,
  clinic_name VARCHAR(100) NOT NULL,
  city        VARCHAR(50),
  address     VARCHAR(200),
  phone       VARCHAR(30),
  open_time   TIME,
  close_time  TIME
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE staff (
  staff_id    VARCHAR(10) PRIMARY KEY,
  clinic_id   VARCHAR(10) NOT NULL,
  staff_name  VARCHAR(50) NOT NULL,
  role_name   VARCHAR(30),
  license_no  VARCHAR(50),
  specialty   VARCHAR(100),
  hire_date   DATE,
  is_active   TINYINT DEFAULT 1,
  FOREIGN KEY (clinic_id) REFERENCES clinic(clinic_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE clinic_schedule (
  schedule_id  VARCHAR(10) PRIMARY KEY,
  clinic_id    VARCHAR(10) NOT NULL,
  staff_id     VARCHAR(10) NOT NULL,
  work_date    DATE NOT NULL,
  session_name VARCHAR(20),
  start_time   TIME,
  end_time     TIME,
  room_no      VARCHAR(20),
  FOREIGN KEY (clinic_id) REFERENCES clinic(clinic_id),
  FOREIGN KEY (staff_id) REFERENCES staff(staff_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE patient (
  patient_id       VARCHAR(10) PRIMARY KEY,
  patient_name     VARCHAR(50) NOT NULL,
  gender           VARCHAR(10),
  birth_date       DATE,
  phone            VARCHAR(30),
  address          VARCHAR(200),
  first_visit_date DATE,
  insurance_type   VARCHAR(30)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE diagnosis_code (
  diagnosis_id   VARCHAR(10) PRIMARY KEY,
  diagnosis_name VARCHAR(100) NOT NULL,
  syndrome_type  VARCHAR(100),
  category       VARCHAR(50),
  description    VARCHAR(300)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE treatment_item (
  treatment_id      VARCHAR(10) PRIMARY KEY,
  treatment_name    VARCHAR(100) NOT NULL,
  treatment_type    VARCHAR(50),
  base_fee          DECIMAL(10,2),
  insurance_covered TINYINT DEFAULT 0,
  is_active         TINYINT DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE appointment (
  appointment_id       VARCHAR(10) PRIMARY KEY,
  clinic_id            VARCHAR(10) NOT NULL,
  patient_id           VARCHAR(10) NOT NULL,
  staff_id             VARCHAR(10) NOT NULL,
  schedule_id          VARCHAR(10),
  appointment_datetime DATETIME NOT NULL,
  visit_type           VARCHAR(30),
  status               VARCHAR(20),
  queue_no             INT,
  FOREIGN KEY (clinic_id) REFERENCES clinic(clinic_id),
  FOREIGN KEY (patient_id) REFERENCES patient(patient_id),
  FOREIGN KEY (staff_id) REFERENCES staff(staff_id),
  FOREIGN KEY (schedule_id) REFERENCES clinic_schedule(schedule_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE visit_record (
  visit_id        VARCHAR(10) PRIMARY KEY,
  appointment_id  VARCHAR(10) NOT NULL,
  patient_id      VARCHAR(10) NOT NULL,
  staff_id        VARCHAR(10) NOT NULL,
  chief_complaint VARCHAR(300),
  pulse_desc      VARCHAR(200),
  tongue_desc     VARCHAR(200),
  diagnosis_id    VARCHAR(10),
  visit_note      TEXT,
  created_at      DATETIME,
  FOREIGN KEY (appointment_id) REFERENCES appointment(appointment_id),
  FOREIGN KEY (patient_id) REFERENCES patient(patient_id),
  FOREIGN KEY (staff_id) REFERENCES staff(staff_id),
  FOREIGN KEY (diagnosis_id) REFERENCES diagnosis_code(diagnosis_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE prescription (
  prescription_id VARCHAR(10) PRIMARY KEY,
  visit_id        VARCHAR(10) NOT NULL,
  treatment_id    VARCHAR(10) NOT NULL,
  herb_name       VARCHAR(100),
  dosage          VARCHAR(50),
  days            INT,
  frequency       VARCHAR(50),
  subtotal_fee    DECIMAL(10,2),
  FOREIGN KEY (visit_id) REFERENCES visit_record(visit_id),
  FOREIGN KEY (treatment_id) REFERENCES treatment_item(treatment_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE payment (
  payment_id       VARCHAR(10) PRIMARY KEY,
  appointment_id   VARCHAR(10) NOT NULL,
  patient_id       VARCHAR(10) NOT NULL,
  payment_method   VARCHAR(30),
  registration_fee DECIMAL(10,2),
  treatment_fee    DECIMAL(10,2),
  medicine_fee     DECIMAL(10,2),
  discount_amount  DECIMAL(10,2) DEFAULT 0,
  total_amount     DECIMAL(10,2),
  paid_at          DATETIME,
  payment_status   VARCHAR(20),
  FOREIGN KEY (appointment_id) REFERENCES appointment(appointment_id),
  FOREIGN KEY (patient_id) REFERENCES patient(patient_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
