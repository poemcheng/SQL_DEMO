-- 人才匹配資料庫管理系統：建表腳本
-- MySQL teaching example.

DROP TABLE IF EXISTS interview;
DROP TABLE IF EXISTS match_score;
DROP TABLE IF EXISTS application;
DROP TABLE IF EXISTS job_skill;
DROP TABLE IF EXISTS candidate_skill;
DROP TABLE IF EXISTS job_position;
DROP TABLE IF EXISTS skill;
DROP TABLE IF EXISTS candidate;
DROP TABLE IF EXISTS recruiter;
DROP TABLE IF EXISTS company;

CREATE TABLE company (
  company_id VARCHAR(10) PRIMARY KEY,
  company_name VARCHAR(100) NOT NULL,
  industry VARCHAR(50),
  city VARCHAR(50),
  contact_phone VARCHAR(30),
  website VARCHAR(150)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE recruiter (
  recruiter_id VARCHAR(10) PRIMARY KEY,
  company_id VARCHAR(10) NOT NULL,
  recruiter_name VARCHAR(50) NOT NULL,
  title VARCHAR(50),
  email VARCHAR(100),
  phone VARCHAR(30),
  FOREIGN KEY (company_id) REFERENCES company(company_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE candidate (
  candidate_id VARCHAR(10) PRIMARY KEY,
  candidate_name VARCHAR(50) NOT NULL,
  gender VARCHAR(10),
  age INT,
  education VARCHAR(50),
  years_exp DECIMAL(4,1),
  city VARCHAR(50),
  email VARCHAR(100),
  phone VARCHAR(30),
  status VARCHAR(20)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE skill (
  skill_id VARCHAR(10) PRIMARY KEY,
  skill_name VARCHAR(80) NOT NULL,
  skill_category VARCHAR(50),
  skill_level_ref VARCHAR(30)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE job_position (
  job_id VARCHAR(10) PRIMARY KEY,
  company_id VARCHAR(10) NOT NULL,
  recruiter_id VARCHAR(10) NOT NULL,
  job_title VARCHAR(100) NOT NULL,
  job_type VARCHAR(30),
  work_city VARCHAR(50),
  salary_min INT,
  salary_max INT,
  status VARCHAR(20),
  posted_date DATE,
  FOREIGN KEY (company_id) REFERENCES company(company_id),
  FOREIGN KEY (recruiter_id) REFERENCES recruiter(recruiter_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE candidate_skill (
  candidate_id VARCHAR(10),
  skill_id VARCHAR(10),
  proficiency INT,
  years_used DECIMAL(4,1),
  PRIMARY KEY (candidate_id, skill_id),
  FOREIGN KEY (candidate_id) REFERENCES candidate(candidate_id),
  FOREIGN KEY (skill_id) REFERENCES skill(skill_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE job_skill (
  job_id VARCHAR(10),
  skill_id VARCHAR(10),
  required_level INT,
  weight DECIMAL(5,2),
  is_must_have TINYINT,
  PRIMARY KEY (job_id, skill_id),
  FOREIGN KEY (job_id) REFERENCES job_position(job_id),
  FOREIGN KEY (skill_id) REFERENCES skill(skill_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE application (
  application_id VARCHAR(10) PRIMARY KEY,
  job_id VARCHAR(10) NOT NULL,
  candidate_id VARCHAR(10) NOT NULL,
  apply_date DATE,
  application_status VARCHAR(30),
  FOREIGN KEY (job_id) REFERENCES job_position(job_id),
  FOREIGN KEY (candidate_id) REFERENCES candidate(candidate_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE match_score (
  match_id VARCHAR(10) PRIMARY KEY,
  application_id VARCHAR(10) NOT NULL,
  skill_fit_score DECIMAL(5,2),
  exp_fit_score DECIMAL(5,2),
  location_fit_score DECIMAL(5,2),
  overall_score DECIMAL(5,2),
  match_level VARCHAR(20),
  calculated_at DATETIME,
  FOREIGN KEY (application_id) REFERENCES application(application_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE interview (
  interview_id VARCHAR(10) PRIMARY KEY,
  application_id VARCHAR(10) NOT NULL,
  recruiter_id VARCHAR(10) NOT NULL,
  interview_datetime DATETIME,
  interview_type VARCHAR(30),
  interview_result VARCHAR(30),
  note VARCHAR(200),
  FOREIGN KEY (application_id) REFERENCES application(application_id),
  FOREIGN KEY (recruiter_id) REFERENCES recruiter(recruiter_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
