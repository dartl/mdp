#ifndef HANDLERSIGNALS_H
#define HANDLERSIGNALS_H

#include <QObject>
#include <QVariant>
#include <QDebug>

class HandlerSignals : public QObject
{
    Q_OBJECT
public:
    explicit HandlerSignals(QObject *parent = 0);

signals:
    void exit();
public slots:
    void menu(const int index);
};

#endif // HANDLERSIGNALS_H
