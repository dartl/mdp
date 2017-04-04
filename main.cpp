#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QSqlDatabase>
#include <QDebug>
#include <QQmlContext>
#include <QSqlError>

#include "handlersignals.h"
#include "listmodeljobs.h"
#include "listmodelworkers.h"
#include "algorithm.h"
#include <QSortFilterProxyModel>

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

    QSortFilterProxyModel* proxy = new QSortFilterProxyModel();
    proxy->setSourceModel(model_jobs);
    proxy->setFilterRole(Qt::UserRole + 2);
    proxy->setFilterCaseSensitivity(Qt::CaseInsensitive);

    Algorithm* algorithm = new Algorithm(model_jobs, model_workers);

    engine.rootContext()->setContextProperty("db_model_jobs", proxy);
    engine.rootContext()->setContextProperty("db_model_workers", model_workers);

    engine.load(QUrl(QStringLiteral("qrc:/qml/main.qml")));

    QObject* mainWindow = engine.rootObjects()[0];
    HandlerSignals* handlerSignals = new HandlerSignals(mainWindow);

    QObject::connect(mainWindow,SIGNAL(usedMenu(int)),
                     handlerSignals,SLOT(menu(int)));

    QObject::connect(handlerSignals,SIGNAL(exit()),
                     qApp,SLOT(quit()));

    QObject::connect(mainWindow,SIGNAL(getIndexListJobs(QString)),
                     algorithm,SLOT(addLeftNodeGraph(QString)));

    QObject::connect(mainWindow,SIGNAL(getIndexListWorkers(int)),
                     model_workers,SLOT(getIndex(int)));

    QObject::connect(algorithm, SIGNAL(existingNode()),
                     handlerSignals, SLOT(messageExistNode()));

    QObject::connect(mainWindow, SIGNAL(updateGraph()),
                     algorithm, SLOT(addRightPartGraph()));

    return app.exec();
}
