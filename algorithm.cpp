#include "algorithm.h"

class print_only_vertix
{
    BipartiteGraph<int>* graph;
public:
    BipartiteGraph<int>* getGraph() const {
        return graph;
    }

    print_only_vertix(BipartiteGraph<int>* g): graph(g) {}
    friend std::ostream& operator<<(std::ostream& os, const print_only_vertix& t);
};

inline std::ostream& operator<<(std::ostream& os,const print_only_vertix& t)
{
    for (int i = 0; i < t.getGraph()->getSizeVertixs(); i++) {
        os << "Vertix #" << i+1 << ": ";
        os << t.getGraph()->getVertixNodeByNumber(i);
        os << endl;
    }
    return os;
}

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

QList<ModelGraph *> *Algorithm::getGraphConvert()
{
    QList<ModelGraph* >* tempList = new QList<ModelGraph* >();

    for (BipartiteGraph<int>::IteratorVertixs i = (*graph).beginVertixs(); i != (*graph).endVertixs(); ++i)
    {
        ModelGraph* tempModel = new ModelGraph();
        if ((*i)->isCheck())
        {
            bool nodeInPair = false;
            for (BipartiteGraph<int>::IteratorPairs p = (*graph).beginPairs(); p != (*graph).endPairs(); ++p)
            {
                if ((*p)->getFisrt()->getData() == (*i)->getData())
                {

                    tempModel->setIdJob((*p)->getFisrt()->getData());
                    tempModel->setIdWorker((*p)->getSecond()->getData());
                    nodeInPair = true;
                }
            }
            if (!nodeInPair)
            {

                tempModel->setIdJob((*i)->getData());
                tempModel->setIdWorker(-1);
            }
            tempList->append(tempModel);
        }
    }
    return tempList;
}

void Algorithm::PrintVertixs()
{
    qDebug() << "List all vertixs:";
    for (BipartiteGraph<int>::IteratorVertixs i = (*graph).beginVertixs();i != (*graph).endVertixs(); ++i) {
          qDebug() << "(" << (*i)->getData() << ',' << (*i)->isCheck() << ")";
    }
}

void Algorithm::PrintPairs()
{
    qDebug() << "List all pairs:";
    for (BipartiteGraph<int>::IteratorPairs p = (*graph).beginPairs();p != (*graph).endPairs(); ++p) {
        qDebug() << (*p)->getFisrt()->getData() << ' ' << (*p)->getSecond()->getData() << ' ';
    }
}

bool Algorithm::addLeftNodeGraph(int id)
{
    PrintVertixs();
    return graph->addVertix(id, true);
}

void Algorithm::addRightPartGraph()
{
    this->graph->removeAllFalse();

    for (BipartiteGraph<int>::IteratorVertixs i = (*graph).beginVertixs(); i != (*graph).endVertixs(); i++)
    {
        if ((*i)->isCheck()) {
            int jobsId = (*i)->getData();
            int currLevelMax = -1;
            int currWorkerMax = -1;
            for (int j = 0; j < this->relations->elementsCount(); j++)
            {
                if (relations->getIdSpecialty(j) == jobsId)
                {
                    if (removeData.contains(jobsId))
                    {
                        QList<int> rights = removeData.values(jobsId);
                        QListIterator<int> list_it(rights);
                        while (list_it.hasNext())
                        {
                            int node = list_it.next();
                            if (node == relations->getIdSpecialist(j))
                                break;
                            else if (relations->getLevelSpecialist(j) > currLevelMax)
                            {
                                currWorkerMax = relations->getIdSpecialist(j);
                                currLevelMax = relations->getLevelSpecialist(j);
                            }
                        }
                    }
                    else if (relations->getLevelSpecialist(j) > currLevelMax)
                    {
                        currWorkerMax = relations->getIdSpecialist(j);
                        currLevelMax = relations->getLevelSpecialist(j);
                    }

                }
            }
            graph->addVertix(currWorkerMax, false);
            graph->addPair(graph->getVertixNode((*i)->getData(), true), graph->getVertixNode(currWorkerMax, false));
        }
    }
    PrintVertixs();
    PrintPairs();
}

void Algorithm::removeNode(int id, bool check)
{
    Node<int>* temp = graph->getVertixNode(id, check);   // вершина из графа
    if (!check)
    {
        for (BipartiteGraph<int>::IteratorPairs p = (*graph).beginPairs();p != (*graph).endPairs(); ++p)
        {
            if ((*p)->getSecond() == temp)
            {
                int left = (*p)->getFisrt()->getData();

                if (!removeData.contains(left))
                    removeData.insert(left, id);
                break;
            }
        }
    }
    graph->removeVertixNode(temp);
    PrintVertixs();
    PrintPairs();
}

void Algorithm::clearGraph()
{
    this->graph->clearGraph();
    removeData.clear();
//    PrintVertixs();
//    PrintPairs();
}

void Algorithm::saveModel(std::string uri)
{
    this->graph->Serialize(uri);
}

void Algorithm::openModel(std::string uri)
{
    this->graph->Deserialize(uri);
    std::cout << print_only_vertix(this->graph);
}
