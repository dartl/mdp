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
#include <QDebug>
#include <iostream>
#include <iomanip>


using namespace bpg;

class Algorithm : public QObject
{
    Q_OBJECT
    BipartiteGraph<int>* graph;
    ListModelJobs* jobs;
    ListModelWorkers* workers;
    ListModelRelationsSS* relations;

    QMultiMap<int, int> removeData;  // удаляемые данные, ключ - специальности, значения - работники


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
    void removeNode(int id, bool check);
    void clearGraph();

    void saveModel(std::__cxx11::string uri);
    void openModel(std::__cxx11::string uri);
};

#endif // ALGORITHM_H
