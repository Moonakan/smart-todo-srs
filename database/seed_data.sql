-- Тестовые (вымышленные) данные для SQLite.
-- Выполнять ПОСЛЕ schema.sql на новой пустой базе данных.
PRAGMA foreign_keys = ON;
BEGIN TRANSACTION;

INSERT INTO Users (user_id, username, display_name) VALUES
(1, 'Moonakan', 'Комлев Александр Алексеевич'),
(2, 'demo_guest', 'Учебный пользователь');

INSERT INTO CollectionTypes (type_id, code, name) VALUES
(1, 'book', 'Книга'),
(2, 'vinyl', 'Винил'),
(3, 'movie', 'Фильм'),
(4, 'game', 'Игра');

INSERT INTO ItemStatuses (status_id, code, name) VALUES
(1, 'owned', 'В коллекции'),
(2, 'wishlist', 'Хочу приобрести');

INSERT INTO CreatorRoles (role_id, code, name) VALUES
(1, 'author', 'Автор'),
(2, 'artist', 'Исполнитель'),
(3, 'director', 'Режиссёр'),
(4, 'developer', 'Разработчик');

INSERT INTO Creators (creator_id, full_name) VALUES
(1, 'Алексей Орлов'),
(2, 'Мария Лебедева'),
(3, 'Группа «Север»'),
(4, 'Павел Миронов'),
(5, 'Студия «Маяк»'),
(6, 'Елена Ветрова');

INSERT INTO Items (item_id, owner_id, type_id, status_id, title, release_year, notes) VALUES
(1, 1, 1, 1, 'Туман над рекой', 2022, 'Тестовый пример книги'),
(2, 1, 2, 1, 'Ночной город', 2020, 'Тестовая виниловая пластинка'),
(3, 1, 3, 1, 'Предел маршрута', 2023, 'Тестовый пример фильма'),
(4, 1, 4, 2, 'Космическая станция', 2024, 'Тестовая игра для списка желаний'),
(5, 1, 1, 2, 'Остров маяков', 2018, 'Ещё одна тестовая книга'),
(6, 1, 2, 2, 'Листопад', 2019, 'Тестовая пластинка для списка желаний'),
(7, 1, 3, 1, 'Письма в пути', 2021, 'Второй тестовый фильм'),
(8, 2, 4, 1, 'Карта будущего', 2025, 'Игра демонстрационного пользователя');

INSERT INTO ItemCreators (item_id, creator_id, role_id) VALUES
(1, 1, 1),
(1, 2, 1),
(2, 3, 2),
(3, 4, 3),
(4, 5, 4),
(5, 6, 1),
(6, 3, 2),
(7, 4, 3),
(8, 5, 4);

COMMIT;
