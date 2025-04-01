-- 1. ドキュメントの作成
-- 新しいドキュメント「開発計画」を作成する例
BEGIN;
-- ドキュメント本体を作成
INSERT INTO documents (id, created_by) VALUES (7, 1);
-- 変更履歴を記録
INSERT INTO document_changes (id, document_id, change_type, changed_by)
VALUES (7, 7, 'CREATE', 1);
-- バージョン情報を記録
INSERT INTO document_versions (id, document_id, name, content, parent_directory_id, change_id)
VALUES (7, 7, '新しいドキュメント', '新しいドキュメントです', 4, 7);
-- 現在バージョンを設定
INSERT INTO current_document_versions (document_id, version_id)
VALUES (7, 7);
COMMIT;

-- 2. ドキュメントの編集
-- ドキュメントID=7の内容を更新する例
BEGIN;
-- 変更履歴を記録
INSERT INTO document_changes (id, document_id, change_type, changed_by) 
VALUES (8, 7, 'UPDATE', 1);
-- 新しいバージョン情報を記録
INSERT INTO document_versions (id, document_id, name, content, parent_directory_id, change_id)
VALUES (8, 7, '新しいドキュメント', '更新されたドキュメント', 2, 8);
-- 現在バージョンを更新
UPDATE current_document_versions 
SET version_id = 8 
WHERE document_id = 7;
COMMIT;

-- 3. ドキュメントの削除
-- ドキュメントID=7を削除する例
BEGIN;
-- 削除イベントを記録
INSERT INTO document_changes (id, document_id, change_type, changed_by) 
VALUES (9, 7, 'DELETE', 1);
-- 現在バージョンから削除
DELETE FROM current_document_versions
WHERE document_id = 7;
COMMIT;

-- 4. ディレクトリの移動
-- ディレクトリID=4をID=3の配下に移動する例
BEGIN;
-- 移動イベントを記録
INSERT INTO directory_moves (id, target_directory_id, from_parent_id, to_parent_id, created_by)
VALUES (1, 4, 2, 3, 1);
-- 既存の階層関係を削除
DELETE FROM directory_hierarchy 
WHERE descendant_id = 4 AND ancestor_id != 4;
-- 新しい階層関係を挿入
INSERT INTO directory_hierarchy (ancestor_id, descendant_id, depth, created_by)
VALUES
(1, 4, 2, 1),  -- ROOTからの深さは2になる（ROOT->Wiki->Develop）
(3, 4, 1, 1);  -- 新しい親からの深さは1
-- ※ 実際には子ディレクトリがある場合は、すべての子孫についても同様の処理が必要
COMMIT;

-- 5. 最新のドキュメント一覧の取得
SELECT
  d.id AS document_id,
  dv.name AS document_name,
  dv.content AS current_content,
  u.username AS created_by_user,
  d.created_at
FROM
  documents d
  JOIN current_document_versions c_doc_v ON d.id = c_doc_v.document_id
  JOIN document_versions dv ON c_doc_v.version_id = dv.id
  JOIN users u ON d.created_by = u.id
ORDER BY
  d.created_at DESC;

-- 6. ドキュメントの編集履歴一覧取得
SELECT
  dv.name AS document_name,
  dc.change_type,
  u.username AS changed_by_user,
  dc.changed_at,
  dv.content AS content_at_change
FROM
  document_changes dc
  JOIN users u ON dc.changed_by = u.id
  LEFT JOIN document_versions dv ON dv.change_id = dc.id
WHERE
  dc.document_id = 7
ORDER BY
  dc.document_id,
  dc.changed_at DESC;

-- 7. 特定のサブディレクトリ以下のドキュメント取得
SELECT
  d.id AS document_id,
  dv.name AS document_name,
  dv.content AS document_content,
  u.username AS created_by,
  dv.created_at AS version_created_at,
  dir_v.name AS parent_directory_name
FROM
  documents d
  JOIN current_document_versions c_doc_v ON d.id = c_doc_v.document_id
  JOIN document_versions dv ON c_doc_v.version_id = dv.id
  JOIN users u ON d.created_by = u.id
  JOIN directories dir ON dv.parent_directory_id = dir.id
  JOIN current_directory_versions c_dir_v ON dir.id = c_dir_v.directory_id
  JOIN directory_versions dir_v ON c_dir_v.version_id = dir_v.id
  JOIN directory_hierarchy dh ON dh.descendant_id = dv.parent_directory_id
WHERE
  dh.ancestor_id = 2
ORDER BY
  dv.created_at DESC;

