#ifndef HANDLERSIGNALS_H
#define HANDLERSIGNALS_H

#include <QObject>
#include <QVariant>
#include <QDebug>

#include "algorithm.h"

class HandlerSignals : public QObject
{
    Q_OBJECT
private:
    Algorithm* algorithm;
public:
    explicit HandlerSignals(QObject *parent = 0);

signals:
    void exit();
public slots:
    void menu(const int index);
    void addLeftNode(const int id);
};

#endif // HANDLERSIGNALS_H
