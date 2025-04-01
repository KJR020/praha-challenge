-- ワークスペース
CREATE TABLE
  workspaces (
    id SERIAL PRIMARY KEY,
    slack_app_token VARCHAR(50) NOT NULL,
    slack_bot_token VARCHAR(50) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
  );

-- 通知タスク（設定データ）
CREATE TABLE
  tasks (
    id SERIAL PRIMARY KEY,
    workspace_id INTEGER NOT NULL REFERENCES workspaces (id) ON DELETE CASCADE,
    notifier_slack_id VARCHAR(50) NOT NULL,
    recipient_slack_id VARCHAR(50) NOT NULL,
    channel_id VARCHAR(50),
    message TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
  );

-- 通知スケジュール（設定データ）
CREATE TYPE frequency_type AS ENUM ('DAILY', 'WEEKLY', 'MONTHLY');

CREATE TABLE
  task_schedules (
    id SERIAL PRIMARY KEY,
    task_id INTEGER NOT NULL REFERENCES tasks (id) ON DELETE CASCADE,
    type_name frequency_type NOT NULL,
    interval INTEGER NOT NULL,
    scheduled_time TIME NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
  );

-- タスクのステータス
CREATE TABLE
  task_statuses (
    id SERIAL PRIMARY KEY,
    task_id INTEGER UNIQUE NOT NULL REFERENCES tasks (id) ON DELETE CASCADE,
    next_notify_at TIMESTAMP NOT NULL,
    is_completed BOOLEAN DEFAULT FALSE,
    completed_at TIMESTAMP NULL,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
  );

-- メッセージログ
CREATE TYPE message_type AS ENUM ('REMINDER', 'COMPLETION');

CREATE TABLE
  message_logs (
    id SERIAL PRIMARY KEY,
    task_id INTEGER NOT NULL REFERENCES tasks (id) ON DELETE CASCADE,
    message_type message_type NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
  );

-- インデックス
CREATE INDEX idx_tasks_workspace_id ON tasks (workspace_id);

CREATE INDEX idx_task_schedules_task_id ON task_schedules (task_id);

CREATE INDEX idx_task_statuses_next_notify_at ON task_statuses (next_notify_at);

CREATE INDEX idx_message_logs_task_id ON message_logs (task_id);