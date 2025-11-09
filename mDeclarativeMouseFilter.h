// mDeclarativeMouseFilter.h
#ifndef MDECLARATIVEMOUSEFILTER_H
#define MDECLARATIVEMOUSEFILTER_H

#include <QQuickItem>
#include <QMouseEvent>
#include <QPointF> // Ensure QPointF is included

// MDeclarativeMouseEvent: A wrapper to pass mouse event data to QML.
// Q_PROPERTY(int x READ x NOTIFY xChanged) ensures QML can react to changes, though here it's more for data transfer.
class MDeclarativeMouseEvent : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int x READ x NOTIFY xChanged)
    Q_PROPERTY(int y READ y NOTIFY yChanged)
    Q_PROPERTY(bool filtered READ isFiltered WRITE setFiltered NOTIFY filteredChanged)

public:
    // Explicit constructor to avoid implicit conversions
    explicit MDeclarativeMouseEvent(QObject *parent = nullptr)
        : QObject(parent), _x(0), _y(0), _filtered(false) {}
    // Constructor to initialize with a QPointF
    MDeclarativeMouseEvent(const QPointF &point, QObject *parent = nullptr)
        : QObject(parent), _x(int(point.x())), _y(int(point.y())), _filtered(false) {}

    // Read accessors for properties
    int x() const { return _x; }
    int y() const { return _y; }

    bool isFiltered() const { return _filtered; }
    void setFiltered(bool filtered) {
        if (_filtered != filtered) {
            _filtered = filtered;
            emit filteredChanged();
        }
    }

signals:
    // Signals for property changes (good practice for Q_PROPERTY with NOTIFY)
    void xChanged();
    void yChanged();
    void filteredChanged();

private:
    int _x;
    int _y;
    bool _filtered;
};


// MDeclarativeMouseFilter: QQuickItem subclass to intercept and process mouse events.
class MDeclarativeMouseFilter : public QQuickItem
{
    Q_OBJECT

public:
    explicit MDeclarativeMouseFilter(QQuickItem *parent = nullptr);
    ~MDeclarativeMouseFilter() override; // Use override for virtual functions

signals:
    // Signals to communicate mouse events to QML
    void mousePositionChanged(MDeclarativeMouseEvent *mouse); // Mouse moved (without drag/press state)
    void pressed(MDeclarativeMouseEvent *mouse);              // Mouse button pressed down
    void delayedPressSent();                                  // Indicates a delayed press was "sent" (e.g., after movement threshold)
    void pressAndHold(MDeclarativeMouseEvent *mouse);         // Long press detected
    void released(MDeclarativeMouseEvent *mouse);             // Mouse button released
    void finished();                                          // Signals that the gesture handling is complete (after release)
    void horizontalDrag();                                    // Horizontal drag detected (for selection)
    void doubleClicked(MDeclarativeMouseEvent *mouse);        // Double click detected

protected:
    // QQuickItem overrides for mouse event handling
    void itemChange(ItemChange, const ItemChangeData &) override;
    void mouseDoubleClickEvent(QMouseEvent *event) override;
    void mousePressEvent(QMouseEvent *event) override;
    void mouseMoveEvent(QMouseEvent *event) override;
    void mouseReleaseEvent(QMouseEvent *event) override;
    void mouseUngrabEvent() override; // Called when mouse grab is lost
    void timerEvent(QTimerEvent *ev) override; // For the press-and-hold timer

private:
    // Internal timer ID for press-and-hold
    int pressAndHoldTimerId;

    // Last known mapped and clamped position of the mouse
    QPointF lastMappedClampedPos;
    // Initial press position, mapped and clamped
    QPointF initialPressMappedClampedPos;
    // Initial raw QMouseEvent::position() when button was pressed
    QPointF pressPos;

    // Delayed press info (used to "replay" an initial press if a drag starts after short hold)
    bool hasDelayedPress;
    QPointF delayedPressMappedClampedPos; // Stored mapped and clamped position for delayed press

    // Helper to map and clamp a raw QMouseEvent position
    QPointF mapAndClampPosition(const QPointF &rawPos);
};

#endif // MDECLARATIVEMOUSEFILTER_H
