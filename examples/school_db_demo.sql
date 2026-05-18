-- 資料庫管理系統 SQL 範例：school_db
-- 適用於 MySQL 教學練習。

CREATE DATABASE school_db;
USE school_db;

CREATE TABLE students (
    student_id INT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    gender VARCHAR(10),
    age INT,
    department VARCHAR(50),
    email VARCHAR(100) UNIQUE
);

INSERT INTO students (
    student_id, name, gender, age, department, email
)
VALUES
    (1, '王小明', '男', 20, '資訊管理系', 'ming@example.com'),
    (2, '李小華', '女', 21, '工業工程系', 'hua@example.com'),
    (3, '陳大安', '男', 22, '資訊工程系', 'an@example.com'),
    (4, '林美玲', '女', 20, '資訊管理系', 'mei@example.com');

CREATE TABLE courses (
    course_id INT PRIMARY KEY,
    course_name VARCHAR(100) NOT NULL,
    student_id INT,
    FOREIGN KEY (student_id) REFERENCES students(student_id)
);

INSERT INTO courses (course_id, course_name, student_id)
VALUES
    (101, '資料庫管理', 1),
    (102, '人工智慧', 1),
    (103, '生產管理', 2);

-- 查詢全部資料
SELECT *
FROM students;

-- 查詢指定欄位
SELECT name, department
FROM students;

-- 條件查詢
SELECT *
FROM students
WHERE department = '資訊管理系';

-- 多條件查詢
SELECT *
FROM students
WHERE department = '資訊管理系'
  AND age >= 20;

-- BETWEEN
SELECT *
FROM students
WHERE age BETWEEN 20 AND 22;

-- IN
SELECT *
FROM students
WHERE department IN ('資訊管理系', '資訊工程系');

-- LIKE
SELECT *
FROM students
WHERE name LIKE '王%';

-- 排序
SELECT *
FROM students
ORDER BY department ASC, age DESC;

-- 聚合函數
SELECT COUNT(*) AS total_students
FROM students;

SELECT AVG(age) AS avg_age
FROM students;

SELECT
    MAX(age) AS max_age,
    MIN(age) AS min_age
FROM students;

-- 分組查詢
SELECT
    department,
    COUNT(*) AS student_count
FROM students
GROUP BY department;

-- HAVING
SELECT
    department,
    COUNT(*) AS student_count
FROM students
GROUP BY department
HAVING COUNT(*) >= 2;

-- INNER JOIN
SELECT
    students.name,
    courses.course_name
FROM students
INNER JOIN courses
ON students.student_id = courses.student_id;

-- LEFT JOIN
SELECT
    students.name,
    courses.course_name
FROM students
LEFT JOIN courses
ON students.student_id = courses.student_id;

-- 子查詢
SELECT *
FROM students
WHERE age > (
    SELECT AVG(age)
    FROM students
);

-- View
CREATE VIEW view_student_basic AS
SELECT
    student_id,
    name,
    department
FROM students;

SELECT *
FROM view_student_basic;

-- Index
CREATE INDEX idx_students_department
ON students(department);
