#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QSettings>
#include <QQuickStyle>
#include <QDebug>
#include <QSqlDatabase>
#include <QSqlError>

#include "handlersignals.h"
#include "listmodeljobs.h"
#include "listmodelworkers.h"
#include <QSortFilterProxyModel>

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    QGuiApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QQmlApplicationEngine engine;
    QQuickStyle::setStyle("Material");
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

    engine.rootContext()->setContextProperty("db_model_jobs", proxy);
    engine.rootContext()->setContextProperty("db_model_workers", model_workers);

    engine.load(QUrl(QStringLiteral("qrc:/qml/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    QObject* mainWindow = engine.rootObjects()[0];
    HandlerSignals* handlerSignals = new HandlerSignals(mainWindow);

    QObject::connect(mainWindow,SIGNAL(usedMenu(int)),
                     handlerSignals,SLOT(menu(int)));

    QObject::connect(handlerSignals,SIGNAL(exit()),
                     qApp,SLOT(quit()));

    QObject::connect(mainWindow,SIGNAL(getIndexListJobs(QString)),
                     model_jobs,SLOT(getIndexByTitle(QString)));

    QObject::connect(mainWindow,SIGNAL(getIndexListWorkers(int)),
                     model_workers,SLOT(getIndex(int)));

    return app.exec();
}
