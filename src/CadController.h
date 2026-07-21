#ifndef CADCONTROLLER_H
#define CADCONTROLLER_H

#include <QObject>
#include <QString>
#include <QtQml/qqml.h>

class CadController : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString activeTool READ activeTool WRITE setActiveTool NOTIFY activeToolChanged)

    Q_PROPERTY(double sketchRectX READ sketchRectX WRITE setSketchRectX NOTIFY sketchRectXChanged)
    Q_PROPERTY(double sketchRectY READ sketchRectY WRITE setSketchRectY NOTIFY sketchRectYChanged)
    Q_PROPERTY(double sketchRectWidth READ sketchRectWidth WRITE setSketchRectWidth NOTIFY sketchRectWidthChanged)
    Q_PROPERTY(double sketchRectHeight READ sketchRectHeight WRITE setSketchRectHeight NOTIFY sketchRectHeightChanged)

    Q_PROPERTY(double sketchLineStartX READ sketchLineStartX WRITE setSketchLineStartX NOTIFY sketchLineStartXChanged)
    Q_PROPERTY(double sketchLineStartY READ sketchLineStartY WRITE setSketchLineStartY NOTIFY sketchLineStartYChanged)
    Q_PROPERTY(double sketchLineEndX READ sketchLineEndX WRITE setSketchLineEndX NOTIFY sketchLineEndXChanged)
    Q_PROPERTY(double sketchLineEndY READ sketchLineEndY WRITE setSketchLineEndY NOTIFY sketchLineEndYChanged)

    Q_PROPERTY(double extrusionDepth READ extrusionDepth WRITE setExtrusionDepth NOTIFY extrusionDepthChanged)

    QML_ELEMENT

public:
    explicit CadController(QObject *parent = nullptr);

    QString activeTool() const;
    void setActiveTool(const QString &tool);

    double sketchRectX() const;
    void setSketchRectX(double x);

    double sketchRectY() const;
    void setSketchRectY(double y);

    double sketchRectWidth() const;
    void setSketchRectWidth(double w);

    double sketchRectHeight() const;
    void setSketchRectHeight(double h);

    double sketchLineStartX() const;
    void setSketchLineStartX(double x);

    double sketchLineStartY() const;
    void setSketchLineStartY(double y);

    double sketchLineEndX() const;
    void setSketchLineEndX(double x);

    double sketchLineEndY() const;
    void setSketchLineEndY(double y);

    double extrusionDepth() const;
    void setExtrusionDepth(double depth);

signals:
    void activeToolChanged();
    void sketchRectXChanged();
    void sketchRectYChanged();
    void sketchRectWidthChanged();
    void sketchRectHeightChanged();

    void sketchLineStartXChanged();
    void sketchLineStartYChanged();
    void sketchLineEndXChanged();
    void sketchLineEndYChanged();

    void extrusionDepthChanged();

private:
    QString m_activeTool;
    double m_sketchRectX;
    double m_sketchRectY;
    double m_sketchRectWidth;
    double m_sketchRectHeight;
    double m_sketchLineStartX;
    double m_sketchLineStartY;
    double m_sketchLineEndX;
    double m_sketchLineEndY;
    double m_extrusionDepth;
};

#endif // CADCONTROLLER_H
