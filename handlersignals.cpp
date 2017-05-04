#include "handlersignals.h"

HandlerSignals::HandlerSignals(QObject *parent) : QObject(parent)
{

}

void HandlerSignals::menu(const int index) {
    switch (index) {
    case 1:
        algorithm->addLeftNodeGraph(2);
        //algorithm->addLeftNodeGraph("Менеджер");
        algorithm->addRightPartGraph();
        break;
    case 4:
        emit exit();
        break;
    default:
        break;
    }
}

void HandlerSignals::setAlgorithm(Algorithm *value)
{
    algorithm = value;
}

Algorithm *HandlerSignals::getAlgorithm() const
{
    return algorithm;
}

