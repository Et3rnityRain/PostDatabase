DROP DATABASE iF EXISTS otherDatabase;
CREATE DATABASE IF NOT EXISTS otherDatabase;
USE otherDatabase;

CREATE TABLE Electricity
(
electricityCheckID INT NOT NULL AUTO_INCREMENT,
electricityValue VARCHAR(100) NOT NULL,
price INT NOT NULL,
PRIMARY KEY (electricityCheckID)
);

CREATE TABLE Water
(
waterCheckID INT NOT NULL AUTO_INCREMENT,
waterValue VARCHAR(100) NOT NULL,
price INT NOT NULL,
PRIMARY KEY (waterCheckID)
);

CREATE TABLE HouseServices
(
houseCheckID INT NOT NULL AUTO_INCREMENT,
price INT NOT NULL,
PRIMARY KEY (houseCheckID)
);

CREATE TABLE Gas
(
gasCheckID INT NOT NULL AUTO_INCREMENT,
gasValue VARCHAR(100) NOT NULL,
price INT NOT NULL,
PRIMARY KEY (gasCheckID)
);

CREATE TABLE MyCheck
(
checkID INT NOT NULL AUTO_INCREMENT,
electricityCheckID INT NOT NULL,
waterCheckID INT NOT NULL,
houseCheckID INT NOT NULL,
gasCheckID INT NOT NULL,
PRIMARY KEY (checkID),
FOREIGN KEY (electricityCheckID) REFERENCES Electricity(electricityCheckID),
FOREIGN KEY (waterCheckID) REFERENCES Water(waterCheckID),
FOREIGN KEY (houseCheckID) REFERENCES HouseServices(houseCheckID),
FOREIGN KEY (gasCheckID) REFERENCES Gas(gasCheckID)
);

CREATE TABLE Users
(
userID INT NOT NULL AUTO_INCREMENT,
userName VARCHAR(100) NOT NULL,
age INT NOT NULL,
checkID INT,
PRIMARY KEY (userID),
FOREIGN KEY (checkID) REFERENCES MyCheck(checkID)
);

INSERT INTO Electricity(electricityValue, price) VALUES ('20 кВТ*ч', 120);
INSERT INTO Electricity(electricityValue, price) VALUES ('50 кВТ*ч', 150);
INSERT INTO Electricity(electricityValue, price) VALUES ('35 кВТ*ч', 170);
INSERT INTO Water(waterValue, price) VALUES ('21 м3', 200);
INSERT INTO Water(waterValue, price) VALUES ('28 м3', 300);
INSERT INTO Water(waterValue, price) VALUES ('29 м3', 250);
INSERT INTO Gas(gasValue, price) VALUES ('30 м3', 150);
INSERT INTO HouseServices(price) VALUES (550);
INSERT INTO Users(userName, age) VALUES ('Иванов Иван Иванович', 18);
INSERT INTO Users(userName, age) VALUES ('Петров Петр Петровч', 25);

ALTER TABLE Users ADD COLUMN profession VARCHAR(100) NOT NULL ;
ALTER TABLE Users ALTER COLUMN profession SET DEFAULT "Работник";
ALTER TABLE Water ADD INDEX new_index (waterCheckID);
ALTER TABLE Water RENAME INDEX new_index TO new_water_index;
ALTER TABLE Water DROP INDEX new_water_index;
ALTER TABLE Users DROP COLUMN profession;
ALTER TABLE Users COMMENT 'комментарий';
ALTER TABLE Users CHANGE COLUMN userName userName CHAR(100) NOT NULL;
ALTER TABLE Users DROP COLUMN userID, DROP PRIMARY KEY;
ALTER TABLE Users ADD COLUMN newUserID INT NOT NULL AUTO_INCREMENT, ADD PRIMARY KEY (`newUserID`);

RENAME TABLE Users TO _users;
RENAME TABLE HouseServices TO House;

drop table Electricity, Water, House, Gas, _users, MyCheck;

drop database otherDatabase;