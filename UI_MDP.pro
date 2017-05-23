TEMPLATE = app
TARGET = StaffSearch

QT += quick sql quickcontrols2
CONFIG += c++11



#qml files for Language
lupdate_only {
    SOURCES += qml/main.qml \
        qml/AdditionArea.qml \
        qml/LoadIndicator.qml \
        qml/Graph.qml
}

SOURCES += main.cpp \
    handlersignals.cpp \
    listmodeljobs.cpp \
    listmodelworkers.cpp \
    listmodelrelationsss.cpp \
    listmodelgraph.cpp \
    algorithm.cpp \
    bipartiplegraph.cpp \
    modelgraph.cpp \
    qmltranslator.cpp

RESOURCES += \
    translations.qrc \
    mdp.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

#file for Translate
TRANSLATIONS += qtLanguage_ru.ts

HEADERS += \
    handlersignals.h \
    listmodeljobs.h \
    listmodelworkers.h \
    listmodelrelationsss.h \
    listmodelgraph.h \
    algorithm.h \
    bipartiplegraph.h \
    modelgraph.h \
    qmltranslator.h

DISTFILES += \
    Database/database.sqlite \
    qtLanguage_ru.ts
