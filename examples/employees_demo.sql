-- 完整練習範例：employees

CREATE TABLE employees (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(50) NOT NULL,
    department VARCHAR(50),
    salary DECIMAL(10,2),
    hire_date DATE
);

INSERT INTO employees
(emp_id, emp_name, department, salary, hire_date)
VALUES
(1, '王小明', '資訊部', 45000, '2024-08-01'),
(2, '李小華', '人資部', 42000, '2023-06-15'),
(3, '陳大安', '資訊部', 55000, '2022-03-20'),
(4, '林美玲', '財務部', 48000, '2021-11-10'),
(5, '張志強', '資訊部', 60000, '2020-01-05');

-- 查詢所有員工
SELECT *
FROM employees;

-- 查詢資訊部員工
SELECT *
FROM employees
WHERE department = '資訊部';

-- 查詢薪資大於 50000 的員工
SELECT *
FROM employees
WHERE salary > 50000;

-- 查詢各部門平均薪資
SELECT
    department,
    AVG(salary) AS avg_salary
FROM employees
GROUP BY department;

-- 查詢平均薪資大於 50000 的部門
SELECT
    department,
    AVG(salary) AS avg_salary
FROM employees
GROUP BY department
HAVING AVG(salary) > 50000;

-- 依薪資由高到低排序
SELECT *
FROM employees
ORDER BY salary DESC;
