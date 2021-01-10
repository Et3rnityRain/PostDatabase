#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include "postdatabase.h"
#include <QMainWindow>
#include <QMessageBox>
#include <QSqlTableModel>
#include <QSqlRecord>
#include <QTableView>
#include <QLayout>
#include <QLabel>
#include <QLineEdit>
#include <QPushButton>

QT_BEGIN_NAMESPACE
namespace Ui { class MainWindow; }
QT_END_NAMESPACE

class MainWindow : public QMainWindow
{
    Q_OBJECT

public:
    MainWindow(QWidget *parent = nullptr);
    ~MainWindow();

    PostDatabase postdatabase;
    QString current_table;
    int current_row;

    QVariantList data;
    QSqlTableModel *model;
    QTableView *view;
    QWidget *window;

private slots:
    void slot_addRecord();
    void slot_editRecord();
    void slot_removeRecord();
    void slot_contextMenu(QPoint pos);
    void slot_edit();
    void slot_add();
    void slot_closeWindow();
    void slot_changeTable(const QString &text);

private:
    Ui::MainWindow *ui;
    void showTable(const QString &tableName, const QStringList &headers);
    void update();
};
#endif // MAINWINDOW_H
