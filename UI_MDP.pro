TEMPLATE = app

QT += quick sql quickcontrols2
CONFIG += c++11

SOURCES += main.cpp \
    handlersignals.cpp \
    listmodeljobs.cpp \
    listmodelworkers.cpp \
    listmodelrelationsss.cpp \
    algorithm.cpp \
    bipartiplegraph.cpp

RESOURCES += \
    mdp.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

HEADERS += \
    handlersignals.h \
    listmodeljobs.h \
    listmodelworkers.h \
    listmodelrelationsss.h \
    algorithm.h \
    bipartiplegraph.h

DISTFILES += \
    Database/database.sqlite
