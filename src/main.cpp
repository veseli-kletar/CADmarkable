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
#if QT_VERSION >= QT_VERSION_CHECK(6, 5, 0)
    engine.loadFromModule("CADmarkable_app", "Main");
#else
    engine.load(QUrl(QStringLiteral("qrc:/CADmarkable_app/src/Main.qml")));
#endif
    return app.exec();
}
