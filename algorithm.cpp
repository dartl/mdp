#include "algorithm.h"

std::vector<JobType> Algorithm::getJobs() const
{
    return jobs;
}

Algorithm::Algorithm()
{
    workers.resize(6);

    workers[0].id = 1;
    workers[0].title = "Lawyer";
    workers[0].weight = 3;

    workers[1].id = 2;
    workers[1].title = "Manager";
    workers[1].weight = 2;

    workers[2].id = 3;
    workers[2].title = "Programmer";
    workers[2].weight = 4;

    workers[3].id = 4;
    workers[3].title = "Designer";
    workers[3].weight = 1;

    workers[4].id = 5;
    workers[4].title = "Lawyer";
    workers[4].weight = 2;

    workers[5].id = 6;
    workers[5].title = "Programmer";
    workers[5].weight = 6;

    jobs.resize(3);

    jobs[0].id = 1;
    jobs[0].title = "Lawyer";

    jobs[1].id = 2;
    jobs[1].title = "Designer";

    jobs[2].id = 3;
    jobs[2].title = "Programmer";

    graph = new BipartiteGraph<int>();

}

Algorithm::~Algorithm()
{
    if (graph != nullptr)
        delete graph;

    jobs.clear();
    workers.clear();
}

void Algorithm::PrintVertixs()
{
    qDebug() << "List all vertixs:";
    for (BipartiteGraph<int>::IteratorVertixs i = (*graph).beginVertixs();i != (*graph).endVertixs(); ++i) {
          qDebug() << (*i).getData() << ' ';
    }
}

void Algorithm::addLeftNodeGraph(BipartiteGraph<int> *graph, std::vector<JobType> vec, int id)
{

    for (int i = 0; i < vec.size(); i++)
        if (vec[i].id == id)
        {
            graph->addVertix(id, true);
            break;
        }
}
