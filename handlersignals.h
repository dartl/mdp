#ifndef HANDLERSIGNALS_H
#define HANDLERSIGNALS_H

#include <QObject>
#include <QVariant>
#include <QDebug>
#include <QSqlDatabase>
#include <QSqlError>
#include <QGuiApplication>

#include "algorithm.h"

class HandlerSignals : public QObject
{
    Q_OBJECT
public:
    explicit HandlerSignals(QObject *parent = 0);

    Algorithm *getAlgorithm() const;

    void setAlgorithm(Algorithm *value);

signals:
    void exit();

public slots:
    void menu(const int index, const QString url);

private:
    Algorithm* algorithm;

    QString convertUrl(QString url);
};

#endif // HANDLERSIGNALS_H
