#ifndef DATA_H
#define DATA_H

#include <QObject>
#include <QSqlDatabase>
#include <QSqlError>
#include <QSqlQuery>
#include <QSqlQueryModel>
#include <QVariantMap>
#include <QList>

class DataHandle : public QObject
{
    Q_OBJECT
public:
    DataHandle(QObject *parent = nullptr);
signals:
public slots:
    void exeQuery(QString str, QString tableName);

    QVariantMap getItemList(int i);
    int getItemListLength();
    void clearData();
private:
    static QSqlDatabase* db;
    QList<QVariantMap> itemList;
//    QList<QVariantMap> cakeList;
//    QList<QVariantMap> toppingList;
    void connect();
    void disconnect();
};

#endif // DATA_H
