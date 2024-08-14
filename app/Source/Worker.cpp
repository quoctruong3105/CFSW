#include <Include/Worker.h>

QString Worker::targetRow = "1";

Worker::Worker(QObject *parent) : QObject{parent}
{

}

void Worker::doWork(const int &refCash, const QString &refDateTime)
{
    bool res = false;
    QProcess confirmPayProcess;
    confirmPayProcess.setProgram("python3");
    QStringList arguments;
    qDebug() << "-----------------------------------";
    qDebug() << QDir::currentPath();
    arguments << QString(QDir::currentPath() + "/Tools/CheckQRPayment.py") << this->targetRow;
    confirmPayProcess.setArguments(arguments);
    confirmPayProcess.start();
    confirmPayProcess.waitForFinished(-1);

    qDebug() << "Acess Paycheck sheet exit with: " << confirmPayProcess.exitCode();
    QString receiveData = confirmPayProcess.readAllStandardOutput();
    if(receiveData.isEmpty()) {
        return;
    }
    QStringList data = receiveData.split(",").toList();

    QDateTime timeGenQR = QDateTime::fromString(refDateTime, "dd/MM/yyyy hh:mm:ss");
    QDateTime timePayment = QDateTime::fromString(data.at(1), "dd/MM/yyyy hh:mm:ss");

    if(data.at(0).toInt() == refCash && timePayment > timeGenQR) {
        res = true;
    }
    emit resultReady(res);
}

void Worker::setTargetRow()
{
    QProcess findTargetRowProcess;
    findTargetRowProcess.setProgram("python3");
    QStringList arguments;
    arguments << QString(QDir::currentPath() + "/Tools/GetTargetRow.py");
    findTargetRowProcess.setArguments(arguments);
    findTargetRowProcess.start();
    findTargetRowProcess.waitForFinished(-1);
    this->targetRow = findTargetRowProcess.readAllStandardOutput();
    qDebug() << this->targetRow;
}

void Worker::setup()
{
    QProcess confirmPayProcess;
    confirmPayProcess.setProgram("python3");
    QStringList arguments;
    qDebug() << "-----------------------------------";
    arguments << QString(QDir::currentPath() + "/Tools/ToolManager.py");
    confirmPayProcess.setArguments(arguments);
    confirmPayProcess.start();
    confirmPayProcess.waitForFinished(-1);
    qDebug() << "Acess Paycheck sheet exit with: " << confirmPayProcess.exitCode();
}
