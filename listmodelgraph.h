#ifndef LISTMODELGRAPH_H
#define LISTMODELGRAPH_H

#include <QObject>
#include <QDebug>

#include "algorithm.h"


class ListModelGraph : QAbstractItemModel
{
    Q_OBJECT
public:
    enum Roles {
        IdWorker = Qt::UserRole + 1,
        IdJob,


    };

    ListModelGraph();
};

#endif // LISTMODELGRAPH_H
