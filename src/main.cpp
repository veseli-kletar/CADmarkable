#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include "CadController.h"

int main(int argc, char *argv[])
{
    if (argc <= 0 || argv == nullptr) {
        return 1;
    }

    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;

    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.load(QUrl(u"qrc:/qt/qml/CADmarkable_app/Main.qml"_qs));
    return app.exec();
}
