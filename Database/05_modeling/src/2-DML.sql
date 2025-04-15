-- ユーザー作成
INSERT INTO
  users (username, email, password_hash)
VALUES
  ('user1', 'user1@example.com', 'hash1');

-- 記事1
-- 記事の作成
INSERT INTO
  articles (id, created_by, is_published)
VALUES
  (1, 1, TRUE);

-- バージョンの作成
INSERT INTO
  article_versions (
    id,
    article_id,
    version_number,
    title,
    content
  )
VALUES
  (1, 1, 1, '記事1', '記事1の内容');

-- 現在のバージョンを設定
INSERT INTO
  current_article_versions (article_id, version_id)
VALUES
  (1, 1);

-- 変更履歴の作成
INSERT INTO
  article_change_events (id, article_id, change_type)
VALUES
  (1, 1, 'CREATE');

-- バージョンイベントの記録
INSERT INTO
  article_version_events (id, change_id, version_id)
VALUES
  (1, 1, 1);

