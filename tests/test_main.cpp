#include <QtTest>
#include <QQmlApplicationEngine>
#include <QCoreApplication>
#include "CadController.h"
#include <QQmlComponent>

class TestMain : public QObject
{
    Q_OBJECT

private slots:
    void testMainAppLoading()
    {
        // 1. Verify QML Type Registration
        qmlRegisterType<CadController>("CADmarkable_app", 1, 0, "CadController");

        QQmlApplicationEngine engine;
        engine.addImportPath("/usr/lib/x86_64-linux-gnu/qt6/qml");
        engine.addImportPath("qrc:/");

        // 2. Verify Component Loading
        QQmlComponent component(&engine);
        component.loadUrl(QUrl("qrc:/CADmarkable_app/src/Main.qml"));

        QVERIFY2(!component.isError(), "Component has errors while loading main QML file");

        // 3. Verify Object Instantiation
        QObject *object = component.create();
        QVERIFY2(object != nullptr, "Failed to create root object from main QML component");

        // Ensure object has the correct title
        QVariant title = object->property("title");
        QVERIFY(title.isValid());
        QCOMPARE(title.toString(), QString("CADmarkable"));

        // Clean up
        delete object;
    }
};

QTEST_MAIN(TestMain)
#include "test_main.moc"
