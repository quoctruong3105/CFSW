#include "Include/WorkerController.h"

WorkerController::WorkerController(QObject *parent) : QObject{parent}
{
}

WorkerController::~WorkerController()
{
    this->killThread();
}

void WorkerController::killThread()
{
    workerThread.quit();
    workerThread.wait();
    delete worker;
    worker = nullptr;
}

void WorkerController::startThread()
{
    worker = new Worker();
    worker->moveToThread(&workerThread);
    connect(this, &WorkerController::startCheck, worker, &Worker::doWork);
    connect(worker, &Worker::resultReady, this, &WorkerController::sendResult);
    workerThread.start();
}

void WorkerController::sendResult(const bool &res)
{
    emit getConfirmed(res);
}

