#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include "handlersignals.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    QObject* mainWindow = engine.rootObjects()[0];
    HandlerSignals* handlerSignals = new HandlerSignals(mainWindow);

    QObject::connect(mainWindow,SIGNAL(usedMenu(int)),
                     handlerSignals,SLOT(menu(int)));
    QObject::connect(handlerSignals,SIGNAL(exit()),
                     qApp,SLOT(quit()));

    return app.exec();
}
