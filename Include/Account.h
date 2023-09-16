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
    static void setCurrentUser(QString);
    QString getCurrentUser();
private:
    static QString currentUser;
};

#endif // ACC_H
