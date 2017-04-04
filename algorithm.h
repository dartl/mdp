#ifndef ALGORITHM_H
#define ALGORITHM_H

#include "bipartiplegraph.h"
#include "listmodeljobs.h"
#include "listmodelworkers.h"
#include <vector>
#include <string>
#include <QDebug>
#include <QObject>




class Algorithm : public QObject
{
    Q_OBJECT
    BipartiteGraph<int>* graph;
    ListModelJobs* jobs;
    ListModelWorkers* workers;


public:
    explicit Algorithm(ListModelJobs* jobs, ListModelWorkers* workers, QObject* parent = 0);
    ~Algorithm();

    void setGraph(BipartiteGraph<int>* graph)  { this->graph = graph;}
    BipartiteGraph<int>* getGraph(){ return this->graph; }

    void PrintVertixs();
    void PrintPairs();


signals:
    void existingNode();

public slots:
    void addLeftNodeGraph(QString title);
    void addRightPartGraph();


};

#endif // ALGORITHM_H
