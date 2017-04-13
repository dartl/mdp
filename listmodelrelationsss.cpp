#include "listmodelrelationsss.h"

const char* ListModelRelationsSS::COLUMN_NAMES[] {
    "id_specialist",
    "id_specialty"
    "levelspec",
    NULL
};

const char* ListModelRelationsSS::SQL_SELECT =
        "SELECT * FROM RelationsSS";

ListModelRelationsSS::ListModelRelationsSS(QSqlDatabase mybase, QObject *parent):
    QSqlQueryModel(parent)
{
    this->mybase = mybase;

    refresh();
}


int ListModelRelationsSS::getIdSpecialist(int index)
{
    return this->data(this->index(index,0),0).toInt();
}

int ListModelRelationsSS::getIdSpecialty(int index)
{
    return this->data(this->index(index,1),0).toInt();
}

int ListModelRelationsSS::getLevelSpecialist(int index)
{
    return this->data(this->index(index,2),0).toInt();
}

QVariant ListModelRelationsSS::data(const QModelIndex &index, int role) const
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

QHash<int, QByteArray> ListModelRelationsSS::roleNames() const
{
    int idx = 0;
    QHash<int, QByteArray> roleNames;
    while (COLUMN_NAMES[idx]) {
        roleNames[Qt::UserRole + idx + 1] = COLUMN_NAMES[idx];
        idx++;
    }
    return roleNames;
}

void ListModelRelationsSS::refresh()
{
    this->setQuery(SQL_SELECT,mybase);
}

int ListModelRelationsSS::elementsCount()
{
    return this->rowCount();
}
