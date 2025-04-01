-- サンプルワークスペース
INSERT INTO
  workspaces (slack_app_token, slack_bot_token)
VALUES
  ('ENCRYPTED_APP_TOKEN', 'ENCRYPTED_BOT_TOKEN');

-- サンプルタスク
INSERT INTO
  tasks (
    workspace_id,
    notifier_slack_id,
    recipient_slack_id,
    channel_id,
    message
  )
VALUES
  (
    1,
    'notifier_slack_id',
    'recipient_slack_id',
    'channel_id',
    'デイリースクラムの時間です'
  ),
  (
    1,
    'notifier_slack_id',
    'recipient_slack_id',
    'channel_id',
    '週次進捗報告が未提出です。penpen。'
  );

-- 通知設定
INSERT INTO
  notification_configs (task_id, frequency_type, frequency_value)
VALUES
  (1, 'DAILY', 1),
  (2, 'WEEKLY', 1);

-- 通知スケジュール
INSERT INTO
  notification_schedules (task_id, next_notify_at)
VALUES
  (1, CURRENT_TIMESTAMP + INTERVAL '1 day'),
  (2, CURRENT_TIMESTAMP + INTERVAL '7 days');

-- タスクステータス
INSERT INTO
  task_statuses (task_id, is_completed, completed_at)
VALUES
  (1, false, NULL),
  (2, false, NULL);
