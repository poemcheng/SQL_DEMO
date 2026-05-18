# SQL_DEMO

這個 repo 收錄資料庫管理系統與 SQL 語法教學範例，適合作為課堂講義、學生練習與專題資料庫設計入門。內容從基本 SQL 語法開始，延伸到兩個完整情境資料庫：中醫診所門診系統與人才匹配系統。

## 專案內容

| 路徑 | 主題 | 說明 |
| --- | --- | --- |
| `examples/school_db_demo.sql` | SQL 基礎範例 | 學生、課程、JOIN、GROUP BY、View、Index |
| `examples/employees_demo.sql` | 員工資料練習 | 員工資料表、薪資查詢、部門統計 |
| `exercises/products_practice.sql` | 產品資料練習 | 產品資料表、查詢、更新、刪除與統計 |
| `examples/tcm_clinic/` | 中醫診所門診資料庫 | 10 張表、模擬資料、門診 JOIN 報表、完整性檢查 |
| `examples/talent_matching/` | 人才匹配資料庫 | 10 張表、技能媒合、應徵追蹤、面試與媒合分數分析 |

## 建議學習順序

1. 先閱讀本頁的 SQL 分類與常用語法。
2. 執行 `examples/school_db_demo.sql`，熟悉基本查詢、JOIN 與分組。
3. 執行 `examples/employees_demo.sql` 與 `exercises/products_practice.sql`，練習單表與彙總分析。
4. 進入 `examples/tcm_clinic/`，學習門診流程如何轉成資料庫。
5. 進入 `examples/talent_matching/`，學習技能需求、求職者能力與媒合分數的資料模型。

## 情境資料庫執行方式

`examples/tcm_clinic/` 與 `examples/talent_matching/` 都採用相同結構：

| 檔案 | 用途 |
| --- | --- |
| `README.md` | 範例說明與執行順序 |
| `schema.sql` | 建立資料表與外鍵 |
| `seed.sql` | 匯入模擬資料 |
| `queries.sql` | 查詢、報表、View、Window Function 與完整性檢查 |
| `exercises.md` | 學生練習題與分組任務 |

建議在 MySQL、SQL Fiddle 或 OneCompiler MySQL 中依序執行：

```sql
-- 1. 建立資料表
source schema.sql;

-- 2. 匯入資料
source seed.sql;

-- 3. 執行查詢練習
source queries.sql;
```

若使用線上 SQL 編輯器不支援 `source`，請依序複製三個檔案內容貼上執行。

## SQL 基本分類

| 類型 | 名稱 | 功能 |
| --- | --- | --- |
| DQL | Data Query Language | 查詢資料，例如 `SELECT` |
| DML | Data Manipulation Language | 新增、修改、刪除資料，例如 `INSERT`、`UPDATE`、`DELETE` |
| DDL | Data Definition Language | 建立或修改資料表，例如 `CREATE`、`ALTER`、`DROP` |
| DCL | Data Control Language | 權限管理，例如 `GRANT`、`REVOKE` |
| TCL | Transaction Control Language | 交易控制，例如 `COMMIT`、`ROLLBACK` |

## 常用 SQL 模板

```sql
SELECT
    欄位1,
    欄位2,
    聚合函數(欄位3) AS 統計欄位
FROM 資料表
WHERE 篩選條件
GROUP BY 分組欄位
HAVING 分組後條件
ORDER BY 排序欄位 DESC
LIMIT 筆數;
```

範例：

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

## 課程安排建議

| 單元 | 主題 |
| --- | --- |
| 第 1 單元 | 資料庫與資料表建立 |
| 第 2 單元 | 新增、修改、刪除資料 |
| 第 3 單元 | SELECT 查詢與條件篩選 |
| 第 4 單元 | GROUP BY 與統計分析 |
| 第 5 單元 | JOIN 與關聯式資料庫設計 |
| 第 6 單元 | View、CTE、Window Function 與完整性檢查 |
| 第 7 單元 | 情境資料庫專題：中醫診所門診系統 |
| 第 8 單元 | 情境資料庫專題：人才匹配系統 |

## 教學提醒

所有案例資料皆為模擬資料，只供資料庫教學與 SQL 練習使用。若延伸為正式系統，仍需補強帳號權限、個資保護、稽核紀錄、備份機制與正式業務規範。
