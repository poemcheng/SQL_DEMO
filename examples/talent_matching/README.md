# 人才匹配資料庫管理系統範例

本範例整理自「人才匹配資料庫管理系統_手把手教學簡報」，目標是建立一個可教學、可查詢、可分析的人才媒合 MySQL 資料庫。

## 範例重點

- 10 張核心資料表：`company`、`recruiter`、`job_position`、`candidate`、`skill`、`candidate_skill`、`job_skill`、`application`、`match_score`、`interview`
- 資料流程：企業建檔、職缺發布、求職者建檔、技能標籤、投遞應徵、媒合分數、面試追蹤
- SQL 練習：基礎查詢、JOIN、GROUP BY、CTE、Window Function、View、完整性檢查

## 檔案說明

| 檔案 | 用途 |
| --- | --- |
| `schema.sql` | 建立人才匹配資料庫 10 張核心資料表 |
| `seed.sql` | 匯入企業、職缺、求職者、技能、應徵、媒合與面試模擬資料 |
| `queries.sql` | 基礎、中階、進階查詢與管理報表範例 |
| `exercises.md` | 學生練習題與分組任務 |

## 建議執行順序

1. 在 MySQL、SQL Fiddle 或 OneCompiler MySQL 開啟 SQL 編輯器。
2. 先執行 `schema.sql`，清除舊表並建立新資料表。
3. 再執行 `seed.sql`，匯入模擬資料。
4. 最後執行 `queries.sql`，練習查詢、媒合排名與完整性檢查。

## 教學提醒

本範例是 HR Tech 資料庫教學用途。資料為模擬資料，適合練習主外鍵設計、技能供需分析、媒合分數排序、面試流程追蹤與資料品質檢查。
