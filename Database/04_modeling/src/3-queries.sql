-- スラック連携登録時のクエリ
INSERT INTO
  workspaces (slack_app_token, slack_bot_token)
VALUES
  ('HOGE_APP_TOKEN', 'HOGE_BOT_TOKEN');

-- タスク設定時のクエリ
-- 1. タスクの作成
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
    '通知メッセージ'
  );

-- 2. 初回通知のスケジュールの設定
INSERT INTO
  task_schedules (
    task_id,
    type_name,
    interval,
    scheduled_time,
    is_active
  )
VALUES
  (1, 'DAILY', 1, '2024-03-26 10:00:00', true);

-- 1hごとのバッチ通知のクエリ
SELECT
  t.id as task_id,
  t.workspace_id,
  t.notifier_slack_id,
  t.recipient_slack_id,
  t.channel_id,
  t.message,
  ts.type_name,
  ts.interval,
  ts.scheduled_time
FROM
  tasks t
  JOIN task_schedules ts ON t.id = ts.task_id
WHERE
  ts.is_active = true
  AND ts.scheduled_time <= '2024-03-26 10:30:00'
  AND ts.scheduled_time > '2024-03-26 09:30:00'
  AND NOT EXISTS (
    SELECT
      1
    FROM
      message_logs ml
    WHERE
      ml.task_id = t.id
      AND ml.message_type = 'completion'
  );

-- 完了時のタスク更新クエリ
-- 1. 完了ログの記録
INSERT INTO
  message_logs (task_id, message_type)
VALUES
  (1, 'COMPLETION');

-- 2. タスクの非アクティブ化
UPDATE task_schedules
SET
  is_active = false
WHERE
  task_id = 1;