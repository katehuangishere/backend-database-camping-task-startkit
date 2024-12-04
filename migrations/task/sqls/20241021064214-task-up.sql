-- ████████  █████   █     █ 
--   █ █   ██    █  █     ██ 
--   █ █████ ███ ███       █ 
--   █ █   █    ██  █      █ 
--   █ █   █████ █   █     █ 
-- ===================== ====================

-- 1. 用戶資料，資料表為 USER

-- 1-1 新增：新增六筆用戶資料
INSERT INTO "USER" (name, email, role)
VALUES 
    ('李燕容', 'lee2000@hexschooltest.io', 'USER'),
    ('王小明', 'wXlTq@hexschooltest.io', 'USER'),
    ('肌肉棒子', 'muscle@hexschooltest.io', 'USER'),
    ('好野人', 'richman@hexschooltest.io', 'USER'),
    ('Q太郎', 'starplatinum@hexschooltest.io', 'USER'),
    ('透明人', 'opcatiy0@hexschooltest.io', 'USER');

-- 1-2 修改：用 Email 找到 李燕容、肌肉棒子、Q太郎，如果他的 Role 為 USER 將他的 Role 改為 COACH
UPDATE "USER"
SET 
    ROLE = 'COACH'
WHERE
    email IN ('lee2000@hexschooltest.io', 'muscle@hexschooltest.io', 'starplatinum@hexschooltest.io')
    AND ROLE = 'USER';

-- 1-3 刪除：刪除 USER 資料表中，用 Email 找到 透明人，並刪除該筆資料
DELETE 
FROM "USER"
WHERE
    email = 'opcatiy0@hexschooltest.io';

-- 1-4 查詢：取得 USER 資料表目前所有用戶數量
SELECT COUNT(*) FROM "USER";

-- 1-5 查詢：取得 USER 資料表所有用戶資料，並列出前 3 筆
SELECT * FROM "USER" 
LIMIT 3; 

-- ████████  █████   █    ████  
--   █ █   ██    █  █         █ 
--   █ █████ ███ ███       ███  
--   █ █   █    ██  █     █     
--   █ █   █████ █   █    █████ 
-- ===================== ====================

-- 2. 組合包方案 CREDIT_PACKAGE、客戶購買課程堂數 CREDIT_PURCHASE
-- 2-1 新增：在 CREDIT_PACKAGE 資料表新增三筆資料
INSERT INTO "CREDIT_PACKAGE" (name, credit_amount, price)
VALUES
    ('7 堂組合包方案', 7, 1400),
    ('14 堂組合包方案', 14, 2520),
    ('21 堂組合包方案', 21, 4800);

-- 2-2 新增：在 CREDIT_PURCHASE 資料表新增三筆資料
INSERT INTO "CREDIT_PURCHASE" ("user_id", "credit_package_id", "purchased_credits", "price_paid")
VALUES
    (
        (SELECT id FROM "USER" WHERE "name" = '王小明'),
        (SELECT id FROM "CREDIT_PACKAGE" WHERE "name" = '14 堂組合包方案'),
        14,
        2520
    ),
    (
        (SELECT id FROM "USER" WHERE "name" = '王小明'),
        (SELECT id FROM "CREDIT_PACKAGE" WHERE "name" = '21 堂組合包方案'),
        21,
        4800
    ),
    (
        (SELECT id FROM "USER" WHERE "name" = '好野人'),
        (SELECT id FROM "CREDIT_PACKAGE" WHERE "name" = '14 堂組合包方案'),
        14,
        2520
    );

-- ████████  █████   █    ████   
--   █ █   ██    █  █         ██ 
--   █ █████ ███ ███       ███   
--   █ █   █    ██  █         ██ 
--   █ █   █████ █   █    ████   
-- ===================== ====================

-- 3. 教練資料，資料表為 COACH, SKILL, COACH_LINK_SKILL

-- 3-1 新增：在 COACH 資料表新增三筆教練資料
INSERT INTO "COACH" ("user_id", experience_years)
VALUES
    (
        (SELECT id FROM "USER" WHERE email = 'lee2000@hexschooltest.io'),
        2
    ),
    (
        (SELECT id FROM "USER" WHERE email = 'muscle@hexschooltest.io'),
        2
    ),
    (
        (SELECT id FROM "USER" WHERE email = 'starplatinum@hexschooltest.io'),
        2
    );

-- 3-2 新增：承 1，為三名教練新增專長資料至 COACH_LINK_SKILL
-- 1. 所有教練都有重訓專長
INSERT INTO "COACH_LINK_SKILL" ("coach_id", "skill_id")
SELECT id, (SELECT id FROM "SKILL" WHERE name = '重訓')
FROM "COACH";

-- 2. 教練肌肉棒子需要有瑜伽專長
INSERT INTO "COACH_LINK_SKILL" ("coach_id", "skill_id")
SELECT id, (SELECT id FROM "SKILL" WHERE name = '瑜伽')
FROM "COACH"
WHERE user_id = (SELECT id FROM "USER" WHERE name = '肌肉棒子');

-- 3. 教練 Q 太郎需要有有氧運動與復健訓練專長
INSERT INTO "COACH_LINK_SKILL" ("coach_id", "skill_id")
SELECT id, (SELECT id FROM "SKILL" WHERE name = '有氧運動')
FROM "COACH"
WHERE user_id = (SELECT id FROM "USER" WHERE name = 'Q太郎');

INSERT INTO "COACH_LINK_SKILL" ("coach_id", "skill_id")
SELECT id, (SELECT id FROM "SKILL" WHERE name = '復健訓練')
FROM "COACH"
WHERE user_id = (SELECT id FROM "USER" WHERE name = 'Q太郎');

-- 3-3 修改：更新教練的經驗年數
-- 教練肌肉棒子的經驗年數為 3 年
UPDATE "COACH"
SET experience_years = 3
WHERE user_id = (SELECT id FROM "USER" WHERE name = '肌肉棒子');

-- 教練 Q 太郎的經驗年數為 5 年
UPDATE "COACH"
SET experience_years = 5
WHERE user_id = (SELECT id FROM "USER" WHERE name = 'Q太郎');

-- 3-4 刪除：新增一個專長空中瑜伽至 SKILL 資料表，之後刪除此專長
INSERT INTO "SKILL" (name) VALUES ('空中瑜伽');

DELETE FROM "SKILL"
WHERE name = '空中瑜伽';

-- ████████  █████   █    █   █ 
--   █ █   ██    █  █     █   █ 
--   █ █████ ███ ███      █████ 
--   █ █   █    ██  █         █ 
--   █ █   █████ █   █        █ 
-- ===================== ==================== 

-- 4. 課程管理 COURSE 、組合包方案 CREDIT_PACKAGE

-- 4-1 新增：在 COURSE 新增一門課程
INSERT INTO "COURSE" (
    "user_id", "skill_id", "name", "description", "start_at", "end_at", "max_participants", "meeting_url"
)
VALUES (
    (SELECT id FROM "USER" WHERE email = 'lee2000@hexschooltest.io'),
    (SELECT id FROM "SKILL" WHERE name = '重訓'),
    '重訓基礎課',
    '此課程將介紹重訓的基礎概念與實作技巧。',
    '2024-11-25 14:00:00',
    '2024-11-25 16:00:00',
    10,
    'https://test-meeting.test.io'
);


-- ████████  █████   █    █████ 
--   █ █   ██    █  █     █     
--   █ █████ ███ ███      ████  
--   █ █   █    ██  █         █ 
--   █ █   █████ █   █    ████  
-- ===================== ====================

-- 5. 客戶預約與授課 COURSE_BOOKING
-- 5-1. 新增：請在 `COURSE_BOOKING` 新增兩筆資料：
    -- 1. 第一筆：`王小明`預約 `李燕容` 的課程
        -- 1. 預約人設為`王小明`
        -- 2. 預約時間`booking_at` 設為2024-11-24 16:00:00
        -- 3. 狀態`status` 設定為即將授課
    -- 2. 新增： `好野人` 預約 `李燕容` 的課程
        -- 1. 預約人設為 `好野人`
        -- 2. 預約時間`booking_at` 設為2024-11-24 16:00:00
        -- 3. 狀態`status` 設定為即將授課

-- 5-2. 修改：`王小明`取消預約 `李燕容` 的課程，請在`COURSE_BOOKING`更新該筆預約資料：
    -- 1. 取消預約時間`cancelled_at` 設為2024-11-24 17:00:00
    -- 2. 狀態`status` 設定為課程已取消

-- 5-3. 新增：`王小明`再次預約 `李燕容`   的課程，請在`COURSE_BOOKING`新增一筆資料：
    -- 1. 預約人設為`王小明`
    -- 2. 預約時間`booking_at` 設為2024-11-24 17:10:25
    -- 3. 狀態`status` 設定為即將授課

-- 5-4. 查詢：取得王小明所有的預約紀錄，包含取消預約的紀錄

-- 5-5. 修改：`王小明` 現在已經加入直播室了，請在`COURSE_BOOKING`更新該筆預約資料（請注意，不要更新到已經取消的紀錄）：
    -- 1. 請在該筆預約記錄他的加入直播室時間 `join_at` 設為2024-11-25 14:01:59
    -- 2. 狀態`status` 設定為上課中

-- 5-6. 查詢：計算用戶王小明的購買堂數，顯示須包含以下欄位： user_id , total。 (需使用到 SUM 函式與 Group By)

-- 5-7. 查詢：計算用戶王小明的已使用堂數，顯示須包含以下欄位： user_id , total。 (需使用到 Count 函式與 Group By)

-- 5-8. [挑戰題] 查詢：請在一次查詢中，計算用戶王小明的剩餘可用堂數，顯示須包含以下欄位： user_id , remaining_credit
    -- 提示：
    -- select ("CREDIT_PURCHASE".total_credit - "COURSE_BOOKING".used_credit) as remaining_credit, ...
    -- from ( 用戶王小明的購買堂數 ) as "CREDIT_PURCHASE"
    -- inner join ( 用戶王小明的已使用堂數) as "COURSE_BOOKING"
    -- on "COURSE_BOOKING".user_id = "CREDIT_PURCHASE".user_id;


-- ████████  █████   █     ███  
--   █ █   ██    █  █     █     
--   █ █████ ███ ███      ████  
--   █ █   █    ██  █     █   █ 
--   █ █   █████ █   █     ███  
-- ===================== ====================
-- 6. 後台報表
-- 6-1 查詢：查詢專長為重訓的教練，並按經驗年數排序，由資深到資淺（需使用 inner join 與 order by 語法)
-- 顯示須包含以下欄位： 教練名稱 , 經驗年數, 專長名稱

-- 6-2 查詢：查詢每種專長的教練數量，並只列出教練數量最多的專長（需使用 group by, inner join 與 order by 與 limit 語法）
-- 顯示須包含以下欄位： 專長名稱, coach_total

-- 6-3. 查詢：計算 11 月份組合包方案的銷售數量
-- 顯示須包含以下欄位： 組合包方案名稱, 銷售數量

-- 6-4. 查詢：計算 11 月份總營收（使用 purchase_at 欄位統計）
-- 顯示須包含以下欄位： 總營收

-- 6-5. 查詢：計算 11 月份有預約課程的會員人數（需使用 Distinct，並用 created_at 和 status 欄位統計）
-- 顯示須包含以下欄位： 預約會員人數
