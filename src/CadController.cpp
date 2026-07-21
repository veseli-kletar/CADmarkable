#include "CadController.h"

CadController::CadController(QObject *parent)
    : QObject(parent)
    , m_activeTool("Select")
    , m_sketchRectX(0.0)
    , m_sketchRectY(0.0)
    , m_sketchRectWidth(0.0)
    , m_sketchRectHeight(0.0)
    , m_sketchLineStartX(0.0)
    , m_sketchLineStartY(0.0)
    , m_sketchLineEndX(0.0)
    , m_sketchLineEndY(0.0)
    , m_extrusionDepth(0.0)
{
}

QString CadController::activeTool() const
{
    return m_activeTool;
}

void CadController::setActiveTool(const QString &tool)
{
    if (m_activeTool != tool) {
        m_activeTool = tool;
        emit activeToolChanged();
    }
}

double CadController::sketchRectX() const
{
    return m_sketchRectX;
}

void CadController::setSketchRectX(double x)
{
    if (m_sketchRectX != x) {
        m_sketchRectX = x;
        emit sketchRectXChanged();
    }
}

double CadController::sketchRectY() const
{
    return m_sketchRectY;
}

void CadController::setSketchRectY(double y)
{
    if (m_sketchRectY != y) {
        m_sketchRectY = y;
        emit sketchRectYChanged();
    }
}

double CadController::sketchRectWidth() const
{
    return m_sketchRectWidth;
}

void CadController::setSketchRectWidth(double w)
{
    if (m_sketchRectWidth != w) {
        m_sketchRectWidth = w;
        emit sketchRectWidthChanged();
    }
}

double CadController::sketchRectHeight() const
{
    return m_sketchRectHeight;
}

void CadController::setSketchRectHeight(double h)
{
    if (m_sketchRectHeight != h) {
        m_sketchRectHeight = h;
        emit sketchRectHeightChanged();
    }
}

double CadController::sketchLineStartX() const
{
    return m_sketchLineStartX;
}

void CadController::setSketchLineStartX(double x)
{
    if (m_sketchLineStartX != x) {
        m_sketchLineStartX = x;
        emit sketchLineStartXChanged();
    }
}

double CadController::sketchLineStartY() const
{
    return m_sketchLineStartY;
}

void CadController::setSketchLineStartY(double y)
{
    if (m_sketchLineStartY != y) {
        m_sketchLineStartY = y;
        emit sketchLineStartYChanged();
    }
}

double CadController::sketchLineEndX() const
{
    return m_sketchLineEndX;
}

void CadController::setSketchLineEndX(double x)
{
    if (m_sketchLineEndX != x) {
        m_sketchLineEndX = x;
        emit sketchLineEndXChanged();
    }
}

double CadController::sketchLineEndY() const
{
    return m_sketchLineEndY;
}

void CadController::setSketchLineEndY(double y)
{
    if (m_sketchLineEndY != y) {
        m_sketchLineEndY = y;
        emit sketchLineEndYChanged();
    }
}

double CadController::extrusionDepth() const
{
    return m_extrusionDepth;
}

void CadController::setExtrusionDepth(double depth)
{
    if (m_extrusionDepth != depth) {
        m_extrusionDepth = depth;
        emit extrusionDepthChanged();
    }
}
