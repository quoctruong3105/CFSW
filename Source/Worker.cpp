#include <Include/Worker.h>

Worker::Worker(QObject *parent) : QObject{parent} {

}

void Worker::doWork(const int &refCash, const QString &refDateTime)
{
    bool res = false;
    //qDebug() << QDir::current();
    QProcess confirmPayProcess;
    confirmPayProcess.setProgram("python");
    QStringList arguments;
    arguments << "E:/CFSW/Tools/CheckQRPayment.py";//<< QString(QDir::currentPath() + "/Tools/CheckQRPayment.py");
    confirmPayProcess.setArguments(arguments);
    confirmPayProcess.start();

    confirmPayProcess.waitForFinished(-1);

    qDebug() << "Acess Paycheck sheet exit with: " << confirmPayProcess.exitCode();
    QString receiveData = confirmPayProcess.readAllStandardOutput();
    QStringList data = receiveData.split(",").toList();

    QDateTime timeGenQR = QDateTime::fromString(refDateTime, "dd/MM/yyyy hh:mm:ss");
    QDateTime timePayment = QDateTime::fromString(data.at(1), "dd/MM/yyyy hh:mm:ss");

    if(data.at(0).toInt() == refCash && timePayment > timeGenQR) {
        res = true;
    }
    emit resultReady(res);
}
