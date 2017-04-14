#include "modelgraph.h"

ModelGraph::ModelGraph(QObject *parent) : QObject(parent)
{

}

int ModelGraph::idJob() const
{
    return m_idJob;
}

void ModelGraph::setIdJob(int idJob)
{
    m_idJob = idJob;

    emit idJobChanged(m_idJob);
}

int ModelGraph::idWorker() const
{
    return m_idWorker;
}

void ModelGraph::setIdWorker(int idWorker)
{
    m_idWorker = idWorker;

    emit idWorkerChanged(m_idWorker);
}
