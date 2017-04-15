#ifndef MODELGRAPH_H
#define MODELGRAPH_H

#include <QObject>

class ModelGraph : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int idJob READ idJob WRITE setIdJob NOTIFY idJobChanged)
    Q_PROPERTY(int idWorker READ idWorker WRITE setIdWorker NOTIFY idWorkerChanged)

public:
    explicit ModelGraph(QObject *parent = 0);

    int idJob() const;
    void setIdJob(int idJob);
    int idWorker() const;
    void setIdWorker(int idWorker);

signals:
    void idJobChanged(int idJob);
    void idWorkerChanged(int idWorker);

public slots:

private:
    int m_idJob;
    int m_idWorker;
};

#endif // MODELGRAPH_H
