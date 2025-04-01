-- ワークスペース
CREATE TABLE
  workspaces (
    id SERIAL PRIMARY KEY,
    slack_app_token VARCHAR(256) NOT NULL,
    slack_bot_token VARCHAR(256) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
  );

-- タスク
CREATE TABLE
  tasks (
    id SERIAL PRIMARY KEY,
    workspace_id INTEGER NOT NULL REFERENCES workspaces (id) ON DELETE CASCADE,
    notifier_slack_id VARCHAR(64) NOT NULL,
    recipient_slack_id VARCHAR(64) NOT NULL,
    channel_id VARCHAR(64),
    message TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
  );

-- タスク完了状態
CREATE TABLE
  task_statuses (
    task_id INTEGER PRIMARY KEY REFERENCES tasks (id) ON DELETE CASCADE,
    is_completed BOOLEAN DEFAULT FALSE,
    completed_at TIMESTAMP NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
  );

-- 周期タイプ
CREATE TYPE frequency_type AS ENUM ('DAILY', 'WEEKLY', 'MONTHLY');

-- 通知設定
CREATE TABLE
  notification_configs (
    id SERIAL PRIMARY KEY,
    task_id INTEGER NOT NULL REFERENCES tasks (id) ON DELETE CASCADE,
    frequency_type frequency_type NOT NULL,
    frequency_value INTEGER NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
  );

-- 通知スケジュール
CREATE TABLE
  notification_schedules (
    task_id INTEGER PRIMARY KEY REFERENCES tasks (id) ON DELETE CASCADE,
    next_notify_at TIMESTAMP NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
  );

-- インデックス
CREATE INDEX idx_tasks_workspace_id ON tasks (workspace_id);

CREATE INDEX idx_notify_schedules_next_notify_at ON notification_schedules (next_notify_at);

CREATE INDEX idx_task_statuses_is_completed ON task_statuses (is_completed);

CREATE INDEX idx_notification_configs_task_id ON notification_configs (task_id);