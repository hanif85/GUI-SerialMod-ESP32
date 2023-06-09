#include <QQmlApplicationEngine>
#include <QQuickStyle>
#include <QtCore>
#include <QApplication>
#include <QSplashScreen>
#include "SerialPort.hpp"
#include "SerialPortInfo.h"

int main(int argc, char *argv[])
{
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif
    QGuiApplication app(argc, argv);
    QQuickStyle::setStyle("Material");
    QQmlApplicationEngine engine;
    const QUrl url(QStringLiteral("qrc:/main.qml"));

//    qmlRegisterType<SerialPort>("QSerialPort", 1, 0, "SerialPort");
    // @uri SerialPort
    qmlRegisterType<SerialPortInfo>("QSerialPortInfo", 1, 0, "SerialPortInfo");
    qmlRegisterType<SerialPort>("QMLSerialPort", 1, 0, "SerialPort");

    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
