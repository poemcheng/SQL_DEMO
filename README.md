# 資料庫管理系統常用 SQL 語法

這份教材整理「資料庫管理系統常用 SQL 語法」，可直接作為課堂講義或學生練習基礎。SQL 可分為 **查詢、資料操作、資料定義、權限控制、交易控制** 五大類。

## 檔案說明

| 檔案 | 用途 |
| --- | --- |
| `README.md` | SQL 語法講義與課程架構 |
| `examples/school_db_demo.sql` | 學生、課程、JOIN、GROUP BY、View、Index 範例 |
| `examples/employees_demo.sql` | 員工資料表完整查詢練習 |
| `exercises/products_practice.sql` | 產品資料表學生練習題與參考 SQL |

## 一、SQL 基本分類

| 類型 | 名稱 | 功能 |
| --- | --- | --- |
| DQL | Data Query Language | 查詢資料，例如 `SELECT` |
| DML | Data Manipulation Language | 新增、修改、刪除資料，例如 `INSERT`、`UPDATE`、`DELETE` |
| DDL | Data Definition Language | 建立或修改資料表，例如 `CREATE`、`ALTER`、`DROP` |
| DCL | Data Control Language | 權限管理，例如 `GRANT`、`REVOKE` |
| TCL | Transaction Control Language | 交易控制，例如 `COMMIT`、`ROLLBACK` |

## 二、建立資料庫與資料表 DDL

```sql
CREATE DATABASE school_db;
USE school_db;
```

`USE` 常見於 MySQL。PostgreSQL 通常是在連線時選擇資料庫。

```sql
CREATE TABLE students (
    student_id INT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    gender VARCHAR(10),
    age INT,
    department VARCHAR(50),
    email VARCHAR(100) UNIQUE
);
```

| 欄位或語法 | 說明 |
| --- | --- |
| `student_id` | 學生編號 |
| `INT` | 整數型態 |
| `VARCHAR(50)` | 最多 50 個字元的文字 |
| `PRIMARY KEY` | 主鍵，不能重複且不能為空 |
| `NOT NULL` | 不允許空值 |
| `UNIQUE` | 欄位值不可重複 |

### 常見資料型態

| 資料型態 | 說明 | 範例 |
| --- | --- | --- |
| `INT` | 整數 | 1, 100 |
| `DECIMAL(10,2)` | 小數 | 99.50 |
| `VARCHAR(n)` | 可變長度文字 | 'Tom' |
| `CHAR(n)` | 固定長度文字 | 'A01' |
| `DATE` | 日期 | '2026-05-18' |
| `DATETIME` | 日期時間 | '2026-05-18 10:30:00' |
| `BOOLEAN` | 布林值 | TRUE / FALSE |
| `TEXT` | 長文字 | 文章內容 |

### 修改與刪除資料表

```sql
ALTER TABLE students ADD phone VARCHAR(20);
ALTER TABLE students MODIFY phone VARCHAR(30);
ALTER TABLE students DROP COLUMN phone;
DROP TABLE students;
```

## 三、新增、修改、刪除資料 DML

```sql
INSERT INTO students (student_id, name, gender, age, department, email)
VALUES (1, '王小明', '男', 20, '資訊管理系', 'ming@example.com');
```

```sql
INSERT INTO students (student_id, name, gender, age, department, email)
VALUES
    (2, '李小華', '女', 21, '工業工程系', 'hua@example.com'),
    (3, '陳大安', '男', 22, '資訊工程系', 'an@example.com'),
    (4, '林美玲', '女', 20, '資訊管理系', 'mei@example.com');
```

```sql
UPDATE students
SET age = 21
WHERE student_id = 1;
```

`UPDATE` 一定要小心使用 `WHERE`，否則會更新整張表。

```sql
DELETE FROM students
WHERE student_id = 4;
```

```sql
DELETE FROM students;
TRUNCATE TABLE students;
```

| 指令 | 說明 |
| --- | --- |
| `DELETE` | 可搭配 `WHERE`，可逐筆刪除 |
| `TRUNCATE` | 快速清空整張表，通常不可逐筆控制 |

## 四、查詢資料 DQL：SELECT

```sql
SELECT *
FROM students;
```

```sql
SELECT name, department
FROM students;
```

```sql
SELECT
    name AS student_name,
    department AS dept
FROM students;
```

```sql
SELECT *
FROM students
WHERE department = '資訊管理系';
```

### 多條件查詢

```sql
SELECT *
FROM students
WHERE department = '資訊管理系'
  AND age >= 20;
```

```sql
SELECT *
FROM students
WHERE department = '資訊管理系'
   OR department = '資訊工程系';
```

```sql
SELECT *
FROM students
WHERE NOT department = '資訊管理系';
```

## 五、常見條件運算子

| 運算子 | 說明 | 範例 |
| --- | --- | --- |
| `=` | 等於 | `age = 20` |
| `<>` 或 `!=` | 不等於 | `age <> 20` |
| `>` | 大於 | `age > 20` |
| `<` | 小於 | `age < 20` |
| `>=` | 大於等於 | `age >= 20` |
| `<=` | 小於等於 | `age <= 20` |
| `BETWEEN` | 範圍 | `age BETWEEN 20 AND 25` |
| `IN` | 多個可能值 | `department IN (...)` |
| `LIKE` | 模糊查詢 | `name LIKE '王%'` |
| `IS NULL` | 是否為空值 | `email IS NULL` |

```sql
SELECT * FROM students WHERE age BETWEEN 20 AND 22;
SELECT * FROM students WHERE department IN ('資訊管理系', '資訊工程系');
SELECT * FROM students WHERE name LIKE '王%';
SELECT * FROM students WHERE email IS NULL;
SELECT * FROM students WHERE email IS NOT NULL;
```

| LIKE 寫法 | 說明 |
| --- | --- |
| `'王%'` | 以「王」開頭 |
| `'%明'` | 以「明」結尾 |
| `'%小%'` | 包含「小」 |
| `'_明'` | 前面任一字，後面是「明」 |

## 六、排序 ORDER BY

```sql
SELECT * FROM students ORDER BY age ASC;
SELECT * FROM students ORDER BY age DESC;
SELECT * FROM students ORDER BY department ASC, age DESC;
```

## 七、限制查詢筆數

MySQL / PostgreSQL：

```sql
SELECT *
FROM students
LIMIT 5;
```

SQL Server：

```sql
SELECT TOP 5 *
FROM students;
```

## 八、聚合函數 Aggregate Functions

| 函數 | 說明 |
| --- | --- |
| `COUNT()` | 計算筆數 |
| `SUM()` | 加總 |
| `AVG()` | 平均 |
| `MAX()` | 最大值 |
| `MIN()` | 最小值 |

```sql
SELECT COUNT(*) AS total_students FROM students;
SELECT AVG(age) AS avg_age FROM students;
SELECT MAX(age) AS max_age, MIN(age) AS min_age FROM students;
```

## 九、分組查詢 GROUP BY

```sql
SELECT
    department,
    COUNT(*) AS student_count
FROM students
GROUP BY department;
```

`WHERE` 是分組前篩選，`HAVING` 是分組後篩選。

```sql
SELECT
    department,
    COUNT(*) AS student_count
FROM students
GROUP BY department
HAVING COUNT(*) >= 2;
```

## 十、資料表關聯與 JOIN

students：

| student_id | name | department |
| --- | --- | --- |
| 1 | 王小明 | 資管系 |
| 2 | 李小華 | 工工系 |

courses：

| course_id | course_name | student_id |
| --- | --- | --- |
| 101 | 資料庫管理 | 1 |
| 102 | 人工智慧 | 1 |
| 103 | 生產管理 | 2 |

```sql
SELECT students.name, courses.course_name
FROM students
INNER JOIN courses
ON students.student_id = courses.student_id;
```

```sql
SELECT students.name, courses.course_name
FROM students
LEFT JOIN courses
ON students.student_id = courses.student_id;
```

```sql
SELECT students.name, courses.course_name
FROM students
RIGHT JOIN courses
ON students.student_id = courses.student_id;
```

```sql
SELECT students.name, courses.course_name
FROM students
FULL OUTER JOIN courses
ON students.student_id = courses.student_id;
```

MySQL 不直接支援 `FULL OUTER JOIN`，通常要用 `LEFT JOIN UNION RIGHT JOIN` 模擬。

## 十一、子查詢 Subquery

```sql
SELECT *
FROM students
WHERE age > (
    SELECT AVG(age)
    FROM students
);
```

```sql
SELECT *
FROM students
WHERE student_id IN (
    SELECT student_id
    FROM courses
    WHERE course_name = '資料庫管理'
);
```

## 十二、資料表約束 Constraints

| 約束 | 功能 |
| --- | --- |
| `PRIMARY KEY` | 主鍵 |
| `FOREIGN KEY` | 外鍵 |
| `NOT NULL` | 不可空值 |
| `UNIQUE` | 不可重複 |
| `CHECK` | 條件限制 |
| `DEFAULT` | 預設值 |

```sql
CREATE TABLE courses (
    course_id INT PRIMARY KEY,
    course_name VARCHAR(100) NOT NULL,
    student_id INT,
    FOREIGN KEY (student_id) REFERENCES students(student_id)
);
```

```sql
CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    price DECIMAL(10,2) CHECK (price >= 0)
);
```

```sql
CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    order_date DATE DEFAULT CURRENT_DATE,
    status VARCHAR(20) DEFAULT 'pending'
);
```

## 十三、索引 Index

索引用來加快查詢速度，但會增加新增、修改、刪除資料時的維護成本。

```sql
CREATE INDEX idx_students_department
ON students(department);
```

MySQL：

```sql
DROP INDEX idx_students_department
ON students;
```

PostgreSQL：

```sql
DROP INDEX idx_students_department;
```

## 十四、檢視表 View

View 是一種虛擬資料表，通常用來簡化查詢或限制使用者看到的資料。

```sql
CREATE VIEW view_student_basic AS
SELECT student_id, name, department
FROM students;
```

```sql
SELECT *
FROM view_student_basic;
```

```sql
DROP VIEW view_student_basic;
```

## 十五、交易控制 Transaction

交易用來確保資料操作具有一致性。常見於訂單、付款、庫存扣除等情境。

```sql
START TRANSACTION;

UPDATE accounts
SET balance = balance - 1000
WHERE account_id = 1;

UPDATE accounts
SET balance = balance + 1000
WHERE account_id = 2;

COMMIT;
```

```sql
START TRANSACTION;

UPDATE accounts
SET balance = balance - 1000
WHERE account_id = 1;

ROLLBACK;
```

| ACID 特性 | 說明 |
| --- | --- |
| Atomicity 原子性 | 交易要嘛全部成功，要嘛全部失敗 |
| Consistency 一致性 | 交易前後資料必須符合規則 |
| Isolation 隔離性 | 多筆交易互不干擾 |
| Durability 持久性 | 交易完成後資料永久保存 |

## 十六、權限管理 DCL

```sql
GRANT SELECT, INSERT
ON students
TO user1;
```

```sql
REVOKE INSERT
ON students
FROM user1;
```

## 十七、完整練習範例

完整可執行版本請參考 `examples/employees_demo.sql`。

```sql
CREATE TABLE employees (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(50) NOT NULL,
    department VARCHAR(50),
    salary DECIMAL(10,2),
    hire_date DATE
);
```

```sql
SELECT
    department,
    AVG(salary) AS avg_salary
FROM employees
GROUP BY department
HAVING AVG(salary) > 50000;
```

## 十八、學生練習題

### 基礎題

1. 建立一個 `products` 資料表，包含產品編號、產品名稱、價格、庫存數量。
2. 新增 5 筆產品資料。
3. 查詢所有產品。
4. 查詢價格大於 1000 的產品。
5. 查詢庫存小於 10 的產品。

### 中階題

1. 計算所有產品的平均價格。
2. 查詢最高價格與最低價格。
3. 依價格由高到低排序。
4. 將某一項產品價格調整為 1200。
5. 刪除庫存為 0 的產品。

### 進階題

1. 建立 `customers` 與 `orders` 兩張資料表。
2. 使用外鍵建立顧客與訂單的關係。
3. 查詢每位顧客的訂單數量。
4. 查詢沒有下訂單的顧客。
5. 查詢訂單金額最高的前 3 名顧客。

## 十九、SQL 寫作順序與執行順序

撰寫順序：

```sql
SELECT
FROM
WHERE
GROUP BY
HAVING
ORDER BY
LIMIT
```

實際執行順序：

```sql
FROM
WHERE
GROUP BY
HAVING
SELECT
ORDER BY
LIMIT
```

這一點很重要，因為資料庫通常會先決定資料來源，再篩選資料，接著分組，最後才輸出結果。

## 二十、最常用 SQL 模板

```sql
SELECT 欄位1, 欄位2, 聚合函數(欄位3)
FROM 資料表
WHERE 條件
GROUP BY 分組欄位
HAVING 分組後條件
ORDER BY 排序欄位 DESC
LIMIT 筆數;
```

```sql
SELECT
    department,
    COUNT(*) AS employee_count,
    AVG(salary) AS avg_salary
FROM employees
WHERE salary >= 40000
GROUP BY department
HAVING AVG(salary) >= 45000
ORDER BY avg_salary DESC
LIMIT 5;
```

## 建議課程安排

| 單元 | 主題 |
| --- | --- |
| 第 1 單元 | 資料庫與資料表建立 |
| 第 2 單元 | 新增、修改、刪除資料 |
| 第 3 單元 | SELECT 查詢與條件篩選 |
| 第 4 單元 | GROUP BY 與統計分析 |
| 第 5 單元 | JOIN 與關聯式資料庫設計 |
| 第 6 單元 | 子查詢、View、Index 與 Transaction |
