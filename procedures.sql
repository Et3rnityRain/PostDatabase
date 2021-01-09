USE postdatabase;

-- Индексы
CREATE INDEX rating ON reviews(rating);
SELECT * FROM reviews WHERE rating > 9;

CREATE INDEX employeeAge ON employees(employeeAge);
SELECT * FROM employees WHERE employeeAge = 24;

CREATE INDEX userName ON users(userName);
SELECT * FROM users WHERE userName = 'Neal434';

CREATE INDEX weight ON departureinformation(weight);
SELECT * FROM departureinformation WHERE weight > 1800;

CREATE INDEX size ON packages(size);
SELECT * FROM packages WHERE size = 'малая';

-- Процедуры
-- Показать пользователей с возрастом в выбранном промежутке
DELIMITER $$
CREATE PROCEDURE getUsersInAgeRange(in min_age int, in max_age int)
BEGIN 
	SELECT userName, userAge FROM users WHERE userAge BETWEEN min_age and max_age;
END $$
DELIMITER ;

call getUsersInAgeRange(20, 40);

-- Показать все посылки и письма у выбранного пользователя
DELIMITER $$
CREATE PROCEDURE getUsersPosts(in user_name varchar(100))
BEGIN 
	SELECT departureID, departureAddress, receivingAddress, departureType, weight FROM departureinformation 
	NATURAL JOIN letters NATURAL JOIN users WHERE userName = user_name 
	UNION SELECT departureID, departureAddress, receivingAddress, departureType, weight FROM departureinformation 
	NATURAL JOIN packages NATURAL JOIN users WHERE userName = user_name ORDER BY departureID;
END $$
DELIMITER ;

call getUsersPosts('Ayanna518');

-- Поиск комментариев по ключевому слову 
DELIMITER $$
CREATE PROCEDURE getAllCommentsWithStatement(in statement varchar(100))
BEGIN 
	SELECT * FROM reviews WHERE description REGEXP statement;
END $$
DELIMITER ;

call getAllCommentsWithStatement ('Хорош');

-- Функции
-- Определить тип посылки по ее весу
DELIMITER $$
CREATE DEFINER = `root`@`localhost` FUNCTION `PackageType`(weight int) 
RETURNS varchar(100) 
CHARSET utf8mb4 DETERMINISTIC
BEGIN 
	DECLARE packageType varchar(100);
	if (weight < 100) then
	set packageType = 'Малая посылка';
	elseif (weight < 500) then
    set packageType = 'Средняя посылка';
    elseif (weight >= 500) then
    set packageType = 'Большая посылка';
    end if;
    return(packageType);
END $$
DELIMITER ;

SELECT * FROM departureinformation WHERE PackageType(weight) = 'Средняя посылка';

-- Определить тип отзыва по его рейтингу
DELIMITER $$
CREATE DEFINER = `root`@`localhost` FUNCTION `ReviewType`(rating int) 
RETURNS varchar(100) 
CHARSET utf8mb4 DETERMINISTIC
BEGIN 
	DECLARE ReviewType varchar(100);
	if (rating < 3) then
	set ReviewType = 'Плохой отзыв';
	elseif (rating < 7) then
    set ReviewType = 'Средний отзыв';
    elseif (rating < 9) then
    set ReviewType = 'Хороший отзыв';
    elseif (rating >= 9) then
    set ReviewType = 'Отличный отзыв';
    end if;
    return(ReviewType);
END $$
DELIMITER ;

SELECT * FROM reviews WHERE ReviewType(rating) = 'Отличный отзыв';

-- Определить тип отзыва по его дате
DELIMITER $$
CREATE DEFINER = `root`@`localhost` FUNCTION `ReviewDateType`(reviewDate date) 
RETURNS varchar(100) 
CHARSET utf8mb4 DETERMINISTIC
BEGIN 
	DECLARE ReviewDateType varchar(100);
	if (reviewDate < '2010-01-01') then
	set ReviewDateType = 'Старый отзыв';
    elseif (reviewDate > '2010-01-01') then
    set ReviewDateType = 'Новый отзыв';
    end if;
    return(ReviewDateType);
END $$
DELIMITER ;

SELECT * FROM reviews WHERE ReviewDateType(reviewDate) = 'Новый отзыв';

-- Представления
-- Таблица адресов пользователей
CREATE VIEW UsersAddress
AS SELECT userName, departureAddress AS userAddress FROM users NATURAL JOIN packages NATURAL JOIN departureinformation 
UNION SELECT userName, departureAddress AS userAddress FROM users NATURAL JOIN letters NATURAL JOIN departureinformation ORDER BY userName;

SELECT * FROM UsersAddress;

-- Таблица лучших курьеров по среднему рейтингу
CREATE VIEW BestCouriers
AS SELECT courierName, AVG(rating) AS rating FROM couriers NATURAL JOIN reviews GROUP BY courierName ORDER BY 2 DESC;

SELECT * FROM BestCouriers;