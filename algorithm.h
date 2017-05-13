#ifndef ALGORITHM_H
#define ALGORITHM_H

#include "bipartiplegraph.h"
#include "listmodeljobs.h"
#include "listmodelworkers.h"
#include "listmodelrelationsss.h"
#include "modelgraph.h"

#include <vector>
#include <string>
#include <QDebug>
#include <QObject>


using namespace bpg;

class Algorithm : public QObject
{
    Q_OBJECT
    BipartiteGraph<int>* graph;
    ListModelJobs* jobs;
    ListModelWorkers* workers;
    ListModelRelationsSS* relations;


public:
    explicit Algorithm(ListModelJobs* jobs, ListModelWorkers* workers,
                       ListModelRelationsSS* relations, QObject* parent = 0);
    ~Algorithm();

    void setGraph(BipartiteGraph<int>* graph)  { this->graph = graph;}
    BipartiteGraph<int>* getGraph(){ return this->graph; }

    QList<ModelGraph *> *getGraphConvert();

    void PrintVertixs();
    void PrintPairs();

signals:
    void existingNode();

public slots:
    bool addLeftNodeGraph(int id);
    void addRightPartGraph();
    void clearGraph();
};

#endif // ALGORITHM_H
