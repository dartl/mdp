#include "handlersignals.h"

HandlerSignals::HandlerSignals(QObject *parent) : QObject(parent)
{

}

void HandlerSignals::menu(const int index) {
    switch (index) {
    case 4:
        emit exit();
        break;
    default:
        break;
    }
}

void HandlerSignals::messageExistNode()
{
    qDebug() << "Данная вершина уже присутствует в графе!";
}
