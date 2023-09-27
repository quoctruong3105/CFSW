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


class BillGenerator : public QObject
{
    Q_OBJECT
public:
    BillGenerator(QObject *parent = nullptr);
signals:
public slots:
    //void collectData();
    void collectItemInfo(int, QString, int, int, const QString&);
    void collectOtherInfo(long, QString, int, int);
    void print();
    void clearListItem();
    void printBill();
private:
    struct ItemModel {
        size_t id;
        QString name;
        size_t total;
        size_t quantity;
        QMap<QString, int> toppings;
    };
    QList<ItemModel> listItem;
    QList<QVariant> otherInfo;
};

#endif // BILLGENERATOR_H
