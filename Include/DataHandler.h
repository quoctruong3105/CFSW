#ifndef DATA_H
#define DATA_H

#include <QObject>
#include <QSqlDatabase>
#include <QSqlError>
#include <QSqlQuery>
#include <QSqlQueryModel>
#include <QVariantMap>
#include <QList>
#include <QJsonDocument>
#include <QJsonArray>
#include <QJsonObject>


class DataHandle : public QObject
{
    Q_OBJECT
public:
    static QSqlDatabase* db;
    DataHandle(QObject *parent = nullptr);
    ~DataHandle();
signals:
public slots:
    // Query drinks, cakes, toppings, accounts valid
    void queryItem(QString str, QString tableName);
    // Update log in, log out time
    void updateAccLog(bool, QString, QString);
    // Query bill
    QList<QVariantMap> queryBill(QString);

    QVariantMap getItemList(int i);
    int getItemListLength();
    void clearData();
private:
    QList<QVariantMap> itemList;

    void connect();
    void disconnect();
};

#endif // DATA_H
