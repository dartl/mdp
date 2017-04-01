#include "handlersignals.h"

HandlerSignals::HandlerSignals(QObject *parent) : QObject(parent)
{
    algorithm = new Algorithm();
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

void HandlerSignals::addLeftNode(const int id)
{
    algorithm->addLeftNodeGraph(algorithm->getGraph(),algorithm->getJobs(), id);
    algorithm->PrintVertixs();
}
