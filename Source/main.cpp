#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QIcon>

#include "Include/DataHandler.h"
#include "Include/Account.h"
#include "Include/BillGenerator.h"
#include "Include/QRPayment.h"
#include "Include/WorkerController.h"
#include "Include/Worker.h"
#include "Include/Inventory.h"
#include "Include/Discount.h"
#include "Include/PreCondition.h"


int main(int argc, char *argv[])
{
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif
    QGuiApplication app(argc, argv);
    QQmlApplicationEngine engine;

    qmlRegisterType<DataHandle>("Tt.DataHandle.Module", 1, 0, "DataHandler");
    qmlRegisterType<Account>("Tt.Account.Module", 1, 0, "Account");
    qmlRegisterType<BillGenerator>("Tt.BillGenerator.Module", 1, 0, "BillGenerator");
    qmlRegisterType<QRPayment>("Tt.QRPayment.Module", 1, 0, "QRPayment");
    qmlRegisterType<Worker>("Tt.Worker.Module", 1, 0, "Worker");
    qmlRegisterType<WorkerController>("Tt.WorkerController.Module", 1, 0, "WorkerController");
    qmlRegisterType<Inventory>("Tt.Inventory.Module", 1, 0, "Inventory");
    qmlRegisterType<Discount>("Tt.Discount.Module", 1, 0, "Discount");
    qmlRegisterType<PreCondition>("Tt.PreCondition.Module", 1, 0, "PreCondition");

    const QUrl url(QStringLiteral("qrc:/UI/Main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
        &app, [url](QObject *obj, const QUrl &objUrl) {
            if (!obj && url == objUrl)
                QCoreApplication::exit(-1);
        }, Qt::QueuedConnection);
    engine.load(url);
    QIcon icon(":/img/app_icon.ico");
    app.setWindowIcon(icon);
    return app.exec();
}
