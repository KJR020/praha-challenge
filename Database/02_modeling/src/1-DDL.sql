-- スキーマの作成
CREATE SCHEMA IF NOT EXISTS public;

-- スキーマを設定
SET search_path TO public;

-- UUIDを生成するための拡張機能を有効化
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- テーブルの作成

-- ユーザーテーブル(R)
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    username VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ワークスペーステーブル(R)
CREATE TABLE workspaces (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


-- ワークスペースメンバーテーブル(R)
CREATE TABLE workspace_members (
    workspace_id UUID NOT NULL REFERENCES workspaces(id),
    user_id UUID NOT NULL REFERENCES users(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (workspace_id, user_id)
);

CREATE INDEX idx_workspace_members_workspace_id ON workspace_members(workspace_id);
CREATE INDEX idx_workspace_members_user_id ON workspace_members(user_id);

-- ワークスペースメンバーイベント(E)
CREATE TABLE workspace_member_events (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    workspace_id UUID NOT NULL REFERENCES workspaces(id),
    user_id UUID NOT NULL REFERENCES users(id),
    event_type VARCHAR(50) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


-- チャンネルテーブル(R)
CREATE TABLE channels (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(255) NOT NULL,
    workspace_id UUID NOT NULL REFERENCES workspaces(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_channels_workspace_id ON channels(workspace_id);

-- チャンネルメンバーテーブル(R)
CREATE TABLE channel_members (
    channel_id UUID NOT NULL REFERENCES channels(id),
    user_id UUID NOT NULL REFERENCES users(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (channel_id, user_id)
);

-- チャンネルメンバーイベント(E)
CREATE TABLE channel_member_events ( 
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id),
    channel_id UUID NOT NULL REFERENCES channels(id),
    event_type VARCHAR(50) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


-- メッセージテーブル(R)
CREATE TABLE messages (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    channel_id UUID NOT NULL REFERENCES channels(id),
    posted_by UUID NOT NULL REFERENCES users(id),
    content TEXT NOT NULL,
    is_root BOOLEAN,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE INDEX idx_messages_channel_id ON messages(channel_id);
CREATE INDEX idx_messages_posted_by ON messages(posted_by);
CREATE INDEX idx_messages_created_at ON messages(created_at);

-- メッセージ階層構造(R)
CREATE TABLE  message_tree_paths (
    ancestor_id UUID NOT NULL REFERENCES messages(id),
    descendant_id UUID NOT NULL REFERENCES messages(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (ancestor_id, descendant_id)
);

CREATE INDEX idx_message_tree_paths_ancestor_id ON message_tree_paths(ancestor_id);

-- メッセージイベント(E)
CREATE TABLE message_events (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    message_id UUID NOT NULL REFERENCES messages(id),
    event_type VARCHAR(50) NOT NULL,
    user_id UUID NOT NULL REFERENCES users(id),
    content TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_message_events_message_created ON message_events(message_id, created_at DESC); 
