#include "Include/Account.h"
#include <QDebug>

Account::Account(QObject *parent) : QObject{parent} {

}

void Account::setCurrentUser(QString username)
{
    currentUser = username;
}

QString Account::currentUser = NULL;

QString Account::getCurrentUser()
{
    return this->currentUser;
}





