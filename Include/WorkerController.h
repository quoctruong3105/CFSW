#ifndef WORKERCONTROLLER_H
#define WORKERCONTROLLER_H

#include <QObject>
#include <QThread>
#include <QDebug>
#include "Include/Worker.h"

class WorkerController : public QObject
{
    Q_OBJECT
public:
    WorkerController(QObject *parent = nullptr);
    ~WorkerController();
public slots:
    void killThread();
    void startThread();
    void sendResult(const bool&);
signals:
    //               refCash      refDateTime
    void startCheck(const int&, const QString&);
    void getConfirmed(const bool &isConfirmed);
private:
    Worker *worker;
    QThread *workerThread;
};

#endif // WORKERCONTROLLER_H
