-- Q1 
CREATE TABLE departments (
    department_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(20) NOT NULL,
    created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- department_id 主キー、自動採番
-- name.         部署名、最大20文字、必須
-- created_at.   作成日時、初期値は現在時刻
-- updated_at.   更新日時、更新時に自動更新

-- Q2
ALTER TABLE people
ADD COLUMN department_id INT UNSIGNED AFTER email;

-- カラムの型
-- int unsigned など
-- int(10) unsigned のように表示させたい
-- NULL制約
-- timestamp が YES になっている
-- NO に変更したい
-- DEFAULT
-- timestamp が DEFAULT_GENERATED になっている
-- 明示的に CURRENT_TIMESTAMP と表示させたい

ALTER TABLE people
MODIFY created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
MODIFY updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
MODIFY person_id INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
MODIFY department_id INT(10) UNSIGNED NULL,
MODIFY age TINYINT(3) UNSIGNED NULL,
MODIFY gender TINYINT(4) NULL;

-- Q3
-- ①departments テーブルに部署を追加
INSERT INTO departments (name)
VALUES 
  ('営業'),
  ('開発'),
  ('経理'),
  ('人事'),
  ('情報システム');

-- ②people テーブルに10人分のユーザーを追加
-- →部署比率（営業3人、開発4人、経理1人、人事1人、情報システム1人）を考慮する。

INSERT INTO people (name, email, department_id, age, gender)
VALUES 
  ('山田 太郎', 'yamada@example.com', 1, 30, 1),
  ('佐藤 花子', 'sato@example.com', 1, 28, 2),
  ('鈴木 次郎', 'suzuki@example.com', 1, 35, 1),
  
  ('高橋 三郎', 'takahashi@example.com', 2, 32, 1),
  ('田中 美咲', 'tanaka@example.com', 2, 29, 2),
  ('伊藤 拓海', 'ito@example.com', 2, 27, 1),
  ('中村 涼子', 'nakamura@example.com', 2, 26, 2),

  ('加藤 真一', 'kato@example.com', 3, 40, 1),
  ('渡辺 さくら', 'watanabe@example.com', 4, 33, 2),
  ('小林 大輝', 'kobayashi@example.com', 5, 31, 1);

-- ③reportsテーブルに10件の日報を追加
-- →すべて既存の person_id（例：1〜10）に紐付ける。

INSERT INTO reports (person_id, content)
VALUES 
  (1, '営業先との打ち合わせを行いました。'),
  (2, '新規顧客の提案資料を作成しました。'),
  (3, '既存顧客のフォローアップを実施。'),
  (4, '開発ミーティングで仕様を確認しました。'),
  (5, 'APIの結合テストを進めました。'),
  (6, 'バグ対応を行い、動作確認済みです。'),
  (7, '新機能のUI設計を実施しました。'),
  (8, '経理資料を月次でまとめました。'),
  (9, '採用面談の準備を整えました。'),
  (10, '社内ネットワークの障害対応を行いました。');

-- Q4
-- ex:department_id が NULL の人に部署ID 1（営業）を割り当てる場合
UPDATE people
SET department_id = 1
WHERE department_id IS NULL;

-- Q5
-- 年齢の降順で男性の名前と年齢を取得
SELECT name, age
FROM people
WHERE gender = 1
ORDER BY age DESC;

-- * DESC 降順
-- * ASC 昇順

-- Q6
-- テーブル・レコード・カラムという3つの単語を適切に使用して、下記のSQL文を日本語で説明しなさい

SELECT                        name,email,ageのカラムデータを
  `name`, `email`, `age`
FROM                          peopleテーブルから
  `people`
WHERE                         department_idを対象に
  `department_id` = 1
ORDER BY                      created_atの昇順で並べる(ORDER BYはデフォルトが昇順)
  `created_at`;

A.peopleテーブルから、department_idが1のレコードを対象に、name・email・ageの3つのカラムのデータを、
  created_atカラムの昇順で並べて取得している

-- Q7
-- 20代の女性と40代の男性の名前一覧を取得してください
SELECT name
FROM people
WHERE (gender = 2 AND age BETWEEN 20 AND 29)
   OR (gender = 1 AND age BETWEEN 40 AND 49);

-- Q8
-- 営業部に所属する人だけを年齢の昇順で取得してください
SELECT p.*
FROM people p
JOIN departments d ON p.department_id = d.department_id
WHERE d.name = '営業'
ORDER BY p.age ASC;

-- p.* peopleテーブルの全てのカラム
-- FROM people p でpeopleテーブルにpというエイリアス(別名)を付けた

-- 「SELECT p.person_id, p.name, p.age, d.name AS department_name
--   FROM people p
--   JOIN departments d ON p.department_id = d.department_id
--   WHERE d.name = '営業'
--   ORDER BY p.age ASC;」 でもできる

-- ASの使い方ex:SELECT name AS 名前, email AS メールアドレス
--             結果の列の見出しが「名前」「メールアドレス」になる

-- Q9
-- 開発部に所属している女性の平均年齢を取得してください。
-- 条件：カラム名はaverage_ageとなるようにしましょう
SELECT AVG(p.age) AS average_age
FROM people AS p
JOIN departments AS d ON p.department_id = d.department_id
WHERE d.name = '開発' AND p.gender = 2;

-- Q10
-- 名前と部署名とその人が提出した日報の内容を同時に取得してください。（日報を提出していない人は含めない）
SELECT p.name AS person_name, d.name AS department_name, r.content AS report_content
FROM people AS p
JOIN departments AS d ON p.department_id = d.department_id
JOIN reports AS r ON p.person_id = r.person_id;

-- 日報を提出していない人を除くために、JOIN（内部結合）を使用

-- Q11
-- 日報を一つも提出していない人の名前一覧を取得してください。
SELECT p.name
FROM people AS p
LEFT JOIN reports AS r ON p.person_id = r.person_id
WHERE r.report_id IS NULL;

-- LEFT JOIN：people テーブルの全員に対して reports を結合します。日報がない場合でも NULL で表示される
-- WHERE r.report_id IS NULL：結合後に report_id が NULL のレコード(日報が存在しない人だけ)を抽出

-- *日報提出者も含まれてしまった。
SELECT p.person_id, p.name, r.report_id
FROM people AS p
LEFT JOIN reports AS r ON p.person_id = r.person_id
ORDER BY p.person_id;

-- *重複した名前あり
SELECT name, COUNT(*) AS count
FROM people
GROUP BY name
HAVING count > 1;

-- *対象のレコードを確認
SELECT *
FROM people AS p1
WHERE EXISTS (
  SELECT 1
  FROM people AS p2
  WHERE p1.name = p2.name
    AND p1.person_id > p2.person_id
);

-- *名前を別名に更新
-- UPDATE people AS p1
-- JOIN (
--   SELECT name, MAX(person_id) AS max_id
--   FROM people
--   GROUP BY name
--   HAVING COUNT(*) > 1
-- ) AS dup
-- ON p1.name = dup.name AND p1.person_id = dup.max_id
-- SET p1.name = CONCAT(p1.name, '（別名）');

UPDATE people
SET name = '鈴木 壱馬'
WHERE person_id = 46;

UPDATE people
SET name = '高橋 陸'
WHERE person_id = 47;

-- 1 | 鈴木たかし
-- 2 | 田中ゆうこ 
-- 3 | 福田だいすけ 
-- 4 | 豊島はなこ
-- 6 | 不思議沢みちこ   
-- 11 | 佐藤 一郎  
-- 12 | 鈴木 次郎  
-- 13 | 高橋 三郎 
-- 14 | 田中 四郎 
-- 15 | 伊藤 五郎   
-- 16 | 山本 花子   
-- 17 | 中村 真一  
-- 18 | 小林 涼子  
-- 19 | 加藤 拓海   
-- 20 | 渡辺 美咲    
-- 21 | 村上 拓哉     
-- 44 | 山田 太郎   
-- 45 | 佐藤 花子      
-- 46 | 鈴木 壱馬   
-- 47 | 高橋 陸       
-- 48 | 田中 美咲    
-- 49 | 伊藤 拓海     
-- 50 | 中村 涼子      
-- 51 | 加藤 真一    
-- 52 | 渡辺 さくら
-- 53 | 小林 大輝 