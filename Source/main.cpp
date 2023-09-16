#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QIcon>
#include "Include/DataHandler.h"
#include "Include/Account.h"
#include "Include/BillGenerator.h"


int main(int argc, char *argv[])
{
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif
    QGuiApplication app(argc, argv);
    QQmlApplicationEngine engine;

    qmlRegisterType<DataHandle>("Qt.DataHandle.Module", 1, 0, "DataHandler");
    qmlRegisterType<Account>("Qt.Account.Module", 1, 0, "Account");
    qmlRegisterType<BillGenerator>("Qt.BillGenerator.Module", 1, 0, "BillGenerator");


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
