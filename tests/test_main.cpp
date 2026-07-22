#include <QtTest>
#include <QQmlApplicationEngine>
#include <QCoreApplication>
#include <QLibraryInfo>
#include "CadController.h"
#include <QQmlComponent>

class TestMain : public QObject
{
    Q_OBJECT

private slots:
    void testMainAppLoading()
    {
        QQmlApplicationEngine engine;
        engine.addImportPath(QLibraryInfo::path(QLibraryInfo::QmlImportsPath));
        engine.addImportPath("qrc:/");

        // 2. Verify Component Loading
        QQmlComponent component(&engine);
        component.loadFromModule("CADmarkable_app", "Main");

        if (component.isError()) {
            qDebug() << component.errorString();
        }
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
