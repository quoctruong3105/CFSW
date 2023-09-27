#include "Include/QRPayment.h"

QList<QVariantMap> QRPayment::listBankInfo;

QRPayment::QRPayment(QObject *parent) : QObject{parent} {
    // Fetch list banks
    if(listBankInfo.isEmpty()) {
        QSqlQuery query;
        query.exec(QString("SELECT * FROM banks"));
        while (query.next()) {
            QVariantMap map;
            map.insert("acqId", query.value(0).toInt());
            map.insert("accountNo", query.value(1).toLongLong());
            map.insert("accountName", query.value(2).toString());
            listBankInfo.append(map);
        }
    }
}

QVariant QRPayment::genQRCode(int bankId, int amount)
{
    QVariant qrCode = QVariant::fromValue(QUrl());
    QVariantMap apiRequest = getBankInfo(bankId);
    apiRequest.insert("amount", amount);
    apiRequest.insert("template", "print");
    apiRequest.insert("addInfo", "Thanh toan Hi Coffe");

    QJsonDocument jsonDocument = QJsonDocument::fromVariant(apiRequest);
    QByteArray jsonData = jsonDocument.toJson();
    QNetworkAccessManager netWorkMng;
    QNetworkRequest request((QUrl("https://api.vietqr.io/v2/generate")));
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");
    QNetworkReply* reply = netWorkMng.post(request, jsonData);

    QEventLoop waitReply;
    QObject::connect(reply, SIGNAL(finished()), &waitReply, SLOT(quit()));
    waitReply.exec();

    int httpStatusCode = reply->attribute(QNetworkRequest::HttpStatusCodeAttribute).toInt();
    if (httpStatusCode == 200) {
        QByteArray responseData = reply->readAll();
        QJsonDocument jsonDoc = QJsonDocument::fromJson(responseData);

        if (!jsonDoc.isNull()) {
            QVariantMap dataMap = jsonDoc.toVariant().toMap();
            if (dataMap.contains("data")) {
                QVariantMap data = dataMap["data"].toMap();
                QString qrDataURL = data["qrDataURL"].toString();
                qrDataURL = qrDataURL.replace("data:image/png;base64,", "");
                QByteArray imageBytes = QByteArray::fromBase64(qrDataURL.toUtf8());
                QImage qrCodeImage = QImage::fromData(imageBytes);
                QTemporaryFile tempFile;
                tempFile.setAutoRemove(false);
                tempFile.open();
                qrCodeImage.save(&tempFile, "PNG");
                tempFile.close();

                qrCode = QVariant::fromValue(QUrl::fromLocalFile(tempFile.fileName()));
            }
        }
    }
    return qrCode;
}

bool QRPayment::startConfirm()
{
    qDebug() << QDir::current();
    QProcess confirmPayProcess;
    confirmPayProcess.setProgram("python");
    QStringList arguments;
    arguments << QString(QDir::currentPath() + "/Tools/CheckQRPayment.py");
    confirmPayProcess.setArguments(arguments);
    confirmPayProcess.start();

   confirmPayProcess.waitForFinished(-1);

    qDebug() << confirmPayProcess.exitCode();
    QString res = confirmPayProcess.readAllStandardOutput();
    qDebug() << res;
    if(!res.isEmpty()) {
        return true;
    }
    return false;
}


QVariantMap QRPayment::getBankInfo(int i)
{
    return listBankInfo.at(i);
}
