-- テーブル作成とRLS設定
-- テナント用のテーブル作成
CREATE TABLE
  IF NOT EXISTS tenants (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
  );

-- 従業員テーブル作成
CREATE TABLE
  IF NOT EXISTS employees (
    id SERIAL PRIMARY KEY,
    tenant_id INTEGER NOT NULL REFERENCES tenants (id),
    name VARCHAR(100) NOT NULL
  );

-- プロジェクトテーブル作成
CREATE TABLE
  IF NOT EXISTS projects (
    id SERIAL PRIMARY KEY,
    tenant_id INTEGER NOT NULL REFERENCES tenants (id),
    name VARCHAR(100) NOT NULL
  );

-- インデックス作成
CREATE INDEX idx_employees_tenant_id ON employees (tenant_id);

CREATE INDEX idx_projects_tenant_id ON projects (tenant_id);

-- テナント別のデータベースユーザーを作成
CREATE USER praha_user
WITH
  PASSWORD 'praha_password';

CREATE USER tokyo_user
WITH
  PASSWORD 'tokyo_password';

CREATE USER osaka_user
WITH
  PASSWORD 'osaka_password';

-- テーブルへの基本的な権限付与
GRANT
SELECT
,
  INSERT,
UPDATE,
DELETE ON employees TO praha_user,
tokyo_user,
osaka_user;

GRANT
SELECT
,
  INSERT,
UPDATE,
DELETE ON projects TO praha_user,
tokyo_user,
osaka_user;

GRANT
SELECT
  ON tenants TO praha_user,
  tokyo_user,
  osaka_user;

GRANT USAGE ON SEQUENCE employees_id_seq TO praha_user,
tokyo_user,
osaka_user;

GRANT USAGE ON SEQUENCE projects_id_seq TO praha_user,
tokyo_user,
osaka_user;

-- RLS（Row Level Security）の設定
ALTER TABLE employees ENABLE ROW LEVEL SECURITY;

ALTER TABLE projects ENABLE ROW LEVEL SECURITY;

-- RLSポリシーを作成
-- 各テナントのユーザーは自分のテナントのデータのみアクセス可能
CREATE POLICY employees_tenant_policy ON employees FOR ALL TO praha_user USING (
  tenant_id = (
    SELECT
      id
    FROM
      tenants
    WHERE
      name = 'praha'
  )
);

CREATE POLICY employees_tenant_policy_tokyo ON employees FOR ALL TO tokyo_user USING (
  tenant_id = (
    SELECT
      id
    FROM
      tenants
    WHERE
      name = 'tokyo'
  )
);

CREATE POLICY employees_tenant_policy_osaka ON employees FOR ALL TO osaka_user USING (
  tenant_id = (
    SELECT
      id
    FROM
      tenants
    WHERE
      name = 'osaka'
  )
);

-- プロジェクトテーブルのポリシー
CREATE POLICY projects_tenant_policy ON projects FOR ALL TO praha_user USING (
  tenant_id = (
    SELECT
      id
    FROM
      tenants
    WHERE
      name = 'praha'
  )
);

CREATE POLICY projects_tenant_policy_tokyo ON projects FOR ALL TO tokyo_user USING (
  tenant_id = (
    SELECT
      id
    FROM
      tenants
    WHERE
      name = 'tokyo'
  )
);

CREATE POLICY projects_tenant_policy_osaka ON projects FOR ALL TO osaka_user USING (
  tenant_id = (
    SELECT
      id
    FROM
      tenants
    WHERE
      name = 'osaka'
  )
);

-- 管理者ユーザー（postgres）は全てのデータにアクセス可能
ALTER TABLE employees FORCE ROW LEVEL SECURITY;

ALTER TABLE projects FORCE ROW LEVEL SECURITY;