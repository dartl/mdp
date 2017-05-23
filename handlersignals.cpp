#include "handlersignals.h"
#include <QStringList>

HandlerSignals::HandlerSignals(QObject *parent) : QObject(parent)
{

}

void HandlerSignals::menu(const int index, const QString url) {
    switch (index) {
    case 0:
        break;
    case 1:
        //std::cerr << convertUrl(url).toStdString();
        qDebug() << convertUrl(url);
        break;
    case 4:
        emit exit();
        break;
    default:
        break;
    }
}

QString HandlerSignals::convertUrl(QString url)
{
    QStringList tmp;
    QString realPath;

    tmp = url.split("/");

    for(int i = 3; i < tmp.length() - 1; ++i)
    {
        realPath.append(tmp[i]);
        realPath.append("/");
    }
    realPath.append(tmp[tmp.length() - 1]);

    return realPath;
}

void HandlerSignals::setAlgorithm(Algorithm *value)
{
    algorithm = value;
}

Algorithm *HandlerSignals::getAlgorithm() const
{
    return algorithm;
}

