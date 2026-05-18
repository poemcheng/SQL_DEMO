-- 學生練習題：products
-- 請依照題目完成 SQL。

-- 基礎題 1：建立一個 products 資料表，包含產品編號、產品名稱、價格、庫存數量。
CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    price DECIMAL(10,2),
    stock_quantity INT
);

-- 基礎題 2：新增 5 筆產品資料。
INSERT INTO products (product_id, product_name, price, stock_quantity)
VALUES
    (1, '鍵盤', 1200, 15),
    (2, '滑鼠', 600, 30),
    (3, '螢幕', 4500, 8),
    (4, '耳機', 980, 0),
    (5, '筆記型電腦', 32000, 5);

-- 基礎題 3：查詢所有產品。
SELECT *
FROM products;

-- 基礎題 4：查詢價格大於 1000 的產品。
SELECT *
FROM products
WHERE price > 1000;

-- 基礎題 5：查詢庫存小於 10 的產品。
SELECT *
FROM products
WHERE stock_quantity < 10;

-- 中階題 1：計算所有產品的平均價格。
SELECT AVG(price) AS avg_price
FROM products;

-- 中階題 2：查詢最高價格與最低價格。
SELECT
    MAX(price) AS max_price,
    MIN(price) AS min_price
FROM products;

-- 中階題 3：依價格由高到低排序。
SELECT *
FROM products
ORDER BY price DESC;

-- 中階題 4：將某一項產品價格調整為 1200。
UPDATE products
SET price = 1200
WHERE product_id = 2;

-- 中階題 5：刪除庫存為 0 的產品。
DELETE FROM products
WHERE stock_quantity = 0;

-- 進階題：請自行建立 customers 與 orders 兩張資料表，並完成 JOIN 查詢。
