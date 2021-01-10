#include "postdatabase.h"

PostDatabase::PostDatabase()
{
    db = QSqlDatabase::addDatabase("QMYSQL");
    db.setHostName("localhost");
    db.setDatabaseName("postdatabase");
    db.setUserName("root");
    db.setPassword("7187");

    if(!db.open())
        QMessageBox::critical(NULL, QObject::tr("Ошибка подключения к базе данных!"), db.lastError().text());
}

void PostDatabase::addRecord(const QVariantList &data, QString tableName)
{
    QSqlQuery query;
    QString command = "INSERT INTO " + tableName + " (";
    QStringList columnNames = getColumnName(tableName);

    for(int i = 1; i < columnNames.size(); i++) {
        command += columnNames[i];
        if (i + 1 != columnNames.size())
            command += ", ";
        else
            command += ") VALUES (";
    }

    for(int i = 1; i < columnNames.size(); i++) {
        command += "?";
        if (i + 1 != columnNames.size())
            command += ", ";
        else
            command += ");";
    }

    query.prepare(command);

    for(int i = 0; i < columnNames.size() - 1; i++) {
        query.addBindValue(data[i]);
    }

    if(!query.exec()) {
        QMessageBox::critical(NULL, QObject::tr("Ошибка при выполнении команды UPDATE!"), query.lastError().text());
    }
}

void PostDatabase::editRecord(const int id, const QVariantList &data, const QString tableName)
{
    QSqlQuery query;
    QString command = "UPDATE " + tableName + " SET ";
    QStringList columnNames = getColumnName(tableName);

    for(int i = 1; i < columnNames.size(); i++) {
        command += columnNames[i] + " = ?";
        if (i + 1 != columnNames.size())
            command += ", ";
    }

    command += " WHERE " + columnNames[0] + " = ?;";

    query.prepare(command);

    for(int i = 1; i < columnNames.size(); i++) {
        query.addBindValue(data[i - 1]);
    }

    query.addBindValue(id);

    if(!query.exec()) {
        QMessageBox::critical(NULL, QObject::tr("Ошибка при выполнении команды UPDATE!"), query.lastError().text());
    }
}

const QStringList PostDatabase::getColumnName(const QString tableName)
{
    QStringList columns;

    if(tableName == "Users")
        columns << "userID" << "userName" << "userAge";
    else if(tableName == "Couriers")
        columns << "courierID" << "courierName" << "courierAge" << "departureID";
    else if(tableName == "Employees")
        columns << "employeeID" << "employeeName" << "employeeAge" << "officeID";
    else if(tableName == "Cities")
        columns << "cityID" << "cityName" << "countryID";
    else if(tableName == "Countries")
        columns << "countryID" << "countryName";
    else if(tableName == "PostOffices")
        columns << "officeID" << "address" << "cityID";
    else if(tableName == "Letters")
        columns << "letterID" << "userID" << "officeID" << "departureID";
    else if(tableName == "Packages")
        columns << "packageID" << "size" << "comments" << "officeID" << "userID" << "departureID";
    else if(tableName == "DepartureInformation")
        columns << "departureID" << "departureAddress" << "receivingAddress" << "sender" << "departureType" << "weight" << "courierID";
    else if(tableName == "Reviews")
        columns << "reviewID" << "description" << "rating" << "reviewDate" << "courierID" << "userID";

    return columns;
}
