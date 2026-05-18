# SQL 基礎六單元教學與練習

本文件對應 README 的「課程安排建議」前六個單元，提供每一單元的基本教學說明、核心語法與學生練習。建議搭配 `examples/school_db_demo.sql`、`examples/employees_demo.sql` 與 `exercises/products_practice.sql` 使用。

## 第 1 單元：資料庫與資料表建立

### 教學目標

學生能理解資料庫、資料表、欄位、資料型態、主鍵與約束的基本概念，並能建立一張可使用的資料表。

### 基本說明

資料庫可以想成一個資料集合，資料表則是用來儲存某一類資料的表格。例如學生資料可以放在 `students` 資料表，產品資料可以放在 `products` 資料表。

建立資料表時，要先思考：

- 這張表要存什麼資料？
- 每一筆資料要用哪個欄位當唯一識別？
- 欄位的資料型態是文字、數字、日期，還是金額？
- 哪些欄位不能空白？

常見設計重點：

| 概念 | 說明 |
| --- | --- |
| `PRIMARY KEY` | 主鍵，每筆資料的唯一識別 |
| `NOT NULL` | 欄位不可為空 |
| `UNIQUE` | 欄位值不可重複 |
| `INT` | 整數 |
| `VARCHAR(n)` | 可變長度文字 |
| `DECIMAL(10,2)` | 金額或小數 |
| `DATE` | 日期 |

### 範例

```sql
CREATE TABLE students (
    student_id INT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    age INT,
    department VARCHAR(50),
    email VARCHAR(100) UNIQUE
);
```

### 練習

1. 建立一個 `products` 資料表，包含 `product_id`、`product_name`、`price`、`stock_quantity`。
2. 將 `product_id` 設為主鍵。
3. 將 `product_name` 設為不可空值。
4. 將 `price` 設為 `DECIMAL(10,2)`。
5. 建立一個 `employees` 資料表，包含員工編號、姓名、部門、薪資與到職日期。

## 第 2 單元：新增、修改、刪除資料

### 教學目標

學生能使用 `INSERT` 新增資料，使用 `UPDATE` 修改資料，使用 `DELETE` 刪除資料，並理解 `WHERE` 條件的重要性。

### 基本說明

資料表建立後，需要把資料放進去。SQL 中常用的資料操作語法包括：

| 指令 | 功能 |
| --- | --- |
| `INSERT` | 新增資料 |
| `UPDATE` | 修改資料 |
| `DELETE` | 刪除資料 |

使用 `UPDATE` 與 `DELETE` 時一定要特別注意 `WHERE`。如果沒有 `WHERE`，可能會修改或刪除整張表的資料。

### 範例

```sql
INSERT INTO products (product_id, product_name, price, stock_quantity)
VALUES (1, '鍵盤', 1200, 15);
```

```sql
UPDATE products
SET price = 1000
WHERE product_id = 1;
```

```sql
DELETE FROM products
WHERE product_id = 1;
```

### 練習

1. 新增 5 筆產品資料到 `products`。
2. 將其中一項產品價格改成 1200。
3. 將某項產品庫存數量改成 0。
4. 刪除庫存為 0 的產品。
5. 寫出一個錯誤示範：沒有 `WHERE` 的 `UPDATE`，並說明危險性。

## 第 3 單元：SELECT 查詢與條件篩選

### 教學目標

學生能使用 `SELECT` 查詢資料，並搭配 `WHERE`、比較運算子、`LIKE`、`IN`、`BETWEEN`、`IS NULL` 進行條件篩選。

### 基本說明

`SELECT` 是 SQL 中最常用的查詢語法，用來從資料表取出資料。

常見查詢方式：

| 語法 | 功能 |
| --- | --- |
| `SELECT *` | 查詢全部欄位 |
| `SELECT 欄位1, 欄位2` | 查詢指定欄位 |
| `WHERE` | 設定篩選條件 |
| `LIKE` | 模糊查詢 |
| `IN` | 多個可能值 |
| `BETWEEN` | 範圍查詢 |
| `IS NULL` | 判斷空值 |

### 範例

```sql
SELECT *
FROM products;
```

```sql
SELECT product_name, price
FROM products
WHERE price > 1000;
```

```sql
SELECT *
FROM products
WHERE product_name LIKE '%鍵盤%';
```

### 練習

1. 查詢所有產品資料。
2. 查詢產品名稱與價格。
3. 查詢價格大於 1000 的產品。
4. 查詢庫存小於 10 的產品。
5. 使用 `LIKE` 查詢名稱包含「電」的產品。
6. 使用 `BETWEEN` 查詢價格介於 500 到 3000 的產品。
7. 使用 `IN` 查詢指定多個產品編號。

## 第 4 單元：GROUP BY 與統計分析

### 教學目標

學生能使用聚合函數與 `GROUP BY` 進行統計分析，並理解 `WHERE` 與 `HAVING` 的差異。

### 基本說明

當資料不只要列出，而是要統計時，會使用聚合函數。

| 函數 | 功能 |
| --- | --- |
| `COUNT()` | 計算筆數 |
| `SUM()` | 加總 |
| `AVG()` | 平均 |
| `MAX()` | 最大值 |
| `MIN()` | 最小值 |

`GROUP BY` 用來依照某個欄位分組統計。`WHERE` 是分組前篩選，`HAVING` 是分組後篩選。

### 範例

```sql
SELECT
    department,
    COUNT(*) AS employee_count,
    AVG(salary) AS avg_salary
FROM employees
GROUP BY department;
```

```sql
SELECT
    department,
    AVG(salary) AS avg_salary
FROM employees
GROUP BY department
HAVING AVG(salary) > 50000;
```

### 練習

1. 計算所有產品總筆數。
2. 計算所有產品平均價格。
3. 查詢最高價格與最低價格。
4. 依產品類別統計產品數量。如果目前沒有類別欄位，請先新增或想像一個 `category` 欄位。
5. 查詢平均價格大於 1000 的產品類別。
6. 使用 `ORDER BY` 將統計結果由大到小排序。

## 第 5 單元：JOIN 與關聯式資料庫設計

### 教學目標

學生能理解一對多關聯、外鍵與 JOIN 的用途，並能使用 `INNER JOIN` 與 `LEFT JOIN` 查詢跨表資料。

### 基本說明

關聯式資料庫的重點不是把所有資料塞在同一張表，而是把不同主題拆成不同資料表，再用主鍵與外鍵連起來。

例如：

- `customers` 儲存顧客資料。
- `orders` 儲存訂單資料。
- `orders.customer_id` 可以連到 `customers.customer_id`。

常見 JOIN：

| JOIN | 說明 |
| --- | --- |
| `INNER JOIN` | 只顯示兩邊都有對應的資料 |
| `LEFT JOIN` | 左表全部保留，右表沒有資料時顯示 NULL |

### 範例

```sql
SELECT
    c.customer_name,
    o.order_id,
    o.order_amount
FROM customers c
INNER JOIN orders o
ON c.customer_id = o.customer_id;
```

```sql
SELECT
    c.customer_name,
    o.order_id
FROM customers c
LEFT JOIN orders o
ON c.customer_id = o.customer_id;
```

### 練習

1. 建立 `customers` 資料表，包含顧客編號與姓名。
2. 建立 `orders` 資料表，包含訂單編號、顧客編號、訂單日期與金額。
3. 設計 `orders.customer_id` 作為外鍵，連到 `customers.customer_id`。
4. 查詢每筆訂單的顧客姓名與訂單金額。
5. 查詢每位顧客的訂單數量。
6. 使用 `LEFT JOIN` 找出沒有下訂單的顧客。

## 第 6 單元：View、CTE、Window Function 與完整性檢查

### 教學目標

學生能理解進階查詢工具的用途，包含 View、CTE、Window Function 與資料完整性檢查。

### 基本說明

當查詢變複雜時，可以用更清楚的方式組織 SQL。

| 工具 | 功能 |
| --- | --- |
| `VIEW` | 將常用查詢保存成虛擬資料表 |
| `CTE` | 使用 `WITH` 讓複雜查詢分段 |
| `ROW_NUMBER()` | 依分組排序產生名次 |
| `LAG()` | 取得上一筆資料，常用於時間間隔 |
| 完整性檢查 | 找出流程缺漏或資料異常 |

### 範例：View

```sql
CREATE VIEW view_employee_salary AS
SELECT
    emp_id,
    emp_name,
    department,
    salary
FROM employees;
```

### 範例：CTE

```sql
WITH dept_avg AS (
    SELECT
        department,
        AVG(salary) AS avg_salary
    FROM employees
    GROUP BY department
)
SELECT *
FROM dept_avg
WHERE avg_salary > 50000;
```

### 範例：Window Function

```sql
SELECT
    emp_id,
    emp_name,
    department,
    salary,
    ROW_NUMBER() OVER (
        PARTITION BY department
        ORDER BY salary DESC
    ) AS salary_rank
FROM employees;
```

### 練習

1. 建立一個 View，顯示員工姓名、部門與薪資。
2. 使用 CTE 計算各部門平均薪資，再查詢平均薪資大於 50000 的部門。
3. 使用 `ROW_NUMBER()` 找出每個部門薪資最高的員工。
4. 建立 `customers` 與 `orders` 後，用 `LEFT JOIN` 找出沒有訂單的顧客。
5. 在中醫診所範例中，找出有掛號但沒有付款的資料。
6. 在人才匹配範例中，找出有應徵但沒有媒合分數的資料。

## 單元總結任務

完成前六個單元後，請學生選擇一個主題，自行設計至少 3 張資料表，並完成：

1. 建立資料表與主外鍵。
2. 新增至少 10 筆模擬資料。
3. 寫出 5 題基礎查詢。
4. 寫出 3 題 `GROUP BY` 統計。
5. 寫出 2 題 JOIN 查詢。
6. 寫出 1 題完整性檢查。
