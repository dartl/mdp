#ifndef LISTMODELGRAPH_H
#define LISTMODELGRAPH_H

#include <QObject>
#include <QDebug>
#include <QQmlListProperty>

#include "algorithm.h"
#include "modelgraph.h"


class ListModelGraph : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QQmlListProperty<ModelGraph> data READ data NOTIFY dataChanged)
    Q_CLASSINFO("DefaultProperty", "data")

public:
    ListModelGraph(QObject *parent = 0);

    QQmlListProperty<ModelGraph> data();

    static void setGraph(Algorithm *graph);


    Q_INVOKABLE void update();

signals:
    void dataChanged();

protected:
    static Algorithm* m_algorithm;

private:
    QList<ModelGraph*>* m_graph;

    static void appendData(QQmlListProperty<ModelGraph> *list, ModelGraph *value);
    static int countData(QQmlListProperty<ModelGraph> *list);
    static ModelGraph *atData(QQmlListProperty<ModelGraph> *list, int index);
    static void clearData(QQmlListProperty<ModelGraph> *list);
};


#endif // LISTMODELGRAPH_H
