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
        // Use standard environment variables or library paths, do not hardcode absolute paths
        engine.addImportPath(qEnvironmentVariable("QML2_IMPORT_PATH"));
        engine.addImportPath(QLibraryInfo::path(QLibraryInfo::QmlImportsPath));
        engine.addImportPath("qrc:/");

        // 2. Verify Component Loading
        QQmlComponent component(&engine, QUrl(u"qrc:/CADmarkable_app/src/Main.qml"_qs));

        if (component.isError()) {
            qDebug() << component.errorString();
        }

        if (component.isError()) {
            QQmlComponent fallback(&engine, QUrl(u"qrc:/qt/qml/CADmarkable_app/Main.qml"_qs));
            if (!fallback.isError()) {
                // If fallback worked, use it. (The resource path depends on qt version/build config)
                component.loadUrl(QUrl(u"qrc:/qt/qml/CADmarkable_app/Main.qml"_qs));
            } else {
                qDebug() << "Fallback also failed:" << fallback.errorString();
            }
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
