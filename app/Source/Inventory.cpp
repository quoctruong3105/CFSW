#include "Include/Inventory.h"
#include <QDebug>

QString Inventory::M_COMP_KEY = "mComp";
QString Inventory::L_COMP_KEY = "lComp";
QMap<int, int> Inventory::refMaterialMap;
QMap<QString, QMap<QString, QMap<int, int>>> Inventory::drinkCompMap;
QMap<QString, int> Inventory::tpQntyPerDrkMap;

Inventory::Inventory(QObject *parent) : QObject{parent}
{
    if(refMaterialMap.isEmpty()) {
        fetchMaterial();
    }
    if(drinkCompMap.isEmpty()) {
        fetchDrinkComp();
    }
    if(tpQntyPerDrkMap.isEmpty()) {
        fetchTpPerDrk();
    }
}

bool Inventory::getDrinkState(const QString &drinkName, const bool &isSizeL)
{
    QMap<int, int> tempCompMap = drinkCompMap.value(drinkName).value(isSizeL ? L_COMP_KEY : M_COMP_KEY);
    for (auto comp = tempCompMap.begin(); comp != tempCompMap.end(); ++comp) {
        if(refMaterialMap.value(comp.key()) < comp.value()) {
            qDebug() << "There isn't enough: " << comp.key();
            return false;
        }
    }
    return true;
}

void Inventory::updateItemQuantityToDB(const QString &itemType, const int& amount, const QString &itemName)
{
    QString colName = (itemType == "material") ? QString(itemType + "_id") : QString(itemType);
    QString tableName = QString(itemType + "s");
    QSqlQuery query;
    query.prepare(QString("UPDATE %1 SET quantity = quantity - :amount WHERE %2 = :itemName")
                      .arg(tableName)
                      .arg(colName));
    query.bindValue(":amount", amount);
    query.bindValue(":itemName", itemName);

    if (query.exec()) {
        qDebug() << "Query executed successfully.";
    } else {
        qDebug() << "Query failed";
    }
}

QMap<int, int> Inventory::getDrinkComp(const QString &drinkName, const bool &isSizeL)
{
    QMap<QString, QMap<int, int>> tempMap = drinkCompMap[drinkName];
    if(isSizeL) {
        return tempMap[L_COMP_KEY];
    } else {
        return tempMap[M_COMP_KEY];
    }
}

int Inventory::getToppingQntyPerDrink(const QString &toppingName)
{
    return tpQntyPerDrkMap.value(toppingName);
}

void Inventory::fetchMaterial()
{
    refMaterialMap.clear();
    QSqlQuery query;
    query.exec(QString("SELECT material_id, quantity FROM materials"));
    while(query.next()) {
        refMaterialMap.insert(query.value(0).toInt(), query.value(1).toInt());
    }
}

void Inventory::fetchTpPerDrk()
{
    tpQntyPerDrkMap.clear();
    QSqlQuery query;
    query.exec(QString("SELECT topping, quantity_per_drink FROM toppings"));
    while(query.next()) {
        tpQntyPerDrkMap.insert(query.value(0).toString(), query.value(1).toInt());
    }
}

void Inventory::fetchDrinkComp()
{
    QSqlQuery query;
    query.exec(QString("SELECT drink, m_comps, l_comps FROM drinks"));
    while(query.next()) {
        QMap<QString, QMap<int, int>> compMap;
        QString drinkName = query.value(0).toString();
        QByteArray mJsonBytes = query.value(1).toByteArray();
        QJsonDocument mJsonDoc = QJsonDocument::fromJson(mJsonBytes);
        QByteArray lJsonBytes = query.value(2).toByteArray();
        QJsonDocument lJsonDoc = QJsonDocument::fromJson(lJsonBytes);

        if(!mJsonDoc.isNull() && mJsonDoc.isObject()) {
            QJsonObject jsonObj = mJsonDoc.object();
            QMap<int, int> tempMap;
            for(auto it = jsonObj.begin(); it != jsonObj.end(); ++it) {
                int id = it.key().toInt();
                int quantity = it.value().toInt();
                tempMap[id] = quantity;
            }
            compMap[M_COMP_KEY] = tempMap;
        }
        if(!lJsonDoc.isNull() && lJsonDoc.isObject()) {
            QJsonObject jsonObj = lJsonDoc.object();
            QMap<int, int> tempMap;
            for(auto it = jsonObj.begin(); it != jsonObj.end(); ++it) {
                int id = it.key().toInt();
                int quantity = it.value().toInt();
                tempMap[id] = quantity;
            }
            compMap[L_COMP_KEY] = tempMap;
        }
        drinkCompMap[drinkName] = compMap;
    }
}
