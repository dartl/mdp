#ifndef LISTMODELRELATIONSSS_H
#define LISTMODELRELATIONSSS_H

#include <QObject>
#include <QSqlQueryModel>
#include <QSqlDatabase>
#include <QDebug>

class ListModelRelationsSS : public QSqlQueryModel
{
    Q_OBJECT

private:
    QSqlDatabase mybase;
    const static char* COLUMN_NAMES[];
    const static char* SQL_SELECT;
public:
    explicit ListModelRelationsSS(QSqlDatabase mybase, QObject *parent = 0);
    QVariant data(const QModelIndex &index, int role) const;
protected:
    QHash<int, QByteArray> roleNames() const;
signals:

public slots:
    void refresh();
    int getIdSpecialist(int index);
    int getIdSpecialty(int index);
    int getLevelSpecialist(int index);
    int elementsCount();
};

#endif // LISTMODELRELATIONSSS_H
