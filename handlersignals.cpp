#include "handlersignals.h"

HandlerSignals::HandlerSignals(QObject *parent) : QObject(parent)
{
    algorithm = new Algorithm();
}

void HandlerSignals::menu(const int index) {
    qDebug() << index;
    switch (index) {
    case 0:
        if (algorithm != nullptr)
        {
            algorithm->~Algorithm();
            algorithm = new Algorithm();
        }
        break;
    case 4:
        emit exit();
        break;
    default:
        break;
    }
}

void HandlerSignals::addLeftNode(const int id)
{
    algorithm->addLeftNodeGraph(algorithm->getJobs(), id);
    algorithm->PrintVertixs();
}
