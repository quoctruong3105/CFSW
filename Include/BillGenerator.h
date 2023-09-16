#ifndef BILLGENERATOR_H
#define BILLGENERATOR_H

#include <QObject>
#include <QtPrintSupport/QPrinter>
#include <QTextCursor>
#include <QPainter>
#include <QTextDocument>
#include <QMap>


class BillGenerator : public QObject
{
    Q_OBJECT
public:
    BillGenerator(QObject *parent = nullptr);
signals:
public slots:
    //void collectData();
    void collectItemInfo(int, QString, int, int, const QVariantMap&);
    void print();
    void printBill();
private:
    struct ItemModel {
        int id;
        QString name;
        int cost;
        int quatity;
        QVariantMap toppings;
    };
    QList<ItemModel> listItem;
};

#endif // BILLGENERATOR_H
