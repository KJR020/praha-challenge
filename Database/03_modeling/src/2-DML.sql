-- 👤 ユーザー作成
INSERT INTO users (username, email, password_hash) VALUES
('admin', 'admin@example.com', 'hash1'),
('member1', 'member1@example.com', 'hash2'),
('member2', 'member2@example.com', 'hash3');

-- 📁 ルートディレクトリ (ID=1)
INSERT INTO directories (id, created_by) VALUES (1, 1);
INSERT INTO directory_changes (directory_id, change_type, changed_by) VALUES (1, 'CREATE', 1);
INSERT INTO directory_versions (id, directory_id, name, change_id) VALUES (1, 1, 'ROOT', 1);
INSERT INTO current_directory_versions (directory_id, version_id) VALUES (1, 1);
INSERT INTO directory_hierarchy (ancestor_id, descendant_id, depth, created_by) VALUES (1, 1, 0, 1); -- 自己参照

-- 📁 Documents ディレクトリ (ID=2)
INSERT INTO directories (id, created_by) VALUES (2, 1);
INSERT INTO directory_changes (directory_id, change_type, changed_by) VALUES (2, 'CREATE', 1);
INSERT INTO directory_versions (id, directory_id, name, change_id) VALUES (2, 2, 'Documents', 2);
INSERT INTO current_directory_versions (directory_id, version_id) VALUES (2, 2);
INSERT INTO directory_hierarchy (ancestor_id, descendant_id, depth, created_by) VALUES
(1, 2, 1, 1),
(2, 2, 0, 1);

-- 📁 Wiki ディレクトリ (ID=3)
INSERT INTO directories (id, created_by) VALUES (3, 2);
INSERT INTO directory_changes (directory_id, change_type, changed_by) VALUES (3, 'CREATE', 2);
INSERT INTO directory_versions (id, directory_id, name, change_id) VALUES (3, 3, 'Wiki', 3);
INSERT INTO current_directory_versions (directory_id, version_id) VALUES (3, 3);
INSERT INTO directory_hierarchy (ancestor_id, descendant_id, depth, created_by) VALUES
(1, 3, 1, 1),
(3, 3, 0, 1);

-- 📁 Develop ディレクトリ (ID=4)
INSERT INTO directories (id, created_by) VALUES (4, 1);
INSERT INTO directory_changes (directory_id, change_type, changed_by) VALUES (4, 'CREATE', 1);
INSERT INTO directory_versions (id, directory_id, name, change_id) VALUES (4, 4, 'Develop', 4);
INSERT INTO current_directory_versions (directory_id, version_id) VALUES (4, 4);
INSERT INTO directory_hierarchy (ancestor_id, descendant_id, depth, created_by) VALUES
(1, 4, 2, 1),
(2, 4, 1, 1),
(4, 4, 0, 1);

-- 📁 Manual ディレクトリ (ID=5)
INSERT INTO directories (id, created_by) VALUES (5, 1);
INSERT INTO directory_changes (directory_id, change_type, changed_by) VALUES (5, 'CREATE', 1);
INSERT INTO directory_versions (id, directory_id, name, change_id) VALUES (5, 5, 'Manual', 5);
INSERT INTO current_directory_versions (directory_id, version_id) VALUES (5, 5);
INSERT INTO directory_hierarchy (ancestor_id, descendant_id, depth, created_by) VALUES
(1, 5, 2, 1),
(2, 5, 1, 1),
(5, 5, 0, 1);

-- 📄 ドキュメント1: ProjectPlan (Documents)
INSERT INTO documents (id, created_by) VALUES (1, 1);
INSERT INTO document_changes (id, document_id, change_type, changed_by) VALUES (1, 1, 'CREATE', 1);
INSERT INTO document_versions (id, document_id, name, content, parent_directory_id, change_id) VALUES (1, 1, 'ProjectPlan', 'Hoge', 2, 1);
INSERT INTO current_document_versions (document_id, version_id) VALUES (1, 1);

-- 📄 ドキュメント2: 議事録 (Documents)
INSERT INTO documents (id, created_by) VALUES (2, 2);
INSERT INTO document_changes (id, document_id, change_type, changed_by) VALUES (2, 2, 'CREATE', 2);
INSERT INTO document_versions (id, document_id, name, content, parent_directory_id, change_id) VALUES (2, 2, '議事録', 'ミーティングの議事録', 2, 2);
INSERT INTO current_document_versions (document_id, version_id) VALUES (2, 2);

-- 📄 ドキュメント3: WikiHome (Wiki)
INSERT INTO documents (id, created_by) VALUES (3, 1);
INSERT INTO document_changes (id, document_id, change_type, changed_by) VALUES (3, 3, 'CREATE', 1);
INSERT INTO document_versions (id, document_id, name, content, parent_directory_id, change_id) VALUES (3, 3, 'WikiHome', '# Wikiホーム', 3, 3);
INSERT INTO current_document_versions (document_id, version_id) VALUES (3, 3);

-- 📄 ドキュメント4: DevSetup (Develop)
INSERT INTO documents (id, created_by) VALUES (4, 2);
INSERT INTO document_changes (id, document_id, change_type, changed_by) VALUES (4, 4, 'CREATE', 2);
INSERT INTO document_versions (id, document_id, name, content, parent_directory_id, change_id) VALUES (4, 4, 'DevSetup', 'セットアップ手順', 4, 4);
INSERT INTO current_document_versions (document_id, version_id) VALUES (4, 4);

-- 📄 ドキュメント5: マニュアル1 (Manual)
INSERT INTO documents (id, created_by) VALUES (5, 1);
INSERT INTO document_changes (id, document_id, change_type, changed_by) VALUES (5, 5, 'CREATE', 1);
INSERT INTO document_versions (id, document_id, name, content, parent_directory_id, change_id) VALUES (5, 5, 'Manual1', '# ユーザーマニュアル1', 5, 5);
INSERT INTO current_document_versions (document_id, version_id) VALUES (5, 5);

-- 📄 ドキュメント6: マニュアル2 (Manual)
INSERT INTO documents (id, created_by) VALUES (6, 2);
INSERT INTO document_changes (id, document_id, change_type, changed_by) VALUES (6, 6, 'CREATE', 2);
INSERT INTO document_versions (id, document_id, name, content, parent_directory_id, change_id) VALUES (6, 6, 'Manual2', '# ユーザーマニュアル2', 5, 6);
INSERT INTO current_document_versions (document_id, version_id) VALUES (6, 6);

