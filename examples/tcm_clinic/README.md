# 中醫診所門診資料庫管理系統範例

本範例整理自「中醫診所門診資料庫管理系統_手把手教學簡報」，目標是建立一個可教學、可查詢、可報表分析的 MySQL 門診資料庫。

## 範例重點

- 10 張核心資料表：`clinic`、`staff`、`clinic_schedule`、`patient`、`appointment`、`visit_record`、`diagnosis_code`、`treatment_item`、`prescription`、`payment`
- 門診資料流：病患建檔、掛號、排班醫師、看診紀錄、診斷代碼、治療處方、付款、報表
- SQL 練習：基礎查詢、JOIN、GROUP BY、CTE、Window Function、View、完整性檢查

## 檔案說明

| 檔案 | 用途 |
| --- | --- |
| `schema.sql` | 建立中醫診所門診資料庫與 10 張核心資料表 |
| `seed.sql` | 匯入診所、醫療人員、病患、掛號、看診、處方與付款模擬資料 |
| `queries.sql` | 基礎、中階、進階查詢與管理報表範例 |
| `exercises.md` | 學生練習題與分組任務 |

## 建議執行順序

1. 在 MySQL、SQL Fiddle 或 OneCompiler MySQL 開啟 SQL 編輯器。
2. 先執行 `schema.sql`，清除舊表並建立新資料表。
3. 再執行 `seed.sql`，匯入模擬資料。
4. 最後執行 `queries.sql`，練習查詢與報表分析。

## 教學提醒

本範例僅作資料庫教學用途，所有姓名與資料皆為模擬資料，不可直接取代正式醫療資訊系統。正式系統仍需補強登入權限、個資保護、病歷修改軌跡、備份、稽核與健保申報串接。
