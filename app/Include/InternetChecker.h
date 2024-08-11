#ifndef INTERNETCHECKER_H
#define INTERNETCHECKER_H

#include <QNetworkAccessManager>
#include <QTimer>
#include <QNetworkReply>
#include <QNetworkRequest>

class InternetChecker : public QObject
{
    Q_OBJECT
public:
    InternetChecker(QObject *parent = nullptr);
public slots:
    void checkInternet();
private slots:
signals:
    bool getInternetState(const bool& internetState);
private:
};


#endif // INTERNETCHECKER_H
