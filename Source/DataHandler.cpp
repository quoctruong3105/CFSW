#include "Include/DataHandler.h"
#include <QDebug>

DataHandle::DataHandle(QObject *parent) : QObject{parent} {
    this->connect();
}

DataHandle::~DataHandle()
{
    this->disconnect();
}

void DataHandle::queryItem(QString str, QString tableName)
{
    bool dbIsOpen = db->open();

    if(!dbIsOpen) {
        qDebug() << "Database is closing";
        return;
    }

    QString col1;
    QString col2;
    QSqlQuery query;

    if(tableName == "drinks") {
        col1 = "drink";
    } else if(tableName == "cakes") {
        col1 = "cake";
    } else if(tableName == "toppings") {
        col1 = "topping";
    } else if(tableName == "accounts") {
        col1 = "username";
        col2 = "password";
    }

    if(tableName != "accounts") {
        col2 = "cost";
    }

    if(str.isEmpty()) {
        query.exec(QString("SELECT %1, %2 FROM %3").arg(col1, col2, tableName));
    } else {
        QString newStr;
        for(int i = 0; i < str.length(); ++i) {
            newStr += str[i];
            if(i < str.length() - 1) {
                newStr += "%";
            }
        }
        query.exec(QString("SELECT drink, cost FROM %1 WHERE alias LIKE '%%2%'").arg(tableName, newStr));
    }

    if(query.lastError().isValid()) {
        return;
    }

    while (query.next()) {
        QMap<QString, QVariant> map;
        if(tableName == "accounts") {
            map.insert(query.value(0).toString(), query.value(1).toString());
        } else {
            map.insert(query.value(0).toString(), query.value(1).toInt());
        }

        for (auto it = map.begin(); it != map.end(); ++it) {
            QVariantMap itemMap;
            itemMap[col1] = it.key();
            itemMap[col2] = it.value();
            itemList.append(itemMap);
        }
    }
}

QString parseBillItem(QString str) {
    QJsonDocument jsonDoc = QJsonDocument::fromJson(str.toUtf8());
    QString itemString;
    if (!jsonDoc.isNull()) {
        QJsonArray jsonArray = jsonDoc.array();
        for (int j = 0; j < jsonArray.count(); j++) {
            QJsonObject obj = jsonArray[j].toObject();
            QString id = obj["id"].toString();
            QString name = obj["name"].toString();
            QString quantity = obj["quantity"].toString();
            QString size = obj["size"].toString();
            QString toppings;
            QJsonArray toppingsArray = obj["toppings"].toArray();
            for (int i = 0; i < toppingsArray.size(); ++i) {
                if (toppingsArray[i].isString()) {
                    toppings += toppingsArray[i].toString();
                    if (i < toppingsArray.size() - 1) {
                        toppings += ", ";
                    }
                }
            }
            itemString += QString("%1) %2 %3 (%4)").arg(id, quantity, name, size);
            if(!toppings.isEmpty()) {
                itemString += QString(", toppings: %1").arg(toppings);
            }
            itemString += " / ";
        }
    }
    qDebug() << itemString;
    return itemString;
}

QList<QVariantMap> DataHandle::queryBill(QString str)
{
    QList<QVariantMap> billInfo;
    QSqlQuery query;
    query.exec(QString("SELECT * FROM bills WHERE receipt_id LIKE '%1%'").arg(str));
    while (query.next()) {
        QVariantMap map;
        QString items = parseBillItem(query.value(3).toString());
        map.insert("recieptId", query.value(0).toString());
        map.insert("dateTime", query.value(1).toString());
        map.insert("cashier", query.value(2).toString());
        map.insert("items", items);
        map.insert("grandTotal", query.value(4).toInt());
        map.insert("cashReceive", query.value(5).toInt());
        map.insert("cashChange", query.value(6).toInt());
        map.insert("isCash", query.value(7).toBool());

        billInfo.append(map);
    }
    qDebug() << "sicc";
    return billInfo;
}

void DataHandle::updateAccLog(bool isLogIn, QString time, QString username)
{
    bool dbIsOpen = db->open();

    if(!dbIsOpen) {
        qDebug() << "Database is closing";
        return;
    }

    QSqlQuery query;
    QString colName = isLogIn ? "last_login" : "last_logout";

    query.prepare(QString("UPDATE accounts SET %1 = :time WHERE username = :username").arg(colName));
    query.bindValue(":time", time);
    query.bindValue(":username", username);

    if (!query.exec()) {
        qDebug() << "Error updating " << colName << ": " << query.lastError().text();
        return;
    }

    qDebug() << "Update successful";
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

    db = new QSqlDatabase(QSqlDatabase::addDatabase("QPSQL"));
    // remote
//    db->setHostName("45.124.95.171");
//    db->setPort(5432);
//    db->setDatabaseName("cf_prj");
//    db->setUserName("truong");
//    db->setPassword("12345");
    // local
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
