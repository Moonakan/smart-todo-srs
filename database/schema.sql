-- Лабораторная работа №4. «Органайзер коллекций»
-- Автор: Комлев Александр Алексеевич
-- SQLite: реляционная схема в третьей нормальной форме (3NF).
-- Перед работой с БД в каждой новой сессии SQLite включайте FOREIGN KEYS:
PRAGMA foreign_keys = ON;

BEGIN TRANSACTION;

-- Владелец предметов. В учебном прототипе пользователь один,
-- но модель допускает добавление нескольких пользователей.
CREATE TABLE IF NOT EXISTS Users (
    user_id       INTEGER PRIMARY KEY AUTOINCREMENT,
    username      TEXT NOT NULL UNIQUE CHECK (length(trim(username)) > 0),
    display_name  TEXT NOT NULL CHECK (length(trim(display_name)) > 0),
    created_at    TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Справочник четырёх типов коллекций.
CREATE TABLE IF NOT EXISTS CollectionTypes (
    type_id       INTEGER PRIMARY KEY AUTOINCREMENT,
    code          TEXT NOT NULL UNIQUE,
    name          TEXT NOT NULL UNIQUE
);

-- Справочник статусов «В коллекции» / «Хочу приобрести».
CREATE TABLE IF NOT EXISTS ItemStatuses (
    status_id     INTEGER PRIMARY KEY AUTOINCREMENT,
    code          TEXT NOT NULL UNIQUE,
    name          TEXT NOT NULL UNIQUE
);

-- Авторы, исполнители, режиссёры и разработчики.
CREATE TABLE IF NOT EXISTS Creators (
    creator_id    INTEGER PRIMARY KEY AUTOINCREMENT,
    full_name     TEXT NOT NULL CHECK (length(trim(full_name)) > 0)
);

-- Справочник ролей создателей; роль зависит от произведения.
CREATE TABLE IF NOT EXISTS CreatorRoles (
    role_id       INTEGER PRIMARY KEY AUTOINCREMENT,
    code          TEXT NOT NULL UNIQUE,
    name          TEXT NOT NULL UNIQUE
);

-- Основные карточки предметов коллекции.
CREATE TABLE IF NOT EXISTS Items (
    item_id       INTEGER PRIMARY KEY AUTOINCREMENT,
    owner_id      INTEGER NOT NULL,
    type_id       INTEGER NOT NULL,
    status_id     INTEGER NOT NULL,
    title         TEXT NOT NULL CHECK (length(trim(title)) > 0),
    release_year  INTEGER CHECK (release_year IS NULL OR release_year BETWEEN 1 AND 2100),
    notes         TEXT NOT NULL DEFAULT '',
    created_at    TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at    TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (owner_id) REFERENCES Users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (type_id) REFERENCES CollectionTypes(type_id) ON DELETE RESTRICT,
    FOREIGN KEY (status_id) REFERENCES ItemStatuses(status_id) ON DELETE RESTRICT
);

-- Связь многие-ко-многим: один предмет может иметь нескольких создателей,
-- один создатель — участвовать в нескольких предметах и разных ролях.
CREATE TABLE IF NOT EXISTS ItemCreators (
    item_id       INTEGER NOT NULL,
    creator_id    INTEGER NOT NULL,
    role_id       INTEGER NOT NULL,
    PRIMARY KEY (item_id, creator_id, role_id),
    FOREIGN KEY (item_id) REFERENCES Items(item_id) ON DELETE CASCADE,
    FOREIGN KEY (creator_id) REFERENCES Creators(creator_id) ON DELETE RESTRICT,
    FOREIGN KEY (role_id) REFERENCES CreatorRoles(role_id) ON DELETE RESTRICT
);

-- Индексы для частых фильтров, сортировки и соединений.
CREATE INDEX IF NOT EXISTS idx_items_owner_type_status
    ON Items(owner_id, type_id, status_id);
CREATE INDEX IF NOT EXISTS idx_items_type_id ON Items(type_id);
CREATE INDEX IF NOT EXISTS idx_items_status_id ON Items(status_id);
CREATE INDEX IF NOT EXISTS idx_items_title ON Items(title);
CREATE INDEX IF NOT EXISTS idx_item_creators_creator_id
    ON ItemCreators(creator_id);
CREATE INDEX IF NOT EXISTS idx_item_creators_role_id
    ON ItemCreators(role_id);

COMMIT;
