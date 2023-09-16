#include "Include/DataHandler.h"
#include <QDebug>

DataHandle::DataHandle(QObject *parent) : QObject{parent} {
    this->connect();
}

void DataHandle::exeQuery(QString str, QString tableName)
{
//    if(!db) {
//        this->connect();
//        qDebug() << "aaaa";
//    }

    bool dbIsOpen = db->open();

    if(!dbIsOpen) {
        qDebug() << "Database is closing";
        return;
    }

    if(tableName.isEmpty()) {
        return;
    }

    QSqlQuery query;

    if(str.isEmpty()) {
        query.exec(QString("SELECT * FROM %1").arg(tableName));
    } else {
        QString newStr;
        for(int i = 0; i < str.length(); ++i) {
            newStr += str[i];
            if(i < str.length() - 1) {
                newStr += "%";
            }
        }
        query.exec(QString("SELECT * FROM %1 WHERE alias LIKE '%%2%'").arg(tableName, newStr));
    }

    if(query.lastError().isValid()) {
        return;
    }

    while (query.next()) {
        QMap<QString, QVariant> map;
        bool pos = 1;
        if(tableName == "toppings") {
            pos = 0;
        }

        if(tableName == "accounts") {
            map.insert(query.value(pos).toString(), query.value(2).toString());
        } else {
            map.insert(query.value(pos).toString(), query.value(2).toInt());
        }

        for (auto it = map.begin(); it != map.end(); ++it) {
            QVariantMap itemMap;
            if(tableName == "drinks") {
                itemMap["drink"] = it.key();
            } else if(tableName == "cakes") {
                itemMap["cake"] = it.key();
            } else if(tableName == "toppings") {
                itemMap["topping"] = it.key();
            } else {
                itemMap["username"] = it.key();
                itemMap["password"] = it.value();
            }

            if(tableName != "accounts") {
                itemMap["cost"] = it.value();
            }
            itemList.append(itemMap);
        }
    }
}

QVariantMap DataHandle::getItemList(int i)
{
    return itemList.at(i);
}

int DataHandle::getItemListLength()
{
    return itemList.length();
}

void DataHandle::clearData()
{
    itemList.clear();
}


QSqlDatabase *DataHandle::db = nullptr;

void DataHandle::connect() {
    if(db) {
        return;
    }

//    qDebug() << "bbbb";

    db = new QSqlDatabase(QSqlDatabase::addDatabase("QPSQL"));
//    db->setHostName("113.172.103.8");
//    db->setPort(5432);
//    db->setDatabaseName("hi_cf_db");
//    db->setUserName("hicf3105");
//    db->setPassword("TruongquoC3105vt@#");
        db->setHostName("localhost");
        db->setPort(5432);
        db->setDatabaseName("cf_prj");
        db->setUserName("truong");
        db->setPassword("truong");
    if (!db->open()) {
        QSqlError error = db->lastError();
        qDebug() << "Error connecting to PostgreSQL:";
        qDebug() << "Connection Name:" << db->connectionName();
        qDebug() << "Connection Options:" << db->connectOptions();
        return;
    } else {
        qDebug() << "Connected to PostgreSQL!";
    }
}

void DataHandle::disconnect()
{
    if(db) {
        db->close();
        delete db;
        db = nullptr;
    }
}
