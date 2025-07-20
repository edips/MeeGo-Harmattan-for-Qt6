#include "mOrientationHelper.h"

OrientationMonitor::OrientationMonitor(QObject *parent)
    : QObject(parent),
    m_orientation("SQUARE") // Initialize with a default value
{
}

QString OrientationMonitor::orientation() const
{
    return m_orientation;
}

void OrientationMonitor::setWindow(QQuickWindow *window)
{
    if (m_window) {
        // Disconnect previous connections if a window was already set
        disconnect(m_window, &QQuickWindow::widthChanged, this, &OrientationMonitor::onWindowWidthChanged);
        disconnect(m_window, &QQuickWindow::heightChanged, this, &OrientationMonitor::onWindowHeightChanged);
    }

    m_window = window;
    if (m_window) {
        // Connect to the window's width and height changed signals
        connect(m_window, &QQuickWindow::widthChanged, this, &OrientationMonitor::onWindowWidthChanged);
        connect(m_window, &QQuickWindow::heightChanged, this, &OrientationMonitor::onWindowHeightChanged);

        // Perform an initial update based on the window's current dimensions
        updateOrientation(m_window->width(), m_window->height());
    }
}

void OrientationMonitor::onWindowWidthChanged(int width)
{
    if (m_window) {
        updateOrientation(width, m_window->height());
    }
}

void OrientationMonitor::onWindowHeightChanged(int height)
{
    if (m_window) {
        updateOrientation(m_window->width(), height);
    }
}

void OrientationMonitor::updateOrientation(int width, int height)
{
    QString newOrientation;
    if (width > height) {
        newOrientation = "Landscape";
    } else if (width < height || width == height) {
        newOrientation = "Portrait";
    }

    if (m_orientation != newOrientation) {
        m_orientation = newOrientation;
        emit orientationChanged();
    }
}
