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
        algorithm->openModel(convertUrl(url).toStdString());
        //std::cerr << convertUrl(url).toStdString();
        //qDebug() << convertUrl(url);
        break;
    case 3:
        algorithm->saveModel(convertUrl(url).toStdString());
        //std::cerr << convertUrl(url).toStdString();
        //qDebug() << convertUrl(url);
        break;
    default:
        break;
    }
}

QString HandlerSignals::convertUrl(QString url)
{
    /*
     * конвертирование url из QML в строку формата, принимаемого ofstream из std
    */
    QStringList tmp;
    QString realPath;

    tmp = url.split("/");

    for(int i = 3; i < tmp.length() - 1; ++i)
    {
        realPath.append(tmp[i]);
        realPath.append("\\");
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

