#ifndef ALGORITHM_H
#define ALGORITHM_H

#include "bipartiplegraph.h"
#include <vector>
#include <string>
#include <QDebug>

struct JobType
{
    std::string title;
    int id;
};

struct WorkerType
{
    int id;
    std::string title;
    int weight;
};



class Algorithm
{
    BipartiteGraph<int>* graph;
    std::vector<JobType> jobs;
    std::vector<WorkerType> workers;

public:
    Algorithm();
    ~Algorithm();

    void PrintVertixs();

    void addLeftNodeGraph(std::vector<JobType> vec, int id);
    std::vector<JobType> getJobs() const;
    std::vector<WorkerType> getWorkers() const;
    BipartiteGraph<int> *getGraph() const;
};

#endif // ALGORITHM_H
