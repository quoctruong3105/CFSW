#ifndef QRPAYMENT_H
#define QRPAYMENT_H
#include <QObject>
#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QNetworkReply>
#include <QJsonDocument>
#include <QImage>
#include <QByteArray>
#include <QBuffer>
#include <QPixmap>
#include <QByteArray>
#include <QDebug>
#include <QTemporaryFile>
#include <QSqlQuery>
#include <QEventLoop>
#include <QProcess>
#include <QDir>


class QRPayment : public QObject
{
    Q_OBJECT
public:
    QRPayment(QObject *parent = nullptr);
    static QList<QVariantMap> getListBankInfo();

signals:
public slots:
    QVariant genQRCode(int bankId, int amount);
    bool startConfirm();
private:
    QVariantMap getBankInfo(int i);
    static QList<QVariantMap> listBankInfo;
};

#endif // QRPAYMENT_H
