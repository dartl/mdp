#include "algorithm.h"


Algorithm::Algorithm(ListModelJobs *jobs, ListModelWorkers *workers,
                     ListModelRelationsSS *relations, QObject* parent): QObject(parent)
{
    this->jobs = jobs;
    this->workers = workers;
    this->relations = relations;
    graph = new BipartiteGraph<int>();

}

Algorithm::~Algorithm()
{
    if (graph != nullptr)
        delete graph;
}

void Algorithm::PrintVertixs()
{
    qDebug() << "List all vertixs:";
    for (BipartiteGraph<int>::IteratorVertixs i = (*graph).beginVertixs();i != (*graph).endVertixs(); ++i) {
          qDebug() << "(" << (*i).getData() << ',' << (*i).isCheck() << ")";
    }
}

void Algorithm::PrintPairs()
{
    qDebug() << "List all pairs:";
    for (BipartiteGraph<int>::IteratorPairs p = (*graph).beginPairs();p != (*graph).endPairs(); ++p) {
        qDebug() << (*p).getFisrt().getData() << ' ' << (*p).getSecond().getData() << ' ';
    }
}

void Algorithm::addLeftNodeGraph(QString title)
{
    int index = this->jobs->getIndexByTitle(title);
    if (!graph->checkVertix(this->jobs->getId(index)))
        graph->addVertix(this->jobs->getId(index), true);
    else
        emit existingNode();
    PrintVertixs();
}

void Algorithm::addRightPartGraph()
{

    graph->removeAllFalse();
    for (BipartiteGraph<int>::IteratorVertixs i = (*graph).beginVertixs(); i != (*graph).endVertixs(); i++)
    {
        if ((*i).isCheck()) {
            int jobsId = (*i).getData();
            int currLevelMax = -1;
            int currWorkerMax = -1;
            for (int j = 0; j < this->relations->elementsCount(); j++)
            {
                if (relations->getIdSpecialty(j) == jobsId)
                {
                    if (relations->getLevelSpecialist(j) > currLevelMax)
                    {
                        currWorkerMax = relations->getIdSpecialist(j);
                        currLevelMax = relations->getLevelSpecialist(j);
                    }
                }
            }
            graph->addVertix(workers->getId(currWorkerMax), false);
            graph->addPair(&(graph->getVertixNode((*i).getData())), &(graph->getVertixNode(workers->getId(currWorkerMax))));
        }
    }
    PrintVertixs();
    PrintPairs();
}


