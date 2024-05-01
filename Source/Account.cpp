#include "Include/Account.h"
#include <QDebug>

QString Account::currentUser = NULL;

Account::Account(QObject *parent) : QObject{parent}
{

}

void Account::setCurrentUser(const QString &username)
{
    currentUser = username;
}

QString Account::getCurrentUser()
{
    return this->currentUser;
}





