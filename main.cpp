#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include "handlersignals.h"
#include <QSqlDatabase>
#include <QDebug>
#include "listmodeljobs.h"
#include <QQmlContext>
#include <QSqlError>

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

    engine.rootContext()->setContextProperty("db_model_jobs", model_jobs);

    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    QObject* mainWindow = engine.rootObjects()[0];
    HandlerSignals* handlerSignals = new HandlerSignals(mainWindow);

    QObject::connect(mainWindow,SIGNAL(usedMenu(int)),
                     handlerSignals,SLOT(menu(int)));
    QObject::connect(handlerSignals,SIGNAL(exit()),
                     qApp,SLOT(quit()));

    return app.exec();
}
