#ifndef ACC_H
#define ACC_H

#include <QObject>

class Account : public QObject
{
    Q_OBJECT
public:
    Account(QObject *parent = nullptr);
signals:
public slots:
private:
    static QString username;
    QString password;
};

#endif // ACC_H
