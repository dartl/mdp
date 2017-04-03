#include "listmodeljobs.h"


const char* ListModelJobs::COLUMN_NAMES[] {
    "id",
    "title",
    NULL
};

const char* ListModelJobs::SQL_SELECT =
        "SELECT * FROM Specialties";

ListModelJobs::ListModelJobs(QSqlDatabase mybase, QObject *parent):
    QSqlQueryModel(parent)
{
    this->mybase = mybase;

    refresh();
}

QVariant ListModelJobs::data(const QModelIndex &index, int role) const
{
    QVariant value = QSqlQueryModel::data(index,role);
    if (role < Qt::UserRole) {
        value = QSqlQueryModel::data(index,role);
    }
    else {
        int columnIdx = role - Qt::UserRole - 1;
        QModelIndex modelIndex = this->index(index.row(), columnIdx);
        value = QSqlQueryModel::data(modelIndex, Qt::DisplayRole);
    }
    return value;
}

QHash<int, QByteArray> ListModelJobs::roleNames() const
{
    int idx = 0;
    QHash<int, QByteArray> roleNames;
    while (COLUMN_NAMES[idx]) {
        roleNames[Qt::UserRole + idx + 1] = COLUMN_NAMES[idx];
        idx++;
    }
    return roleNames;
}

void ListModelJobs::refresh()
{
    this->setQuery(SQL_SELECT,mybase);
}

int ListModelJobs::getId(int index)
{
    return this->data(this->index(index,0),0).toInt();
}

QString ListModelJobs::getTitle(int index)
{
    return this->data(this->index(index,1),0).toString();
}

int ListModelJobs::getIndex(int index)
{
//    qDebug() << index;
//    qDebug() << this->getId(index);
//    qDebug() << this->getTitle(index);
//    qDebug() << this->elementsCount();
    return index;
}

int ListModelJobs::elementsCount()
{
    return this->rowCount();
}
