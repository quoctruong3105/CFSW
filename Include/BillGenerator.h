#ifndef BILLGENERATOR_H
#define BILLGENERATOR_H

#include <QObject>
#include <QtPrintSupport/QPrinter>
#include <QTextCursor>
#include <QPainter>
#include <QPdfWriter>
#include <QTextDocument>
#include <QMap>
#include <QVariantMap>
#include <QJsonDocument>
#include <QTextTableCell>
#include <QRandomGenerator>
#include <QSqlQuery>
#include <QJsonArray>
#include <QJsonObject>


class BillGenerator : public QObject
{
    Q_OBJECT
public:
    BillGenerator(QObject *parent = nullptr);
signals:
public slots:
    void clearListItem();

    //                   id    name    tl   qty    toppings      size
    void collectItemInfo(int, QString, int, int, const QString&, bool);

    //                     Date     total    cash    account
    void collectOtherInfo(QString, QString, QString, QString);

    bool printBill();
    QString generateRcptId();
private:
    void fromBillToDB();

    static QString shopName;
    static QString address;
    static QString phoneNum;
    static QString passWifi;

    struct ItemModel {
        size_t id;
        QString name;
        size_t total;
        size_t quantity;
        QMap<QString, int> toppings;
        bool isSizeL;
    };
    QList<ItemModel> listItem;
    QList<QString> otherInfo;
};

#endif // BILLGENERATOR_H
