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
    void queryItem(QString str, QString tableName);
    void updateAccLog(bool, QString, QString);

    QVariantMap getItemList(int i);
    int getItemListLength();
    void clearData();

    void connect();
private:
    static QSqlDatabase* db;
    QList<QVariantMap> itemList;
    void disconnect();
};

#endif // DATA_H
