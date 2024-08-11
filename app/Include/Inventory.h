#ifndef INVENTORY_H
#define INVENTORY_H

#include <QObject>
#include <QSqlQuery>
#include <QByteArray>
#include <QJsonDocument>
#include <QJsonObject>

class Inventory : public QObject
{
    Q_OBJECT
public:
    Inventory(QObject *parent = nullptr);
    //                            itemType        amount    itemName/itemId
    void updateItemQuantityToDB(const QString&, const int&, const QString&);
    //                            drinkName       isSizeL
    QMap<int, int> getDrinkComp(const QString&, const bool&);
    //                           toppingName
    int getToppingQntyPerDrink(const QString&);

public slots:
    //                       drinkName   isSizeL
    bool getDrinkState(const QString&, const bool&); // Check and get state for each drink (Available or not)

    void fetchMaterial();
private slots:
signals:
private:
    void fetchDrinkComp();
    void fetchTpPerDrk();

    //          id   qn'ty
    static QMap<int, int> refMaterialMap;

    //         drinkName      id   qn'ty
    static QMap<QString, QMap<int, int>> mCompMap;

    //         drinkName      id   qn'ty
    static QMap<QString, QMap<int, int>> lCompMap;

    //         drinkName        m/l         id   qn'ty
    static QMap<QString, QMap<QString, QMap<int, int>>> drinkCompMap;

    //          topping qn'tyPerDrink
    static QMap<QString, int> tpQntyPerDrkMap;

    static QString M_COMP_KEY;
    static QString L_COMP_KEY;
};


#endif // INVENTORY_H
