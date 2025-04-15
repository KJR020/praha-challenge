-- 1. 新しい記事の作成
BEGIN;

-- 記事の作成
INSERT INTO
  articles (id, created_by, is_published)
VALUES
  (2, 1, FALSE);

-- バージョンの作成
INSERT INTO
  article_versions (id, article_id, version_number, title, content)
VALUES
  (2, 2, 1, 'ドラフト記事', 'ドラフトの記事');

-- 現在のバージョンを設定
INSERT INTO
  current_article_versions (article_id, version_id)
VALUES
  (2, 2);

-- 変更履歴の作成
INSERT INTO
  article_change_events (id, article_id, change_type)
VALUES
  (2, 2, 'CREATE');

-- バージョンイベントの記録
INSERT INTO
  article_version_events (id, change_id, version_id)
VALUES
  (2, 2, 2);

COMMIT;

-- 2. 記事の更新
-- 記事ID=2の内容を更新する例
BEGIN;

-- バージョンの作成
INSERT INTO
  article_versions (id, article_id, version_number, title, content)
VALUES
  (3, 2, 2, '改訂したドラフト記事', 'ドラフトの記事を改訂');

-- version_numberはアプリ側で取得する想定
-- 現在のバージョンを更新
UPDATE current_article_versions
SET
  version_id = 3
WHERE
  article_id = 2;

-- 変更履歴の作成
INSERT INTO
  article_change_events (id, article_id, change_type)
VALUES
  (3, 2, 'UPDATE');

-- バージョンイベントの記録
INSERT INTO
  article_version_events (id, change_id, version_id)
VALUES
  (3, 3, 3);

COMMIT;

-- 3. 記事の公開/非公開設定
-- 記事ID=1を公開する例
BEGIN;

-- 変更履歴の作成
INSERT INTO
  article_change_events (id, article_id, change_type)
VALUES
  (4, 1, 'PUBLISH');

-- 記事を公開状態に設定
UPDATE articles
SET
  is_published = TRUE
WHERE
  id = 1;

COMMIT;

-- 4. バージョンの変更
-- 記事ID=2を過去バージョン（ID=2）に戻す例
BEGIN;

-- 現在のバージョンを更新
UPDATE current_article_versions
SET
  version_id = 2
WHERE
  article_id = 2;

-- 変更履歴の作成
INSERT INTO
  article_change_events (id, article_id, change_type)
VALUES
  (5, 2, 'CHECKOUT');

-- Checkoutイベントの記録
INSERT INTO
  article_checkout_events (change_id, from_version_id, to_version_id)
VALUES
  (1, 3, 2);

COMMIT;

-- 5. 記事の削除
-- 記事ID=1を削除する例
BEGIN;

-- 現在のバージョンを削除
DELETE FROM current_article_versions
WHERE
  article_id = 1;

-- 変更履歴の作成
INSERT INTO
  article_change_events (id, article_id, change_type)
VALUES
  (6, 1, 'DELETE');

-- バージョンイベントの記録
INSERT INTO
  article_version_events (change_id, version_id)
VALUES
  (6, 3);

COMMIT;

-- 6. 最新の記事一覧を取得するクエリ
SELECT
  a.id AS article_id,
  av.title,
  av.content,
  u.username AS author,
  av.created_at,
  a.is_published
FROM
  articles a
  JOIN current_article_versions cav ON a.id = cav.article_id
  JOIN article_versions av ON cav.version_id = av.id
  JOIN users u ON a.created_by = u.id
ORDER BY
  av.created_at DESC;

-- 7. 特定の記事の履歴を一覧表示するクエリ（バージョン番号付き）
SELECT
  ace.change_type,
  ace.changed_at
FROM
  article_change_events ace
WHERE
  ace.article_id = 1
ORDER BY
  ace.changed_at DESC;
