#ifndef LISTMODELWORKERS_H
#define LISTMODELWORKERS_H

#include <QObject>
#include <QSqlQueryModel>
#include <QSqlDatabase>
#include <QDebug>

class ListModelWorkers : public QSqlQueryModel
{
public:
    Q_OBJECT
private:
    QSqlDatabase mybase;
    const static char* COLUMN_NAMES[];
    const static char* SQL_SELECT;

public:

    explicit ListModelWorkers(QSqlDatabase mybase, QObject *parent = 0);
    QVariant data(const QModelIndex &index, int role) const;
protected:
    QHash<int, QByteArray> roleNames() const;

signals:

public slots:
    void refresh();
    int getId(int index);
    QString getFIO(int index);
    QString getSex(int index);
    int getAge(int index);
    QString Adress(int index);
    QString getSpeciality(int index);
    int getLevelSpec(int index);
    int getIndex(int index);
    int elementsCount();
};

#endif // LISTMODELWORKERS_H
