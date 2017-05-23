#include "qmltranslator.h"

QMLTranslator::QMLTranslator(QObject *parent) : QObject(parent)
{

}

void QMLTranslator::setTranslation(QString language)
{
    if (language == QString("Русский")) {
        m_translator.load(":/qtLanguage_ru_RU", ".");
        qApp->installTranslator(&m_translator);
    }
    else if (language == QString("English")) {
        m_translator.load(":/qtLanguage_en_US", ".");
        qApp->installTranslator(&m_translator);
    }

    emit languageChanged();
}
