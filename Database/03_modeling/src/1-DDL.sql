CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE directories (
    id SERIAL PRIMARY KEY,
    created_by INTEGER NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (created_by) REFERENCES users(id)
);

CREATE TABLE directory_changes (
    id SERIAL PRIMARY KEY,
    directory_id INTEGER NOT NULL,
    change_type VARCHAR(50) NOT NULL, -- 'CREATE', 'UPDATE', 'DELETE'
    changed_by INTEGER NOT NULL,
    changed_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (directory_id) REFERENCES directories(id),
    FOREIGN KEY (changed_by) REFERENCES users(id)
);

CREATE TABLE directory_versions (
    id SERIAL PRIMARY KEY,
    directory_id INTEGER NOT NULL,
    name VARCHAR(255) NOT NULL,
    change_id INTEGER NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (directory_id) REFERENCES directories(id),
    FOREIGN KEY (change_id) REFERENCES directory_changes(id)
);

CREATE TABLE current_directory_versions (
    directory_id INTEGER PRIMARY KEY,
    version_id INTEGER NOT NULL,
    FOREIGN KEY (directory_id) REFERENCES directories(id),
    FOREIGN KEY (version_id) REFERENCES directory_versions(id)
);


CREATE TABLE directory_hierarchy (
    ancestor_id INTEGER NOT NULL,
    descendant_id INTEGER NOT NULL,
    depth INTEGER NOT NULL,
    created_by INTEGER NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (ancestor_id, descendant_id),
    FOREIGN KEY (ancestor_id) REFERENCES directories(id),
    FOREIGN KEY (descendant_id) REFERENCES directories(id),
    FOREIGN KEY (created_by) REFERENCES users(id)
);

CREATE TABLE directory_moves (
    id SERIAL PRIMARY KEY,
    target_directory_id INTEGER NOT NULL,
    from_parent_id INTEGER NOT NULL,
    to_parent_id INTEGER NOT NULL,
    created_by INTEGER NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (target_directory_id) REFERENCES directories(id),
    FOREIGN KEY (from_parent_id) REFERENCES directories(id),
    FOREIGN KEY (to_parent_id) REFERENCES directories(id),
    FOREIGN KEY (created_by) REFERENCES users(id)
);

CREATE TABLE documents (
    id SERIAL PRIMARY KEY,
    created_by INTEGER NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (created_by) REFERENCES users(id)
);

CREATE TABLE document_changes (
    id SERIAL PRIMARY KEY,
    document_id INTEGER NOT NULL,
    change_type VARCHAR(50) NOT NULL, -- 'CREATE', 'UPDATE', 'DELETE'
    changed_by INTEGER NOT NULL,
    changed_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (document_id) REFERENCES documents(id),
    FOREIGN KEY (changed_by) REFERENCES users(id)
);

CREATE TABLE document_versions (
    id SERIAL PRIMARY KEY,
    document_id INTEGER NOT NULL,
    name VARCHAR(255) NOT NULL,
    content TEXT NOT NULL,
    parent_directory_id INTEGER NOT NULL,
    change_id INTEGER NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (document_id) REFERENCES documents(id),
    FOREIGN KEY (parent_directory_id) REFERENCES directories(id),
    FOREIGN KEY (change_id) REFERENCES document_changes(id)
);

CREATE TABLE current_document_versions (
    document_id INTEGER PRIMARY KEY,
    version_id INTEGER NOT NULL,
    FOREIGN KEY (document_id) REFERENCES documents(id),
    FOREIGN KEY (version_id) REFERENCES document_versions(id)
);


CREATE INDEX idx_documents_created_by ON documents(created_by);
CREATE INDEX idx_document_versions_document_id ON document_versions(document_id);
CREATE INDEX idx_document_changes_document_id ON document_changes(document_id);
CREATE INDEX idx_document_changes_changed_by ON document_changes(changed_by);

CREATE INDEX idx_directories_created_by ON directories(created_by);
CREATE INDEX idx_directory_versions_directory_id ON directory_versions(directory_id);
CREATE INDEX idx_directory_changes_directory_id ON directory_changes(directory_id);
CREATE INDEX idx_directory_changes_changed_by ON directory_changes(changed_by);

CREATE INDEX idx_directory_hierarchy_ancestor ON directory_hierarchy(ancestor_id);
CREATE INDEX idx_directory_hierarchy_descendant ON directory_hierarchy(descendant_id);
CREATE INDEX idx_directory_moves_directory_id ON directory_moves(target_directory_id);
