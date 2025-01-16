DO $$
DECLARE
    order_1 UUID;
    order_2 UUID;
    order_3 UUID;
    order_4 UUID;
    order_5 UUID;

    item_1_1 UUID;
    item_2_1 UUID;
    item_3_1 UUID;
    item_3_2 UUID;
    item_4_1 UUID;
    item_5_1 UUID;

    option_1_1 UUID;
    option_2_1 UUID;
    option_3_1 UUID;
    option_3_2 UUID;
    option_4_1 UUID;
    option_5_1 UUID;

BEGIN
    -- 1. 1品のみの注文、セットメニューあり、支払い済み、お釣りなし
    INSERT INTO t_order (id, customer_name, phone_number, created_at, updated_at) 
    VALUES (uuid_generate_v4(), '山田一品', '090-1111-2222', CURRENT_TIMESTAMP - interval '4 months', CURRENT_TIMESTAMP - interval '4 months')
    RETURNING id INTO order_1;

    INSERT INTO t_order_item (id, order_id, menu_id, quantity, created_at, updated_at)
    VALUES (uuid_generate_v4(), order_1, (SELECT id FROM m_menu WHERE name = 'はな'), 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
    RETURNING id INTO item_1_1;

    INSERT INTO t_order_item_option (id, order_item_id, is_wasabi, rice_size_id, created_at, updated_at)
    VALUES (uuid_generate_v4(), item_1_1, true, (SELECT id FROM m_rice_size WHERE size = '普通'), CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
    RETURNING id INTO option_1_1;

    INSERT INTO t_payment (id, order_id, billing_amount, received_amount, paid_at, created_at, updated_at)
    VALUES (uuid_generate_v4(), order_1, 1000, 1000, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

    -- 2. 1品のみの注文、セットメニューあり、支払い済み、お釣りなし
    INSERT INTO t_order (id, customer_name, phone_number, created_at, updated_at) 
    VALUES (uuid_generate_v4(), '佐藤セット', '090-2222-3333', CURRENT_TIMESTAMP - interval '1 months', CURRENT_TIMESTAMP - interval '1 months')
    RETURNING id INTO order_2;

    INSERT INTO t_order_item (id, order_id, menu_id, quantity, created_at, updated_at)
    VALUES (uuid_generate_v4(), order_2, (SELECT id FROM m_menu WHERE name = 'はな'), 1, CURRENT_TIMESTAMP - interval '1 months', CURRENT_TIMESTAMP - interval '1 months')
    RETURNING id INTO item_2_1;

    INSERT INTO t_order_item_option (id, order_item_id, is_wasabi, rice_size_id, created_at, updated_at)
    VALUES (uuid_generate_v4(), item_2_1, true, (SELECT id FROM m_rice_size WHERE size = '普通'), CURRENT_TIMESTAMP - interval '1 months', CURRENT_TIMESTAMP - interval '1 months')
    RETURNING id INTO option_2_1;

    INSERT INTO t_payment (id, order_id, billing_amount, received_amount, paid_at, created_at, updated_at)
    VALUES (uuid_generate_v4(), order_2, 1000, 1000, CURRENT_TIMESTAMP - interval '1 months', CURRENT_TIMESTAMP - interval '1 months', CURRENT_TIMESTAMP - interval '1 months');

    -- 3. 2品の注文、セットメニューなし、支払い済み、お釣りなし
    INSERT INTO t_order (id, customer_name, phone_number, created_at, updated_at) 
    VALUES (uuid_generate_v4(), '鈴木二品', '090-4444-5555', CURRENT_TIMESTAMP - interval '2 months', CURRENT_TIMESTAMP - interval '2 months')
    RETURNING id INTO order_3;

    INSERT INTO t_order_item (id, order_id, menu_id, quantity, created_at, updated_at)
    VALUES (uuid_generate_v4(), order_3, (SELECT id FROM m_menu WHERE name = 'まぐろ'), 1, CURRENT_TIMESTAMP - interval '2 months', CURRENT_TIMESTAMP - interval '2 months')
    RETURNING id INTO item_3_1;

    INSERT INTO t_order_item_option (id, order_item_id, is_wasabi, rice_size_id, created_at, updated_at)
    VALUES (uuid_generate_v4(), item_3_1, true, (SELECT id FROM m_rice_size WHERE size = '普通'), CURRENT_TIMESTAMP - interval '2 months', CURRENT_TIMESTAMP - interval '2 months')
    RETURNING id INTO option_3_1;

    INSERT INTO t_order_item (id, order_id, menu_id, quantity, created_at, updated_at)
    VALUES (uuid_generate_v4(), order_3, (SELECT id FROM m_menu WHERE name = '玉子'), 1, CURRENT_TIMESTAMP - interval '2 months', CURRENT_TIMESTAMP - interval '2 months')
    RETURNING id INTO item_3_2;

    INSERT INTO t_order_item_option (id, order_item_id, is_wasabi, rice_size_id, created_at, updated_at)
    VALUES (uuid_generate_v4(), item_3_2, true, (SELECT id FROM m_rice_size WHERE size = '普通'), CURRENT_TIMESTAMP - interval '2 months', CURRENT_TIMESTAMP - interval '2 months')
    RETURNING id INTO option_3_2;

    INSERT INTO t_payment (id, order_id, billing_amount, received_amount, paid_at, created_at, updated_at)
    VALUES (uuid_generate_v4(), order_3, 300, 300, CURRENT_TIMESTAMP - interval '2 months', CURRENT_TIMESTAMP - interval '2 months', CURRENT_TIMESTAMP - interval '2 months');

    -- 4. 1品のみの注文、セットメニューなし、支払い済み、お釣りあり
    INSERT INTO t_order (id, customer_name, phone_number, created_at, updated_at) 
    VALUES (uuid_generate_v4(), '田中釣りあり', '090-6666-7777', CURRENT_TIMESTAMP - interval '3 month', CURRENT_TIMESTAMP - interval '3 month')
    RETURNING id INTO order_4;

    INSERT INTO t_order_item (id, order_id, menu_id, quantity, created_at, updated_at)
    VALUES (uuid_generate_v4(), order_4, (SELECT id FROM m_menu WHERE name = 'サーモン'), 3, CURRENT_TIMESTAMP - interval '3 month', CURRENT_TIMESTAMP - interval '3 month')
    RETURNING id INTO item_4_1;

    INSERT INTO t_order_item_option (id, order_item_id, is_wasabi, rice_size_id, created_at, updated_at)
    VALUES (uuid_generate_v4(), item_4_1, true, (SELECT id FROM m_rice_size WHERE size = '普通'), CURRENT_TIMESTAMP - interval '3 month', CURRENT_TIMESTAMP - interval '3 month')
    RETURNING id INTO option_4_1;

    INSERT INTO t_payment (id, order_id, billing_amount, received_amount, paid_at, created_at, updated_at)
    VALUES (uuid_generate_v4(), order_4, 900, 1000, CURRENT_TIMESTAMP - interval '3 month', CURRENT_TIMESTAMP - interval '3 month', CURRENT_TIMESTAMP - interval '3 month');

    -- 5. 1品のみの注文、セットメニューなし、支払い未
    INSERT INTO t_order (id, customer_name, phone_number, created_at, updated_at) 
    VALUES (uuid_generate_v4(), '小林未払い', '090-8888-9999', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
    RETURNING id INTO order_5;

    INSERT INTO t_order_item (id, order_id, menu_id, quantity, created_at, updated_at)
    VALUES (uuid_generate_v4(), order_5, (SELECT id FROM m_menu WHERE name = 'エビ'), 2, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
    RETURNING id INTO item_5_1;

    INSERT INTO t_order_item_option (id, order_item_id, is_wasabi, rice_size_id, created_at, updated_at)
    VALUES (uuid_generate_v4(), item_5_1, true, (SELECT id FROM m_rice_size WHERE size = '普通'), CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
    RETURNING id INTO option_5_1;

    INSERT INTO t_payment (id, order_id, billing_amount, created_at, updated_at) 
    VALUES (uuid_generate_v4(), order_5, 800, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP); -- 支払い未のため、received_amount, paid_atはNULL

END $$;
