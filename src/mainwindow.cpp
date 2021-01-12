#include "mainwindow.h"
#include "ui_mainwindow.h"

MainWindow::MainWindow(QWidget *parent)
    : QMainWindow(parent)
    , ui(new Ui::MainWindow)
{
    ui->setupUi(this);

    current_table = "Users";
    showTable(current_table, postdatabase.getColumnName(current_table));

    ui->postTableView->setModel(model);
    ui->postTableView->setColumnHidden(0, true);

    ui->postTableView->setSelectionBehavior(QAbstractItemView::SelectRows);
    ui->postTableView->setSelectionMode(QAbstractItemView::SingleSelection);
    ui->postTableView->resizeColumnsToContents();
    ui->postTableView->setEditTriggers(QAbstractItemView::NoEditTriggers);

    ui->postTableView->setContextMenuPolicy(Qt::CustomContextMenu);
    connect(ui->postTableView, SIGNAL(doubleClicked(QModelIndex)), this, SLOT(slot_editRecord()));
    connect(ui->postTableView, SIGNAL(customContextMenuRequested(QPoint)), this, SLOT(slot_contextMenu(QPoint)));
    connect(ui->addButton, SIGNAL(clicked()), this, SLOT(slot_addRecord()));
    connect(ui->comboBox, SIGNAL(currentIndexChanged(const QString)), this, SLOT(slot_changeTable(const QString)));


    ui->comboBox->setCurrentIndex(0);
}

void MainWindow::showTable(const QString &tableName, const QStringList &headers)
{
    model = new QSqlTableModel(this, postdatabase.db);
    view = ui->postTableView;

    model->setTable(tableName);
    model->select();

    for(int i = 0; i < model->columnCount(); i++) {
        model->setHeaderData(i, Qt::Horizontal, headers[i]);
    }
    model->setSort(0, Qt::AscendingOrder);

    ui->postTableView->setModel(model);
    ui->postTableView->setColumnHidden(0, true);
    view->show();
    postdatabase.db.close();
}

MainWindow::~MainWindow()
{
    delete ui;
}

void MainWindow::slot_addRecord()
{
    window = new QWidget;
    QGridLayout *layout = new QGridLayout;

    QLabel *label;
    QLineEdit *line;
    QPushButton *addButton = new QPushButton;
    QPushButton *cancelButton = new QPushButton;

    QStringList data = postdatabase.getColumnName(current_table);

    for (int i = 1; i < data.size(); i++)
    {
        label = new QLabel;
        line = new QLineEdit;
        label->setText(data.value(i));

        layout->addWidget(label, 0, i - 1);
        layout->addWidget(line, 1, i - 1);
    }

    addButton->setText("Добавить");
    cancelButton->setText("Отменить");

    layout->addWidget(addButton, 2, 0);
    layout->addWidget(cancelButton, 2, data.size() - 2);

    connect(addButton, SIGNAL(clicked()), this, SLOT(slot_add()));
    connect(cancelButton, SIGNAL(clicked()), this, SLOT(slot_closeWindow()));

    window->setLayout(layout);

    window->setWindowTitle("Добавить");
    window->show();
}

void MainWindow::slot_contextMenu(QPoint pos)
{
    QMenu *menu = new QMenu(this);

    QAction *editRecord = new QAction("Редактировать", this);
    QAction *deleteRecord = new QAction("Удалить", this);
    QAction *getUsersPosts = new QAction("Показать статистику пользователя", this);
    QAction *getCountOfPackagesInPO = new QAction("Показать число посылок каждого типа");

    connect(editRecord, SIGNAL(triggered()), this, SLOT(slot_editRecord()));
    connect(deleteRecord, SIGNAL(triggered()), this, SLOT(slot_removeRecord()));
    connect(getUsersPosts, SIGNAL(triggered()), this, SLOT(slot_getUsersPosts()));
    connect(getCountOfPackagesInPO, SIGNAL(triggered()), this, SLOT(slot_getCountOfPackagesInPO()));

    if(current_table == "Users") {
        menu->addAction(getUsersPosts);
        menu->addSeparator();
    }

    if(current_table == "PostOffices") {
        menu->addAction(getCountOfPackagesInPO);
        menu->addSeparator();
    }

    menu->addAction(editRecord);
    menu->addAction(deleteRecord);

    menu->popup(ui->postTableView->viewport()->mapToGlobal(pos));
}

void MainWindow::slot_editRecord()
{
    int row = ui->postTableView->currentIndex().row();

    if (row >= 0) {
        current_row = model->record(row).value(postdatabase.getColumnName(current_table).value(0)).toInt();
    }

    window = new QWidget;
    QGridLayout *layout = new QGridLayout;

    QLabel *label;
    QLineEdit *line;
    QPushButton *changeButton = new QPushButton;
    QPushButton *cancelButton = new QPushButton;

    QStringList data = postdatabase.getColumnName(current_table);

    for (int i = 1; i < data.size(); i++)
    {
        label = new QLabel;
        line = new QLineEdit;
        label->setText(data.value(i));
        line->setText(model->record(row).value(i).toString());

        layout->addWidget(label, 0, i - 1);
        layout->addWidget(line, 1, i - 1);
    }

    changeButton->setText("Изменить");
    cancelButton->setText("Отменить");

    layout->addWidget(cancelButton, 2, data.size() - 2);
    layout->addWidget(changeButton, 2, 0);

    connect(changeButton, SIGNAL(clicked()), this, SLOT(slot_edit()));
    connect(cancelButton, SIGNAL(clicked()), this, SLOT(slot_closeWindow()));

    window->setLayout(layout);

    window->setWindowTitle("Редактировать");
    window->show();
}

void MainWindow::slot_edit()
{
    for(int i = 1; i < window->layout()->count() - 2; i += 2) {
        QLineEdit *line = qobject_cast<QLineEdit *>(window->layout()->itemAt(i)->widget());
        data.append(line->text());
    }
    postdatabase.editRecord(current_row, data, current_table);
    data.clear();
    update();
    window->close();
}

void MainWindow::slot_add()
{
    for(int i = 1; i < window->layout()->count() - 2; i += 2) {
        QLineEdit *line = qobject_cast<QLineEdit *>(window->layout()->itemAt(i)->widget());
        data.append(line->text());
    }
    postdatabase.addRecord(data, current_table);
    data.clear();
    update();
    window->close();
}

void MainWindow::slot_getUsersPosts()
{
    int row = ui->postTableView->currentIndex().row();

    if (postdatabase.db.open()) {
        QString command = "call getUsersPosts(\'" + model->record(row).value(postdatabase.getColumnName(current_table).value(1)).toString() + "\');";

        QSqlQueryModel *selectTable = new QSqlQueryModel;
        selectTable->setQuery(command, postdatabase.db);

        ui->postTableView->setModel(selectTable);
        ui->postTableView->setColumnHidden(0, true);
        ui->postTableView->show();

        data.clear();
        update();
    }
}

void MainWindow::slot_getCountOfPackagesInPO()
{
    QString id = model->record(ui->postTableView->currentIndex().row()).value(postdatabase.getColumnName(current_table).value(0)).toString();

    if (postdatabase.db.open()) {
        QString command = "SELECT COUNT(size) AS little, (SELECT COUNT(size) FROM packages WHERE officeID =" + id
                + " AND size = 'средняя') AS middle, (SELECT COUNT(size) FROM packages WHERE officeID =" + id
                + " AND size = 'большая') AS big FROM packages WHERE officeID =  " + id
                + " AND size = 'малая';";

        QSqlQueryModel *selectTable = new QSqlQueryModel;
        selectTable->setQuery(command, postdatabase.db);

        ui->postTableView->setModel(selectTable);
        ui->postTableView->setColumnHidden(0, false);
        ui->postTableView->show();

        data.clear();
        update();
    }
}

void MainWindow::slot_closeWindow()
{
    window->close();
}

void MainWindow::slot_removeRecord()
{
    int row = ui->postTableView->currentIndex().row();
    if(row >= 0) {
        if (QMessageBox::warning(this,
                                 trUtf8("Удаление записи"),
                                 trUtf8("Вы уверены, что хотите удалить эту запись?"),
                                 QMessageBox::Yes | QMessageBox::No) == QMessageBox::No)
        {
            QSqlDatabase::database().rollback();
        } else {
            /* В противном случае производим удаление записи.
             * При успешном удалении обновляем таблицу.
             * */
            if(!model->removeRow(row)) {
                QMessageBox::warning(this,trUtf8("Уведомление"),
                                     trUtf8("Не удалось удалить запись.\n"
                                            "Возможно она используется другими таблицами.\n"
                                            "Проверьте все зависимости и повторите попытку."));
            }
            update();
        }
    }
}

void MainWindow::update()
{
    model->select();
    ui->postTableView->resizeColumnsToContents();
    postdatabase.db.close();
}

void MainWindow::slot_changeTable(const QString &text)
{
    current_table = text;
    postdatabase.db.open();
    showTable(current_table, postdatabase.getColumnName(current_table));
    ui->postTableView->resizeColumnsToContents();

}


