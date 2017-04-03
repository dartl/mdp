#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QSqlDatabase>
#include <QDebug>
#include <QQmlContext>
#include <QSqlError>

#include "handlersignals.h"
#include "listmodeljobs.h"
#include "listmodelworkers.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    QQmlApplicationEngine engine;

    QSqlDatabase mybase;

    //connect with BD
    mybase = QSqlDatabase::addDatabase("QSQLITE");
    mybase.setDatabaseName(qApp->applicationDirPath() + "/DataBase/database.sqlite");
    if (!mybase.open())
    {
        qDebug() << mybase.lastError().text();
    }

    ListModelJobs* model_jobs = new ListModelJobs(mybase);
    ListModelWorkers* model_workers = new ListModelWorkers(mybase);

    engine.rootContext()->setContextProperty("db_model_jobs", model_jobs);
    engine.rootContext()->setContextProperty("db_model_workers", model_workers);

    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    QObject* mainWindow = engine.rootObjects()[0];
    HandlerSignals* handlerSignals = new HandlerSignals(mainWindow);

    QObject::connect(mainWindow,SIGNAL(usedMenu(int)),
                     handlerSignals,SLOT(menu(int)));

    QObject::connect(handlerSignals,SIGNAL(exit()),
                     qApp,SLOT(quit()));

    QObject::connect(mainWindow,SIGNAL(getIndexListJobs(int)),
                     model_jobs,SLOT(getIndex(int)));

    QObject::connect(mainWindow,SIGNAL(getIndexListWorkers(int)),
                     model_workers,SLOT(getIndex(int)));

    return app.exec();
}
