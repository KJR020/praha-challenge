-- スキーマの作成
CREATE SCHEMA IF NOT EXISTS public;

-- スキーマを設定
SET search_path TO public;

-- UUIDを生成するための拡張機能を有効化
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- テーブルの作成
CREATE TABLE m_category (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE m_menu (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(255) NOT NULL,
    category_id UUID,
    price INT NOT NULL,
    is_set_menu BOOLEAN NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (category_id) REFERENCES m_category(id)
);

CREATE TABLE m_set_menu_item (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    set_menu_id UUID NOT NULL,
    single_menu_id UUID NOT NULL,
    quantity INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (set_menu_id) REFERENCES m_menu(id),
    FOREIGN KEY (single_menu_id) REFERENCES m_menu(id)
);

CREATE TABLE t_order (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    customer_name VARCHAR(255) NOT NULL,
    phone_number VARCHAR(15) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE t_payment (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    order_id UUID NOT NULL,
    billing_amount INT NOT NULL,
    received_amount INT,
    paid_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES t_order(id)
);

CREATE TABLE t_order_item (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    order_id UUID NOT NULL,
    menu_id UUID NOT NULL,
    quantity INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES t_order(id),
    FOREIGN KEY (menu_id) REFERENCES m_menu(id)
);

CREATE TABLE m_rice_size (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    size VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE t_order_item_option (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    order_item_id UUID NOT NULL,
    is_wasabi BOOLEAN NOT NULL,
    rice_size_id UUID NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (order_item_id) REFERENCES t_order_item(id),
    FOREIGN KEY (rice_size_id) REFERENCES m_rice_size(id)
);

CREATE TABLE m_menu_history (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    operation VARCHAR(10) NOT NULL CHECK (operation IN ('INSERT', 'UPDATE', 'DELETE')),
    menu_id UUID NOT NULL,
    menu_name VARCHAR(255) NOT NULL,
    category_id UUID NOT NULL,
    category_name VARCHAR(255) NOT NULL,
    price INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- インデックスを作成ß
CREATE INDEX idx_m_set_menu_item_set_menu_id ON m_set_menu_item (set_menu_id);
CREATE INDEX idx_m_set_menu_item_single_menu_id ON m_set_menu_item (single_menu_id);

CREATE INDEX idx_t_payment_order_id ON t_payment (order_id);

CREATE INDEX idx_t_order_item_order_id ON t_order_item (order_id);
CREATE INDEX idx_t_order_item_menu_id ON t_order_item (menu_id);

CREATE INDEX idx_t_order_item_option_order_item_id ON t_order_item_option (order_item_id);

-- メニュー履歴用のトリガー関数を作成
CREATE OR REPLACE FUNCTION record_menu_history()
RETURNS TRIGGER AS $$
BEGIN
    IF (TG_OP = 'DELETE') THEN
        INSERT INTO m_menu_history (
            menu_id,
            menu_name,
            category_id,
            category_name,
            price,
            operation
        )
        SELECT
            OLD.id,
            OLD.name,
            OLD.category_id,
            c.name,
            OLD.price,
            'DELETE'
        FROM m_category c
        WHERE c.id = OLD.category_id;
        RETURN OLD;
    ELSE
        INSERT INTO m_menu_history (
            menu_id,
            menu_name,
            category_id,
            category_name,
            price,
            operation
        )
        SELECT
            NEW.id,
            NEW.name,
            NEW.category_id,
            c.name,
            NEW.price,
            TG_OP
        FROM m_category c
        WHERE c.id = NEW.category_id;
        RETURN NEW;
    END IF;
END;
$$ LANGUAGE plpgsql;


-- メニュー履歴用のトリガーを作成（INSERT用）
CREATE TRIGGER trigger_menu_history_insert
AFTER INSERT ON m_menu
FOR EACH ROW
EXECUTE FUNCTION record_menu_history();

-- メニュー履歴用のトリガーを作成（UPDATE用）
CREATE TRIGGER trigger_menu_history_update
AFTER UPDATE ON m_menu
FOR EACH ROW
EXECUTE FUNCTION record_menu_history();

-- メニュー履歴用のトリガーを作成（DELETE用）
CREATE TRIGGER trigger_menu_history_delete
AFTER DELETE ON m_menu
FOR EACH ROW
EXECUTE FUNCTION record_menu_history();

-- updated_at更新の関数を作成
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- 特定のテーブルに対してupdate_atを更新するトリガーを設定する関数を作成
CREATE OR REPLACE FUNCTION setup_update_trigger(table_name TEXT)
RETURNS VOID AS $$
BEGIN
    EXECUTE format('
        CREATE TRIGGER update_%I_updated_at
        BEFORE UPDATE ON %I
        FOR EACH ROW
        EXECUTE FUNCTION update_updated_at_column();
    ', table_name, table_name);
END;
$$ LANGUAGE plpgsql;

-- トリガーを設定する処理
DO $$
DECLARE
    table_names TEXT[] := ARRAY['t_order', 't_payment', 'm_menu', 'm_set_menu_item', 'm_category', 't_order_item', 't_order_item_option', 'm_rice_size'];
    table_name TEXT;
BEGIN
    FOREACH table_name IN ARRAY table_names
    LOOP
        PERFORM setup_update_trigger(table_name);
    END LOOP;
END;
$$;
