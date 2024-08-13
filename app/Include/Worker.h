#ifndef WORKER_H
#define WORKER_H

#include <QObject>
#include <QEventLoop>
#include <QProcess>
#include <QDir>


class Worker : public QObject
{
    Q_OBJECT
public:
    Worker(QObject *parent = nullptr);
    static QString targetRow;

public slots:
    //           refCash     refDateTime
    void doWork(const int&, const QString&);
    void setTargetRow();
    void setup();
signals:
    void resultReady(const bool&);
};

#endif // WORKER_H
