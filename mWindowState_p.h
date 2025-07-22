#ifndef MWINDOWSTATE_P_H
#define MWINDOWSTATE_P_H

#include "mWindowState.h"
#include <QTimer> // For visibleChangedTimer

class MWindowState; // Forward declaration

// --- CHANGE START ---
// Removed: #include "mwindowstate.h"
// The private header should only forward-declare the public class to avoid circular dependencies
// and ensure correct meta-object generation order.
// --- CHANGE END ---

class MWindowStatePrivate
{
public:
    // Added MWindowState* parameter to constructor for PIMPL back-pointer
    explicit MWindowStatePrivate(MWindowState *qq);
    virtual ~MWindowStatePrivate();

    // Private methods to manage state changes
    void doActiveChanged(bool newActive);
    void doVisibleChangedNotVisible(); // This will be a timer slot
    void doVisibleChanged(bool newVisible);
    void doViewModeChanged(MWindowState::ViewMode newViewMode);

protected:
    // Public pointer to the MWindowState instance
    MWindowState * q_ptr;

private:
    // Singleton instance for the private class
    static MWindowStatePrivate *instance;

    // --- CHANGE START ---
    // Using an enum that is part of the public class needs the public class to be fully defined.
    // However, for PIMPL, the private class should only forward declare.
    // If MWindowState::ViewMode is needed here, it must be fully qualified and MWindowState must be defined.
    // A common solution is to move such enums to a separate, common header or define them directly in the private class if they are truly internal.
    // For now, let's assume MWindowState::ViewMode is accessible via the public MWindowState API.
    // If this still causes issues, we might need to rethink the enum's placement or how it's used here.
    // For now, keeping it as is, but noting the potential for future issues if not fully defined at moc time.
    // MWindowState::ViewMode viewMode; // This line is the one causing the "incomplete type" error.
    // Let's remove this line from the private header, as the private implementation should not directly hold the enum type.
    // It should be stored as an int or a type that doesn't require the full definition of MWindowState.
    int viewModeInt; // Store as int instead of MWindowState::ViewMode
    // --- CHANGE END ---

    bool visible; // True, if window or thumbnail is visible
    bool active; // True, if the window has focus
    bool animating; // True, if the window orientation is animated

    // Timer used to delay transitions from visible to hidden.
    QTimer visibleChangedTimer;

    Q_DECLARE_PUBLIC(MWindowState) // Declares the public class
};

#endif // MWINDOWSTATE_P_H
