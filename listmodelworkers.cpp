#include "listmodelworkers.h"

const char* ListModelWorkers::COLUMN_NAMES[] {
    "id",
    "fio",
    "sex",
    "age",
    "address",
    "speciality",
    "levelspec",
    NULL
};

const char* ListModelWorkers::SQL_SELECT =
        "SELECT * FROM Specialists";

ListModelWorkers::ListModelWorkers(QSqlDatabase mybase, QObject *parent):
    QSqlQueryModel(parent)
{
    this->mybase = mybase;

    refresh();
}

QVariant ListModelWorkers::data(const QModelIndex &index, int role) const
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

QHash<int, QByteArray> ListModelWorkers::roleNames() const
{
    int idx = 0;
    QHash<int, QByteArray> roleNames;
    while (COLUMN_NAMES[idx]) {
        roleNames[Qt::UserRole + idx + 1] = COLUMN_NAMES[idx];
        idx++;
    }
    return roleNames;
}

void ListModelWorkers::refresh()
{
    this->setQuery(SQL_SELECT,mybase);
}

int ListModelWorkers::getId(int index)
{
    return this->data(this->index(index,0),0).toInt();
}

QString ListModelWorkers::getFIO(int index)
{
    return this->data(this->index(index,1),0).toString();
}

QString ListModelWorkers::getSex(int index)
{
    return this->data(this->index(index,2),0).toString();
}

int ListModelWorkers::getAge(int index)
{
    return this->data(this->index(index,3),0).toInt();
}

QString ListModelWorkers::Adress(int index)
{
    return this->data(this->index(index,4),0).toString();
}

QString ListModelWorkers::getSpeciality(int index)
{
    return this->data(this->index(index,5),0).toString();
}

int ListModelWorkers::getLevelSpec(int index)
{
    return this->data(this->index(index,6),0).toInt();
}

int ListModelWorkers::getIndex(int index)
{
//    qDebug() << index;
//    qDebug() << this->getId(index);
//    qDebug() << this->getFIO(index);
//    qDebug() << this->getSpeciality(index);
//    qDebug() << this->getLevelSpec(index);
//    qDebug() << this->elementsCount();
//    qDebug() << this->getIndexById(this->getId(index));
//    qDebug() << this->getIndexById(25);
    return index;
}

int ListModelWorkers::elementsCount()
{
    return this->rowCount();
}

int ListModelWorkers::getIndexById(int id)
{
    int index = -1;
    for (int i = 0; i < this->elementsCount(); ++i) {
        if (this->getId(i) == id) {
            index = i;
            break;
        }
    }
    return index;
}
