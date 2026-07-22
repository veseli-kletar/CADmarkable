#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "CadController.h"

int main(int argc, char *argv[])
{
    if (argc <= 0 || argv == nullptr) {
        return 1;
    }

    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;

    // Register CadController
    qmlRegisterType<CadController>("CADmarkable_app", 1, 0, "CadController");

    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.loadFromModule("CADmarkable_app", "Main");
    return app.exec();
}
