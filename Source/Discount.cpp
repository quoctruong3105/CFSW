#include "Include/Discount.h"

Discount::Discount(QObject *parent) : QObject{parent}
{
    cDate = QDate::currentDate();
    fetchDiscountInfo();
    showAllDiscount();
}

Discount::~Discount()
{
    for(auto dcnt : discountVect) {
        if(dcnt) {
            delete dcnt;
            dcnt = nullptr;
        }
    }
}

void Discount::showAllDiscount()
{
    for(const auto &dInfo : discountVect) {
        qDebug() << dInfo->getDiscountContent();
    }
}

QList<QVariantMap> Discount::getListDiscountItem(const QList<QVariantMap> &listItem)
{
    QList<QVariantMap> listDcntIt;
    if(discountVect.isEmpty()) {
        qDebug() << "No discount available";
        return listDcntIt;
    }

//    for(uint8_t i = 0; i < listItem.count(); ++i) {
//        QVariantMap map = listItem.at(i);
//        qDebug() << map["drink"];
//    }

    int need, rest;
    for (uint8_t i = 0; i < discountVect.length(); i++) {
        need = 0;
        rest = 0;
        if(discountVect.at(i)->dcntCode == buyXGetYCode) {
            for (uint8_t j = 0; j < listItem.length(); ++j) {
                if(discountVect.at(i)->dcntList.contains(listItem.at(j)["drink"])) {
                    need = need + listItem.at(j)["quantity"].toInt() + rest;
                    qDebug() << listItem.length();
                    qDebug() << "rest: " << rest << ",  need: " << need;
                    if(need >= discountVect.at(i)->qtyNeed) {
                        if(need - discountVect.at(i)->qtyNeed > 0) {
                            rest += (need - discountVect.at(i)->qtyNeed);
                        }
                        QVariantMap map;
                        map["index"] = listItem.at(j)["index"].toInt();
                        map["dcntVal"] = listItem.at(j)["cost"].toInt();
                        // qDebug() << map["index"] << "       " << map["dcntVal"].toInt();
                        listDcntIt.append(map);
                        need -= discountVect.at(i)->qtyNeed;
                    }
                }
            }
        } else if(discountVect.at(i)->dcntCode == drinkGetCakeCode) {
            for(uint8_t j = 0; j < listItem.length(); ++j) {
                if(discountVect.at(i)->dcntList.contains(listItem.at(j)["drink"]) &&
                   listItem.at(j)["drink"] != discountVect.at(i)->dcntList.constLast()) {
                    ++need;
                }
                if(need >= discountVect.at(i)->qtyNeed &&
                    listItem.at(j)["drink"] == discountVect.at(i)->dcntList.constLast()) {
                    QVariantMap map;
                    map["index"] = listItem.at(j)["index"].toInt();
                    map["cost"] = listItem.at(j)["cost"].toInt() -
                                  listItem.at(j)["cost"].toInt() * discountVect.at(i)->dcntPercent / 100;
                    listDcntIt.append(map);
                    need -= discountVect.at(i)->qtyNeed; // Reset need
                }
            }
        } else if(discountVect.at(i)->dcntCode == discountXPercentCode) {
            for(uint8_t j = 0; j < listItem.length(); ++j) {
                if(discountVect.at(i)->dcntList.contains(listItem.at(j)["drink"])) {
                    QVariantMap map;
                    map["index"] = listItem.at(j)["index"].toInt();
                    map["cost"] = listItem.at(j)["cost"].toInt() -
                                  listItem.at(j)["cost"].toInt() * discountVect.at(i)->dcntPercent / 100;
                    listDcntIt.append(map);
                }
            }
        }
    }

//    for(int i = 0; i < listDcntIt.count(); ++i) {
//        QVariantMap map = listDcntIt.at(i);
//        qDebug() << map["index"] << "       " << map["cost"].toInt();
//        qDebug() << "----------------------------------------";
//    }

    return listDcntIt;
}

int Discount::getDiscountVectLength()
{
    return this->discountVect.length();
}

QString Discount::getDiscountContent(int i)
{
    return discountVect.at(i)->getDiscountContent();
}

void Discount::fetchDiscountInfo()
{
    QSqlQuery query;

    QString code = buyXGetYCode;
    uint8_t need, get, percent;

    query.exec(QString("SELECT * FROM discounts"));
    while(query.next()) {
        QDate fDate = QDate::fromString(query.value(2).toString(), "dd/MM/yyyy");
        if(fDate > cDate) {
            qDebug() << "Discount coming soon!";
            continue;
        }
        QDate tDate = QDate::fromString(query.value(3).toString(), "dd/MM/yyyy");
        if(tDate < cDate) {
            qDebug() << "Discount expired!";
            removeDiscountOutDB();
            continue;
        }
        QString listItem = query.value(1).toString();
        QRegularExpressionMatch match = buyXGetY.match(query.value(0).toString());
        if(match.hasMatch()) {
            code = buyXGetYCode;
            need = match.captured(1).toInt();
            // get = match.captured(2).toInt();
            // percent = 100;
        }
        match = drinkGetCake.match(query.value(0).toString());
        if(match.hasMatch()) {
            code = drinkGetCakeCode;
            need = match.captured(1).toInt();
            // get = 1;
            percent = match.captured(2).toInt();
        }
        match = discountXPercent.match(query.value(0).toString());
        if(match.hasMatch()) {
            code = discountXPercentCode;
            // need = 1;
            // get = 0;
            percent = match.captured(1).toInt();
        }
        discountVect.append(new DiscountInfo(code, need, get, percent, parseDiscountList(listItem)));
    }
}

QList<QString> Discount::parseDiscountList(const QString &str)
{
    QList<QString> list;
    QJsonDocument jsonDoc = QJsonDocument::fromJson(str.toUtf8());
    if(jsonDoc.isArray()) {
        QJsonArray jsonArr = jsonDoc.array();
        for(const QJsonValue &val : jsonArr) {
            list.append(val.toString());
        }
    }
    return list;
}

void Discount::removeDiscountOutDB()
{

}
