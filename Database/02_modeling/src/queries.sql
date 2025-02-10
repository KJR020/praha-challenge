-- チャネル内のメッセージを取得する
WITH latest_events AS (
    SELECT 
        message_id,
        content,
        created_at,
        ROW_NUMBER() OVER (PARTITION BY message_id ORDER BY created_at DESC) as rn
    FROM message_events
)
SELECT
    m.id,
    COALESCE(le.content, m.content) as content,
    u.username as posted_by,
    m.created_at
FROM messages m
JOIN users u ON m.posted_by = u.id
LEFT JOIN latest_events le ON m.id = le.message_id AND le.rn = 1
WHERE m.channel_id = '00000000-0000-0000-0000-000000000001'
    AND m.is_root = TRUE
ORDER BY m.created_at DESC;


-- スレッドの全メッセージを取得する（しりとりスレッドの例）
SELECT 
    m.id,
    m.posted_by,
    u.username,
    m.content,
    m.created_at
FROM messages m
JOIN users u ON m.posted_by = u.id
WHERE m.id IN (
    SELECT descendant_id
    FROM message_hierarchies
    WHERE ancestor_id = '00000000-0000-0000-0000-000000000003'  -- ルートメッセージID
)
ORDER BY m.created_at;


-- メッセージの横断検索（"プロジェクト"で検索）
SELECT DISTINCT
    m.id,
    m.content,
    u.username as posted_by,
    c.name as channel_name,
    m.created_at,
    CASE 
        WHEN m.is_root THEN 'ルートメッセージ'
        ELSE 'スレッド返信'
    END as message_type
FROM messages m
JOIN users u ON m.posted_by = u.id
JOIN channels c ON m.channel_id = c.id
WHERE m.content ILIKE '%プロジェクト%'  -- 検索キーワード
ORDER BY m.created_at DESC;

-- ユーザーが特定のチャネルにアクセス権限を持っているか確認（ぼっち太郎のbotch_roomへのアクセス確認）
SELECT EXISTS (
    SELECT 1
    FROM channel_members cm
    JOIN channels c ON cm.channel_id = c.id
    WHERE cm.user_id = '00000000-0000-0000-0000-000000000004'  -- ぼっち太郎
        AND cm.channel_id = '00000000-0000-0000-0000-000000000003'  -- botch_room
) as has_access;

