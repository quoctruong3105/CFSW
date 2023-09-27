QT += quick
QT += sql
QT += core widgets printsupport
QT += network

# You can make your code fail to compile if it uses deprecated APIs.
# In order to do so, uncomment the following line.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

HEADERS += \
    Include/BillGenerator.h \
    Include/DataHandler.h \
    Include/Account.h \
    Include/QRPayment.h \
    Include/Worker.h \
    Include/WorkerController.h

SOURCES += \
    Source/Account.cpp \
    Source/BillGenerator.cpp \
    Source/DataHandler.cpp \
    Source/QRPayment.cpp \
    Source/Worker.cpp \
    Source/WorkerController.cpp \
    Source/main.cpp \

RESOURCES += \
    qml.qrc \
    img.qrc \

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

DISTFILES += \
    Credentials/TransactionCredential.json \
    Tools/CheckQRPayment.py \
