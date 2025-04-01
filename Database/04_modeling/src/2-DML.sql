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

-- タスクスケジュール
INSERT INTO
  task_schedules (
    task_id,
    type_name,
    interval,
    scheduled_time,
    is_active
  )
VALUES
  (1, 'DAILY', 1, CURRENT_TIMESTAMP, true),
  (2, 'WEEKLY', 1, CURRENT_TIMESTAMP, true);

-- サンプル送信済みメッセージログ
INSERT INTO
  message_logs (task_id, message_type)
VALUES
  (1, 'REMINDER'),
  (2, 'REMINDER'),
  (2, 'COMPLETION');