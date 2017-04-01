#include "handlersignals.h"

HandlerSignals::HandlerSignals(QObject *parent) : QObject(parent)
{

}

void HandlerSignals::menu(const int index) {
    qDebug() << index;
    switch (index) {
    case 4:
        emit exit();
        break;
    default:
        break;
    }
}
