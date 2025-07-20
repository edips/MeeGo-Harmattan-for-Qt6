#ifndef ORIENTATIONMONITOR_H
#define ORIENTATIONMONITOR_H

#include <QObject>
#include <QString>
#include <QQuickWindow> // Include QQuickWindow

class OrientationMonitor : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString orientation READ orientation NOTIFY orientationChanged)

public:
    explicit OrientationMonitor(QObject *parent = nullptr);

    QString orientation() const;

    // New method to set the QQuickWindow and connect signals
    void setWindow(QQuickWindow *window);

signals:
    void orientationChanged();

private slots:
    // Slots to be connected to QQuickWindow's widthChanged and heightChanged signals
    void onWindowWidthChanged(int width);
    void onWindowHeightChanged(int height);

private:
    QString m_orientation;
    QQuickWindow *m_window = nullptr; // Store a pointer to the window
    void updateOrientation(int width, int height); // Helper to determine and update orientation
};

#endif // ORIENTATIONMONITOR_H
