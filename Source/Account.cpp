#include "Include/Account.h"
#include <QDebug>

Account::Account(QObject *parent) : QObject{parent} {

}

void Account::setCurrentUser(const QString &username)
{
    currentUser = username;
}

QString Account::currentUser = NULL;

QString Account::getCurrentUser()
{
    return this->currentUser;
}





