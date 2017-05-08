#ifndef QMLTRANSLATOR_H
#define QMLTRANSLATOR_H

#include <QObject>
#include <QTranslator>
#include <QGuiApplication>
#include <QDebug>

class QMLTranslator : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString emptyString READ getEmptyString NOTIFY languageChanged)
public:
    explicit QMLTranslator(QObject *parent = 0);

    Q_INVOKABLE void setTranslation(QString language);

    QString getEmptyString() {
      return "";
     }

signals:
    void languageChanged();

public slots:

private:
    QTranslator m_translator;
};

#endif // QMLTRANSLATOR_H
