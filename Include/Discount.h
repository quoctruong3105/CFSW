#ifndef DISCOUNT_H
#define DISCOUNT_H

#include <QObject>
#include <QMap>
#include <QDate>
#include <QSqlQuery>
#include <QJsonDocument>
#include <QJsonArray>
#include <QRegularExpression>
#include <QRegularExpressionMatch>

// Discount codes
const QString buyXGetYCode = "BXGY";
const QString drinkGetCakeCode = "XDYPDC";
const QString discountXPercentCode = "XPD";


class Discount : public QObject
{
    Q_OBJECT
public:
    Discount(QObject *parent = nullptr);
    ~Discount();
    void showAllDiscount();
signals:
public slots:
    QList<QVariantMap> getListDiscountItem(const QList<QVariantMap>&);
    int getDiscountVectLength();
    QString getDiscountContent(int i);
private:
    void fetchDiscountInfo();
    void removeDiscountOutDB();
    QList<QString> parseDiscountList(const QString&);

    struct DiscountInfo {
        QString dcntCode;
        uint8_t qtyNeed;
        uint8_t qtyGet;
        uint8_t dcntPercent;
        QList<QString> dcntList;

        DiscountInfo(const QString &code, const uint8_t &need, const uint8_t &get,
                     const uint8_t &percent, const QList<QString> &list) {
            dcntCode = code;
            qtyNeed = need;
            qtyGet = get;
            dcntPercent = percent;
            dcntList = list;
        }

        QString getDiscountContent() {
            if(dcntCode == buyXGetYCode) {
                return QString("Buy %1 get 1 free when purchasing drinks in group [%3]").
                    arg(qtyNeed).
                    arg(dcntList.join(", "));
            } else if(dcntCode == drinkGetCakeCode) {
                return QString("Buy %1 drink in group [%2] get %3% discount for %4 cake").
                    arg(qtyNeed).
                    arg(dcntList.mid(0, dcntList.size() - 1).join(", ")).
                    arg(dcntPercent).
                    arg(dcntList.last());
            } else if(dcntCode == discountXPercentCode) {
                return QString("Discount %1% when purchasing each drink in group [%2]").
                    arg(dcntPercent).
                    arg(dcntList.join(", "));
            }
        }
    };

    QVector<DiscountInfo*> discountVect;
    QDate cDate;

    // Buy X get 1 free drink in list
    const QRegularExpression buyXGetY = QRegularExpression("^B(\\d+)G1");
    // Buy X drink get Y percent discount for a cake in list
    const QRegularExpression drinkGetCake = QRegularExpression("^(\\d+)D(\\d+)PDC");
    // Discount X percent for each cake in list
    const QRegularExpression discountXPercent = QRegularExpression("^(\\d+)PD");
};

#endif // DISCOUNT_H
