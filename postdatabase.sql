DROP DATABASE IF EXISTS postDatabase;
CREATE DATABASE IF NOT EXISTS postDatabase;
USE postDatabase;

CREATE TABLE Countries
(
countriesID INT NOT NULL AUTO_INCREMENT,
countriesName VARCHAR(100) NOT NULL,
PRIMARY KEY (countriesID)
);

CREATE TABLE Cities
(
citiesID INT NOT NULL AUTO_INCREMENT,
citiesName VARCHAR(100) NOT NULL,
countriesID INT NOT NULL,
PRIMARY KEY (citiesID),
FOREIGN KEY (countriesID) REFERENCES Countries(countriesID)
);

CREATE TABLE PostOffices
(
officeID INT NOT NULL AUTO_INCREMENT,
address VARCHAR(100) NOT NULL, 
postIndex INT NOT NULL,
citiesID INT NOT NULL,
PRIMARY KEY (officeID),
FOREIGN KEY (citiesID) REFERENCES Cities(citiesID)
);

CREATE TABLE Employees
(
employeeID INT NOT NULL AUTO_INCREMENT,
employeeName VARCHAR(100) NOT NULL, 
age INT NOT NULL,
officeID INT NOT NULL,
PRIMARY KEY (employeeID),
FOREIGN KEY (officeID) REFERENCES PostOffices(officeID)
);

CREATE TABLE DepartureInformation
(
departureID INT NOT NULL AUTO_INCREMENT,
departureAddress VARCHAR(100) NOT NULL,
receivingAddress VARCHAR(100) NOT NULL,
sender VARCHAR (100) NOT NULL,
departureType VARCHAR(100) NOT NULL, 
weight VARCHAR(100) NOT NULL,
PRIMARY KEY (departureID)
);

CREATE TABLE Couriers
(
courierID INT NOT NULL AUTO_INCREMENT,
courierName VARCHAR(100) NOT NULL,
age INT NOT NULL,
departureID INT NOT NULL,
PRIMARY KEY (courierID),
FOREIGN KEY (departureID) REFERENCES DepartureInformation(departureID)
);

CREATE TABLE Users
(
userID INT NOT NULL AUTO_INCREMENT,
userName VARCHAR(100) NOT NULL,
age INT NOT NULL,
PRIMARY KEY (userID)
);

CREATE TABLE Reviews
(
reviewID INT NOT NULL AUTO_INCREMENT,
description VARCHAR(1000) NOT NULL,
rating INT NOT NULL,
reviewDate DATE NOT NULL,
courierID INT NOT NULL,
userID INT NOT NULL,
PRIMARY KEY (reviewID),
FOREIGN KEY (courierID) REFERENCES Couriers(courierID),
FOREIGN KEY (userID) REFERENCES Users(userID)
);

CREATE TABLE Letters
(
letterID INT NOT NULL AUTO_INCREMENT,
officeID INT NOT NULL,
userID INT NOT NULL,
departureID INT NOT NULL,
PRIMARY KEY (letterID),
FOREIGN KEY (officeID) REFERENCES PostOffices(officeID),
FOREIGN KEY (userID) REFERENCES Users(userID),
FOREIGN KEY (departureID) REFERENCES DepartureInformation(departureID)
);

CREATE TABLE Packages
(
packageID INT NOT NULL AUTO_INCREMENT,
size VARCHAR(100) NOT NULL,
comments VARCHAR(100) NOT NULL,
officeID INT NOT NULL,
userID INT NOT NULL,
departureID INT NOT NULL,
PRIMARY KEY (packageID),
FOREIGN KEY (officeID) REFERENCES PostOffices(officeID),
FOREIGN KEY (userID) REFERENCES Users(userID),
FOREIGN KEY (departureID) REFERENCES DepartureInformation(departureID)
);