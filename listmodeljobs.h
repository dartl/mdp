#ifndef LISTMODELJOBS_H
#define LISTMODELJOBS_H

#include <QObject>
#include <QSqlQueryModel>
#include <QSqlDatabase>
#include <QDebug>

class ListModelJobs : public QSqlQueryModel
{
    Q_OBJECT
private:
    QSqlDatabase mybase;
    const static char* COLUMN_NAMES[];
    const static char* SQL_SELECT;

public:

    explicit ListModelJobs(QSqlDatabase mybase, QObject *parent = 0);
    QVariant data(const QModelIndex &index, int role) const;

protected:
    QHash<int, QByteArray> roleNames() const;

signals:

public slots:
    void refresh();
    int getId(int index);
    QString getTitle(int index);
    int getIndex(int index);
    int elementsCount();
    int getIndexById(int id);
    int getIndexByTitle(QString title);
};

#endif // LISTMODELJOBS_H
