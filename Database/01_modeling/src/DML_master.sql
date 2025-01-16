DO $$
DECLARE
    nigiri_category UUID;
    donburi_category UUID;
    side_menu_category UUID;

    -- Menu UUIDs
    hana_menu UUID; -- セットメニュー
    seafood_don_menu UUID;
    tamago_menu UUID;
    maguro_menu UUID;
    salmon_menu UUID;
    shrimp_menu UUID;

    -- Set Menu Items UUIDs
    hana_set_item_1 UUID;
    hana_set_item_2 UUID;
    hana_set_item_3 UUID;

    -- Order UUIDs
    yamada_order UUID;

    -- Order Item UUIDs
    yamada_order_item UUID;

    -- Rice Size UUIDs
    rice_size_small UUID;
    rice_size_normal UUID;
    rice_size_large UUID;

BEGIN
    -- Insert Categories
    INSERT INTO m_category (id, name, created_at, updated_at) 
    VALUES (uuid_generate_v4(), 'にぎり', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
    RETURNING id INTO nigiri_category;

    INSERT INTO m_category (id, name, created_at, updated_at) 
    VALUES (uuid_generate_v4(), '鮨丼', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
    RETURNING id INTO donburi_category;

    INSERT INTO m_category (id, name, created_at, updated_at) 
    VALUES (uuid_generate_v4(), 'サイドメニュー', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
    RETURNING id INTO side_menu_category;

    -- Insert Rice Sizes
    INSERT INTO m_rice_size (id, size, created_at, updated_at) 
    VALUES (uuid_generate_v4(), '小', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
    RETURNING id INTO rice_size_small;

    INSERT INTO m_rice_size (id, size, created_at, updated_at) 
    VALUES (uuid_generate_v4(), '普通', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
    RETURNING id INTO rice_size_normal;

    INSERT INTO m_rice_size (id, size, created_at, updated_at) 
    VALUES (uuid_generate_v4(), '大', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
    RETURNING id INTO rice_size_large;

    -- Insert Menu Items
    INSERT INTO m_menu (id, name, category_id, price, is_set_menu, created_at, updated_at) 
    VALUES (uuid_generate_v4(), 'はな', nigiri_category, 1000, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
    RETURNING id INTO hana_menu;

    INSERT INTO m_menu (id, name, category_id, price, is_set_menu, created_at, updated_at) 
    VALUES (uuid_generate_v4(), 'まぐろ', nigiri_category, 200, false, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
    RETURNING id INTO maguro_menu;

    INSERT INTO m_menu (id, name, category_id, price, is_set_menu, created_at, updated_at) 
    VALUES (uuid_generate_v4(), 'サーモン', nigiri_category, 300, false, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
    RETURNING id INTO salmon_menu;

    INSERT INTO m_menu (id, name, category_id, price, is_set_menu, created_at, updated_at) 
    VALUES (uuid_generate_v4(), 'エビ', nigiri_category, 400, false, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
    RETURNING id INTO shrimp_menu;

    INSERT INTO m_menu (id, name, category_id, price, is_set_menu, created_at, updated_at) 
    VALUES (uuid_generate_v4(), '海鮮丼', donburi_category, 500, false, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
    RETURNING id INTO seafood_don_menu;

    INSERT INTO m_menu (id, name, category_id, price, is_set_menu, created_at, updated_at) 
    VALUES (uuid_generate_v4(), '玉子', side_menu_category, 100, false, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
    RETURNING id INTO tamago_menu;

    -- Insert Set Menu Items
    INSERT INTO m_set_menu_item (id, set_menu_id, single_menu_id, quantity, created_at, updated_at)
    VALUES (uuid_generate_v4(), hana_menu, maguro_menu, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
    RETURNING id INTO hana_set_item_1;

    INSERT INTO m_set_menu_item (id, set_menu_id, single_menu_id, quantity, created_at, updated_at)
    VALUES (uuid_generate_v4(), hana_menu, salmon_menu, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
    RETURNING id INTO hana_set_item_2;

    INSERT INTO m_set_menu_item (id, set_menu_id, single_menu_id, quantity, created_at, updated_at)
    VALUES (uuid_generate_v4(), hana_menu, shrimp_menu, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
    RETURNING id INTO hana_set_item_3;
END $$;
