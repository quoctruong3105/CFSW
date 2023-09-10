#include "Include/DataHandler.h"
#include <QDebug>

DataHandle::DataHandle(QObject *parent) : QObject{parent} {
    this->connect();
}

void DataHandle::exeQuery(QString str)
{
    bool dbIsOpen = db->open();

    if(!dbIsOpen) {
        qDebug() << "Database is closing";
        return;
    }

    QSqlQuery query;
    drinkList.clear();

    if(str.isEmpty()) {
        query.exec("SELECT * FROM drinks");
    } else {
        QString newStr;
        for(int i = 0; i < str.length(); ++i) {
            newStr += str[i];
            if(i < str.length() - 1) {
                newStr += "%";
            }
        }
        qDebug() << newStr;
        query.exec(QString("SELECT * FROM drinks WHERE alias LIKE '%%1%'").arg(newStr));
    }

    if(query.lastError().isValid()) {
        return;
    }

    while (query.next()) {
        QMap<QString, int> drinkMap;
        drinkMap.insert(query.value(1).toString(), query.value(2).toInt());
        for (auto it = drinkMap.begin(); it != drinkMap.end(); ++it) {
            QVariantMap itemMap;
            itemMap["drink"] = it.key();
            itemMap["cost"] = it.value();
            drinkList.append(itemMap);
        }
    }
    for(int i = 0; i < drinkList.length(); i++) {
        qDebug() << drinkList.at(i);
    }
}

QVariantMap DataHandle::getDrinkList(int i)
{
    return drinkList.at(i);
}

int DataHandle::getDrinkListLength()
{
    return drinkList.length();
}


QSqlDatabase *DataHandle::db = nullptr;

void DataHandle::connect() {
    if(db) {
        return;
    }

    db = new QSqlDatabase(QSqlDatabase::addDatabase("QPSQL"));
    db->setHostName("127.0.0.1");
    db->setPort(5432);
    db->setDatabaseName("cf_prj");
    db->setUserName("truong");
    db->setPassword("truong");
    if (!db->open()) {
        QSqlError error = db->lastError();
        qDebug() << "Error connecting to PostgreSQL:";
        qDebug() << "Connection Name:" << db->connectionName();
        qDebug() << "Connection Options:" << db->connectOptions();
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
