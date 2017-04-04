TEMPLATE = app

QT += qml quick sql
CONFIG += c++11

SOURCES += main.cpp \
    handlersignals.cpp \
    listmodeljobs.cpp \
    listmodelworkers.cpp

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
    listmodelworkers.h

DISTFILES += \
    Database/database.sqlite
