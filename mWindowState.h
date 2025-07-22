#ifndef MWINDOWSTATE_H
#define MWINDOWSTATE_H

#include <QObject> // Base class
#include <qqml.h> // For QML_DECLARE_TYPE (though we're removing it for this specific type)

class MWindowStatePrivate; // Forward declaration

// MWindowState provides visibility information on the window
// associated to a QML application.
class MWindowState : public QObject
{
    Q_OBJECT // Required for signals, slots, and properties

public:
    // Possible view modes for a window:
    enum ViewMode {
        Fullsize,
        Thumbnail
    };
    Q_ENUM(ViewMode) // Register ViewMode enum for QML

    // Q_PROPERTY declarations (updated for Qt 6 syntax)
    Q_PROPERTY(bool visible READ visible NOTIFY visibleChanged FINAL)
    Q_PROPERTY(bool active READ active NOTIFY activeChanged FINAL)
    Q_PROPERTY(bool animating READ animating WRITE setAnimating NOTIFY animatingChanged FINAL)
    Q_PROPERTY(ViewMode viewMode READ viewMode NOTIFY viewModeChanged FINAL)
    Q_PROPERTY(QString viewModeString READ viewModeString NOTIFY viewModeChanged FINAL)

public:
    // Singleton instance access
    static MWindowState* instance();
    virtual ~MWindowState();

    // Public API READ methods
    ViewMode viewMode() const;
    QString viewModeString() const;
    bool visible() const;
    bool active() const;
    bool animating() const;

    // Public API WRITE method
    void setAnimating(bool animatingStatus);

Q_SIGNALS:
    // Signals (no FINAL keyword here)
    void activeChanged();
    void viewModeChanged();
    void visibleChanged();
    void animatingChanged();

private:
    // Private constructor for singleton pattern
    explicit MWindowState(QObject *parent = nullptr); // Use nullptr

    MWindowStatePrivate *d_ptr;

    Q_DECLARE_PRIVATE(MWindowState) // Declares the private implementation
    Q_DISABLE_COPY(MWindowState) // Disables copy constructor and assignment operator

private Q_SLOTS: // New private slot to act as a bridge
    void _q_onVisibleChangedTimeout();
};

// --- CHANGE START ---
// Removed QML_DECLARE_TYPE(MWindowState) as it's registered as a singleton in main.cpp
// QML_DECLARE_TYPE(MWindowState)
// --- CHANGE END ---

#endif // MWINDOWSTATE_H
