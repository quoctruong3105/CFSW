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

    //                       id           name         tl            qty        toppings       size
    void collectItemInfo(const int&, const QString&, const int&, const int&, const QString&, const bool&);

    //                        Date            total            cash           account
    void collectOtherInfo(const QString&, const QString&, const QString&, const QString&,
                          const QString&, const int&, const int&);
    //                        solu         totalQ'ty    cardNo

    void printBill();
    QString generateRcptId();
private:
    void fromBillToDB();

    //               id            drink            toppings                cost
    void printTag(const int&, const QString&, const QMap<QString, int>&, const int&);

    static QString shopName;
    static QString address;
    static QString phoneNum;
    static QString passWifi;

    struct ItemModel {
        int id;
        QString name;
        int total;
        int quantity;
        QMap<QString, int> toppings;
        bool isSizeL;
    };
    QList<ItemModel> listItem;
    QList<QVariant> otherInfo;
};

#endif // BILLGENERATOR_H
