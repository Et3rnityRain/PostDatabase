#ifndef POSTDATABASE_H
#define POSTDATABASE_H

#include <QtSql/QSqlDatabase>
#include <QtSql/QSqlError>
#include <QSqlQuery>
#include <QVariantList>
#include <QMessageBox>

class PostDatabase
{
public:
    PostDatabase();

    QSqlDatabase db;

    void addRecord(const QVariantList &data, QString tableName);
    void editRecord(const int id, const QVariantList &data, const QString tableName);

    const QStringList getColumnName(const QString tableName);
};

#endif // POSTDATABASE_H
