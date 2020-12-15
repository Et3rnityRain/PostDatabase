USE postdatabase;
/* 
****** Запросы по функциональным требованиям ******
*/

-- Транзакционные:
-- 1. Добавить пользователя
INSERT INTO users (userName, age) VALUES ('Человек', '25');

-- 2. Удалить пользователя
DELETE FROM users WHERE userID = 11;

-- 3. Добавить письмо
INSERT INTO letters (officeID, userID, departureID) VALUES ('1', '1', '1');

-- 4. Удалить письмо
DELETE FROM letters WHERE letterID = 1;

-- 5. Добавить посылку
INSERT INTO packages (size, comments, officeID, userID, departureID) VALUES ('малая', 'Комментарий','1', '1', '1');

-- 6. Удалить посылку
DELETE FROM packages WHERE packageID = 1;

-- 7. Изменить размер посылки
UPDATE packages SET size = 'большая' WHERE packageID = 11;

-- 8. Добавить новое почтовое отделение
INSERT INTO postoffices (address, postIndex, citiesID) VALUES ('ул. Московская, 23а', '132132', '1');

-- 9. Принять на работу нового сотрудника
INSERT INTO employees (employeeName, age, officeID) VALUES ('Новый сотрудник', '30', '3');


-- Справочные:
-- 1. Показать статистику пользователя
SELECT * FROM departureinformation WHERE departureID IN (SELECT departureID FROM letters WHERE userID = 1) ORDER BY departureID;

-- 2. Показать статистику курьера
SELECT courierName, rating, description FROM couriers NATURAL JOIN reviews WHERE courierID = 1;

-- 3. Показать пользователей, которые работали с данным почтовым отделением
SELECT * FROM users WHERE userID IN (SELECT userID FROM letters WHERE officeID = 1) ORDER BY userName;

-- 4. Показать все города данной страны
SELECT * FROM cities WHERE countriesID = 1;

-- 5. Показать курьера, который доставлял данное письмо
SELECT courierName AS courier, age FROM couriers NATURAL JOIN departureinformation NATURAL JOIN letters WHERE letterID = 2;

-- 6. Показать все посылки, находящиеся в указанном почтовом отделении.
SELECT * FROM departureinformation WHERE departureID IN (SELECT departureID FROM letters WHERE officeID = 1) ORDER BY departureID;

-- Аналитические:
-- 1. Показать все отзывы, оставленные в заданный промежуток времени
SELECT * FROM reviews WHERE reviewDate BETWEEN '2019-01-01' AND '2020-01-01';

-- 2. Показать средний балл курьеров
SELECT courierID, courierName, AVG(rating) AS average_rate FROM couriers NATURAL JOIN reviews GROUP BY courierID;

-- 3. Показать число посылок каждого типа, находящихся в указанном почтовом отделении.
SELECT COUNT(size) AS little, 
(SELECT COUNT(size) FROM packages WHERE officeID = 1 AND size = 'средняя') AS middle, 
(SELECT COUNT(size) FROM packages WHERE officeID = 1 AND size = 'большая') AS big 
FROM packages WHERE officeID = 1 AND size = 'малая';

-- 4. Показать максимальную оценку у выбранного курьера
SELECT courierName, MAX(rating) FROM couriers NATURAL JOIN reviews WHERE courierID = 3;

-- 5. Показать средний вес посылки у пользователей
SELECT userID, userName, AVG(weight) AS average_weight FROM users NATURAL JOIN letters NATURAL JOIN departureinformation GROUP BY userName;

/* 
****** Другие запросы ******
*/

-- UPDATE
UPDATE users SET userName = 'Иванов Иван Петрович' WHERE userID = 12;
UPDATE couriers SET age = '20' WHERE courierID = 5;
UPDATE reviews SET rating = rating + 2 WHERE description = 'Хорошо!';
UPDATE employees SET employeeName = 'Петров Иван Петрович', age = '32' WHERE employeeID = 1;
UPDATE letters SET officeID = 2 WHERE userID = 1;
UPDATE packages SET officeID = 2 WHERE userID = 1 AND size = 'большая';

-- DELETE
DELETE FROM letters WHERE letterID = 11;
DELETE FROM courier WHERE age = 17;
DELETE FROM departureinformation WHERE sender = 'ОАО "Базы данных"';
DELETE FROM reviews WHERE reviewDate = '2015-01-01' AND userID = 1;
DELETE FROM reviews WHERE reviewDate = '2020-01-01';

-- SELECT, DISTINCT, WHERE, AND/OR/NOT, IN, BETWEEN, IS NULL, AS
SELECT DISTINCT address, postIndex FROM postoffices;
SELECT DISTINCT userName, age FROM users;
SELECT DISTINCT letterID, departureID FROM letters;
SELECT * FROM postoffices WHERE citiesID = 3;
SELECT * FROM cities WHERE countriesID > 1;
SELECT * FROM users WHERE age != 25;
SELECT * FROM users WHERE age != 25 AND userID > 3;
SELECT * FROM couriers WHERE courierID > 10 OR courierID < 7;
SELECT * FROM employees WHERE employeeID < 5 AND NOT employeeID = 3;
SELECT * FROM cities WHERE citiesID IN (3, 5, 10);
SELECT * FROM letters WHERE officeID IN (1, 3);
SELECT * FROM employees WHERE officeID IN (1, 2, 3) AND age < 40;
SELECT * FROM reviews WHERE rating BETWEEN 1 AND 5;
SELECT * FROM reviews WHERE rating BETWEEN 7 AND 10 AND courierID = 1;
SELECT * FROM letters WHERE departureID BETWEEN 1 AND 3;
SELECT * FROM postoffices WHERE citiesID IS NOT NULL;
SELECT * FROM users WHERE userName IS NOT NULL AND age < 25;
SELECT * FROM reviews WHERE description IS NULL;
SELECT userName AS USERS FROM users;
SELECT userName, age AS userAge FROM users;
SELECT userName AS Name, age AS Age FROM users;

-- LIKE
SELECT * FROM postoffices WHERE address LIKE '%ая%';
SELECT * FROM countries WHERE countriesName LIKE '%ия';
SELECT * FROM reviews WHERE description LIKE '%Хорошо%';
SELECT * FROM postoffices WHERE address LIKE '%7%';
SELECT * FROM reviews WHERE description LIKE 'Отл%';

-- COUNT, MAX, MIN, SUM, AVG
SELECT COUNT(*) AS letterCount FROM letters WHERE userID = 1;
SELECT COUNT(*) FROM packages WHERE userID = 3;
SELECT MAX(rating) FROM reviews;
SELECT MAX(rating) FROM reviews WHERE courierID = 3;
SELECT MIN(rating) FROM reviews;
SELECT MIN(rating) FROM reviews WHERE userId = 1;
SELECT AVG(rating) FROM reviews WHERE courierID = 2; 
SELECT AVG(rating) AS RATING FROM reviews; 

-- GROUP BY, HAVING
SELECT userName, MAX(age) AS max_age FROM users GROUP BY userName HAVING MAX(age) < 30;
SELECT courierName, MIN(rating) FROM reviews GROUP BY courierID;
SELECT employeeName, MIN(age) FROM employees GROUP BY employeeID HAVING MIN(age) < 30;
SELECT userID, AVG(rating) FROM reviews GROUP BY userID;

-- ORDER BY, ASC|DESC
SELECT * FROM users ORDER BY userName;
SELECT * FROM users ORDER BY userName DESC;
SELECT * FROM couriers ORDER BY age;
SELECT * FROM couriers ORDER BY age DESC;
SELECT * FROM reviews ORDER BY rating;

-- Вложенные SELECT
SELECT * FROM reviews WHERE rating = (SELECT MAX(rating) FROM reviews WHERE courierID = 1); 
SELECT description, rating FROM reviews WHERE reviewDate = (SELECT MIN(reviewDate) FROM reviews WHERE courierID BETWEEN 1 AND 7);

-- SELECT INTO
SELECT userName, age INTO `otherdatabase._users` FROM users WHERE userID > 5;

-- INSERT SELECT
INSERT INTO users (userName, age) SELECT courierName, age FROM couriers WHERE courierID = 1;

-- UNOIN
SELECT userName FROM users UNION SELECT courierName FROM couriers;
SELECT userName, userID FROM users UNION SELECT courierName, courierID FROM couriers UNION SELECT employeeName, employeeID FROM employees;

-- JOIN
SELECT citiesName, countriesName FROM cities A LEFT JOIN countries B ON A.countriesID = B.countriesID;
SELECT courierName, rating FROM couriers A LEFT JOIN reviews B ON A.courierID = B.courierID;
SELECT employeeName, address AS work_address, postIndex FROM employees A LEFT JOIN postoffices B ON A.officeID = B.officeID; 
SELECT * FROM letters A RIGHT JOIN users B ON A.userID = B.userID;
SELECT * FROM reviews NATURAL JOIN users;
SELECT * FROM letters NATURAL JOIN users;

-- LIMIT
SELECT * FROM users WHERE age > 25 LIMIT 3;
SELECT * FROM couriers WHERE courierID > 5 LIMIT 4;
SELECT * FROM users ORDER BY age LIMIT 3;
SELECT * FROM reviews WHERE rating > 5 LIMIT 10;
SELECT * FROM postoffices WHERE address LIKE '%ая%' LIMIT 3;