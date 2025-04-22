CREATE TABLE
  users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
  );

CREATE TABLE
  articles (
    id SERIAL PRIMARY KEY,
    created_by INTEGER NOT NULL,
    is_published BOOLEAN NOT NULL DEFAULT FALSE, -- 公開ステータス
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (created_by) REFERENCES users (id)
  );

CREATE TABLE
  article_versions (
    id SERIAL PRIMARY KEY,
    article_id INTEGER NOT NULL,
    version_number INTEGER NOT NULL, -- 記事ごとのインクリメンタルなバージョン番号
    title VARCHAR(255) NOT NULL,
    content TEXT NOT NULL, -- 1000文字程度の本文
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (article_id) REFERENCES articles (id),
    UNIQUE (article_id, version_number) -- 記事IDとバージョン番号の組み合わせは一意
  );

-- 各記事の最新バージョンを管理する
CREATE TABLE
  current_article_versions (
    article_id INTEGER PRIMARY KEY,
    version_id INTEGER NOT NULL,
    FOREIGN KEY (article_id) REFERENCES articles (id),
    FOREIGN KEY (version_id) REFERENCES article_versions (id)
  );

CREATE TABLE
  article_change_events (
    id SERIAL PRIMARY KEY,
    article_id INTEGER NOT NULL,
    change_type VARCHAR(50) NOT NULL, -- 'CREATE', 'UPDATE', 'RESTORE', 'PUBLISH', 'UNPUBLISH'
    changed_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (article_id) REFERENCES articles (id)
  );

-- CREATE/UPDATEイベントで作成されたバージョンを紐付けるテーブル
CREATE TABLE
  article_version_events (
    id SERIAL PRIMARY KEY,
    change_id INTEGER NOT NULL,
    version_id INTEGER NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (change_id) REFERENCES article_change_events (id),
    FOREIGN KEY (version_id) REFERENCES article_versions (id)
  );

-- CHECKOUTイベントと、変更前後のバージョンを記録するテーブル
CREATE TABLE
  article_checkout_events (
    id SERIAL PRIMARY KEY,
    change_id INTEGER NOT NULL,
    from_version_id INTEGER NOT NULL,
    to_version_id INTEGER NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (change_id) REFERENCES article_change_events (id),
    FOREIGN KEY (from_version_id) REFERENCES article_versions (id),
    FOREIGN KEY (to_version_id) REFERENCES article_versions (id)
  );

-- インデックス作成
CREATE INDEX idx_articles_created_by ON articles (created_by);

CREATE INDEX idx_article_versions_article_id ON article_versions (article_id);

CREATE INDEX idx_article_change_events_article_id ON article_change_events (article_id);

CREATE INDEX idx_article_version_events_change_id ON article_version_events (change_id);

CREATE INDEX idx_article_version_events_version_id ON article_version_events (version_id);

CREATE INDEX idx_article_checkout_events_change_id ON article_checkout_events (change_id);

CREATE INDEX idx_article_checkout_events_from_version_id ON article_checkout_events (from_version_id);

CREATE INDEX idx_article_checkout_events_to_version_id ON article_checkout_events (to_version_id);