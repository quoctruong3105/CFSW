#ifndef PRECONDITION_H
#define PRECONDITION_H

#include <QObject>
#include <QSqlQuery>
#include <QSysInfo>
#include <QCryptographicHash>
#include <QNetworkInterface>
#include <QByteArray>
#include <QSettings>

class PreCondition : public QObject
{
    Q_OBJECT
public:
    PreCondition(QObject *parent = nullptr);
signals:
public slots:
    bool getLicenseState();
private:
    QList<QString> getLicenseKeys();
    QString getMacAddress();
    // QString getMachineHostName();
    QString getMachineProductId();
    //                       macID     machineProductID
    QString genLocalKey(const QString&, const QString&);
    bool checkLicenseState();

    bool isValidLicense;
    const QString productName = "CFSW-v1.0";
};

#endif // PRECONDITION_H
