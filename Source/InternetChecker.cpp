#include "Include/InternetChecker.h"

InternetChecker::InternetChecker(QObject *parent) : QObject{this}
{
    QTimer *internetCheckTimer = new QTimer(this);
    connect(internetCheckTimer, &QTimer::timeout, this, &InternetChecker::checkInternet);
    internetCheckTimer->start(5000);
}

void InternetChecker::checkInternet()
{
    bool isConnected;
    QNetworkAccessManager networkMng;
    QNetworkRequest request(QUrl("http://www.google.com"));
    QNetworkReply *reply = networkMng.get(request);
    if(reply->error() == QNetworkReply::NoError) {
        isConnected = false;
    } else {
        isConnected = true;
    }
    reply->deleteLater();
    emit getInternetState(isConnected);
}
