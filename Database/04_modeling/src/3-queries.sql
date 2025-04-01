-- 1. スラック連携登録時のトランザクション
-- 1.1. ワークスペースの作成
INSERT INTO
  workspaces (slack_app_token, slack_bot_token)
VALUES
  ('HOGE_APP_TOKEN', 'HOGE_BOT_TOKEN');

-- 2. タスク設定時のトランザクション
-- 2.1. タスクの作成
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
  ) RETURNING id;

-- 2.2. タスクステータスの初期設定
INSERT INTO
  task_statuses (task_id, is_completed, completed_at)
VALUES
  (1, false, NULL);

-- 2.3. 通知設定の作成
INSERT INTO
  notification_configs (task_id, frequency_type, frequency_value)
VALUES
  (1, 'DAILY', 1);

-- 2.4. 通知スケジュールの作成
INSERT INTO
  notification_schedules (task_id, scheduled_time)
VALUES
  (1, CURRENT_TIMESTAMP + INTERVAL '1 day');

-- 3. 1時間ごとのバッチ処理のトランザクション
-- 3.1. 通知対象のタスクを取得
SELECT
  t.id as task_id,
  t.workspace_id,
  t.notifier_slack_id,
  t.recipient_slack_id,
  t.channel_id,
  t.message,
  nc.frequency_type,
  nc.frequency_value,
  ns.scheduled_time
FROM
  tasks t
  JOIN notification_configs nc ON t.id = nc.task_id
  JOIN notification_schedules ns ON t.id = ns.task_id
  JOIN task_statuses ts ON t.id = ts.task_id
WHERE
  ts.is_completed = false
  AND ns.scheduled_time <= CURRENT_TIMESTAMP + INTERVAL '1 hour'
  AND ns.scheduled_time > CURRENT_TIMESTAMP;

-- 3.2. 次回通知時間の更新
UPDATE notification_schedules
SET
  scheduled_time = scheduled_time + INTERVAL '1 day',
  updated_at = CURRENT_TIMESTAMP
WHERE
  task_id = 1;

-- 4. タスク完了時の更新トランザクション
-- 4.1. 完了ステータスの更新
UPDATE task_statuses
SET
  is_completed = true,
  completed_at = CURRENT_TIMESTAMP
WHERE
  task_id = 1;