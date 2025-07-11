-- サンプルデータ挿入
INSERT INTO
  tenants (name)
VALUES
  ('praha'),
  ('tokyo'),
  ('osaka');

INSERT INTO
  employees (tenant_id, name)
VALUES
  -- praha テナントの従業員
  (1, '田中太郎'),
  (1, '佐藤花子'),
  (1, '山田次郎'),
  -- tokyo テナントの従業員
  (2, '鈴木一郎'),
  (2, '高橋美咲'),
  (2, '伊藤健太'),
  -- osaka テナントの従業員
  (3, '中村優子'),
  (3, '小林正人'),
  (3, '加藤雅子');

INSERT INTO
  projects (tenant_id, name)
VALUES
  -- praha テナントのプロジェクト
  (1, 'Webシステム開発'),
  (1, 'モバイルアプリ'),
  -- tokyo テナントのプロジェクト
  (2, 'データ分析基盤'),
  (2, 'AIチャットボット'),
  -- osaka テナントのプロジェクト
  (3, 'インフラ刷新'),
  (3, 'セキュリティ強化');