-- Примеры проверок и запросов после schema.sql и seed_data.sql.
PRAGMA foreign_keys = ON;

-- Контроль внешних ключей: результат должен быть пустым.
PRAGMA foreign_key_check;

-- Список таблиц (должно быть 7 пользовательских таблиц).
SELECT name FROM sqlite_master WHERE type = 'table' AND name NOT LIKE 'sqlite_%' ORDER BY name;

-- Количество предметов в демонстрационных данных: 8.
SELECT COUNT(*) AS items_count FROM Items;

-- Список книг владельца Moonakan (2 записи).
SELECT i.item_id, i.title, t.name AS item_type, s.name AS status
FROM Items i
JOIN Users u ON u.user_id = i.owner_id
JOIN CollectionTypes t ON t.type_id = i.type_id
JOIN ItemStatuses s ON s.status_id = i.status_id
WHERE u.username = 'Moonakan' AND t.code = 'book'
ORDER BY i.title;

-- Вещи в списке желаний владельца Moonakan (3 записи).
SELECT i.title, t.name AS type_name
FROM Items i
JOIN Users u ON u.user_id = i.owner_id
JOIN CollectionTypes t ON t.type_id = i.type_id
JOIN ItemStatuses s ON s.status_id = i.status_id
WHERE u.username = 'Moonakan' AND s.code = 'wishlist'
ORDER BY i.title;

-- Демонстрация M:N: создатели и роли у предмета 1 (2 строки).
SELECT i.title, c.full_name, r.name AS creator_role
FROM ItemCreators ic
JOIN Items i ON i.item_id = ic.item_id
JOIN Creators c ON c.creator_id = ic.creator_id
JOIN CreatorRoles r ON r.role_id = ic.role_id
WHERE i.item_id = 1
ORDER BY c.full_name;

-- Проверка существования индексов.
SELECT name, tbl_name FROM sqlite_master WHERE type='index' AND name LIKE 'idx_%' ORDER BY name;
