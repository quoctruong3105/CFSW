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

public slots:
    //           refCash     refDateTime
    void doWork(const int&, const QString&);
    void setup(const bool&);
signals:
    void resultReady(const bool&);
};

#endif // WORKER_H
