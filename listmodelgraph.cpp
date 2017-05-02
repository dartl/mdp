#include "listmodelgraph.h"

Algorithm* ListModelGraph::m_algorithm = nullptr;

ListModelGraph::ListModelGraph(QObject *parent) : QObject(parent)
{
    m_graph = new QList<ModelGraph*>();
    this->update();
}

QQmlListProperty<ModelGraph> ListModelGraph::data()
{
    return QQmlListProperty<ModelGraph>(static_cast<QObject*>(this), static_cast<void *>(m_graph),
            &ListModelGraph::appendData, &ListModelGraph::countData,
                                        &ListModelGraph::atData, &ListModelGraph::clearData);
}

void ListModelGraph::setGraph(Algorithm *graph)
{
    ListModelGraph::m_algorithm = graph;
}

void ListModelGraph::update()
{
    this->m_graph = ListModelGraph::m_algorithm->getGraphConvert();

    //console output
    foreach (ModelGraph* it, *m_graph) {
        qDebug() << it->idJob() << " " << it->idWorker();
    }

    emit dataChanged();
}

int ListModelGraph::count()
{
    return m_graph->count();
}

void ListModelGraph::appendData(QQmlListProperty<ModelGraph> *list, ModelGraph *value)
{
    QList<ModelGraph*>* data = static_cast<QList<ModelGraph*> *>(list->data);
    data->append(value);
}

int ListModelGraph::countData(QQmlListProperty<ModelGraph> *list)
{
    QList<ModelGraph*>* data = static_cast<QList<ModelGraph*> *>(list->data);
    return data->size();
}

ModelGraph *ListModelGraph::atData(QQmlListProperty<ModelGraph> *list, int index)
{
    QList<ModelGraph*>* data = static_cast<QList<ModelGraph*> *>(list->data);
    return data->at(index);
}

void ListModelGraph::clearData(QQmlListProperty<ModelGraph> *list)
{
    QList<ModelGraph*>* data = static_cast<QList<ModelGraph*> *>(list->data);
    qDeleteAll(data->begin(),data->end());
    data->clear();
}
