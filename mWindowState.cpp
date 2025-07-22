#include <QGuiApplication> // For QGuiApplication::activeWindow() and primaryScreen()
#include <QWindow> // For QWindow and its state
#include <QDebug>
#include <QTimer> // For QTimer

#include "mWindowState.h"
#include "mWindowState_p.h"

MWindowStatePrivate * MWindowStatePrivate::instance = nullptr; // Use nullptr

MWindowStatePrivate::MWindowStatePrivate(MWindowState *qq)
    : q_ptr(qq) // Initialize the back-pointer to the public class
    // --- CHANGE START ---
    // Changed 'viewMode' to 'viewModeInt' to match the declaration in mwindowstate_p.h
    , viewModeInt(MWindowState::Fullsize)
    // --- CHANGE END ---
    , visible(true) // Default to visible
    , active(false) // Default to not active
    , animating(false)
{
    MWindowStatePrivate::instance = this;

    // Initialize the timer for delayed visibility changes
    // Use a lambda to connect to the non-QObject member function
    QObject::connect(&visibleChangedTimer, &QTimer::timeout,
                     q_ptr, &MWindowState::_q_onVisibleChangedTimeout);
    visibleChangedTimer.setInterval(1000); // 1000 ms delay
    visibleChangedTimer.setSingleShot(true);
}

MWindowState::~MWindowState()
{
    // The private object is owned by the public one, so it's deleted here.
    delete d_ptr;
}

MWindowStatePrivate::~MWindowStatePrivate()
{
    // No specific cleanup needed here for Qt6.
}

void MWindowStatePrivate::doActiveChanged(bool newActive)
{
    Q_Q(MWindowState); // Get pointer to public class

    if (active != newActive) {
        active = newActive;
        emit q->activeChanged();
    }
}

void MWindowStatePrivate::doVisibleChangedNotVisible()
{
    Q_Q(MWindowState); // Get pointer to public class

    // This logic is simplified for Qt6. If the timer fires, it means
    // no "visible" event happened in the delay, so assume not visible.
    if (visible) { // Only change if currently visible
        visible = false;
        emit q->visibleChanged();
    }
}

void MWindowStatePrivate::doViewModeChanged(MWindowState::ViewMode newViewMode)
{
    Q_Q(MWindowState); // Get pointer to public class

    // --- CHANGE START ---
    // Changed 'viewMode' to 'viewModeInt'
    if (static_cast<MWindowState::ViewMode>(viewModeInt) != newViewMode) {
        viewModeInt = static_cast<int>(newViewMode);
        emit q->viewModeChanged();
    }
    // --- CHANGE END ---
}

void MWindowStatePrivate::doVisibleChanged(bool newVisible)
{
    Q_Q(MWindowState); // Get pointer to public class

    if (visible != newVisible) {
        if (newVisible) {
            visibleChangedTimer.stop(); // Stop timer if becoming visible
            visible = true;
            emit q->visibleChanged();
            // In Qt6, active status is often managed by QWindow::active property.
            // This might need adjustment based on how 'active' is truly determined.
            // For now, assume if it becomes visible, it might also become active.
            // doActiveChanged(true); // This might be too aggressive, review if needed.
        } else {
            visibleChangedTimer.start(); // Start timer for delayed hide
            // Set the window not active immediately if it's becoming hidden
            doActiveChanged(false);
        }
    }
}

// Public API implementation for MWindowState
MWindowState* MWindowState::instance()
{
    // Standard singleton pattern for the public class
    static MWindowState selfInstance(nullptr); // Create the public singleton instance once
    if (!MWindowStatePrivate::instance) { // Ensure private instance is created only once
        MWindowStatePrivate::instance = new MWindowStatePrivate(&selfInstance); // Pass public instance to private constructor
    }
    selfInstance.d_ptr = MWindowStatePrivate::instance; // Assign the private instance to the public one
    return &selfInstance;
}

MWindowState::MWindowState(QObject *parent) :
    QObject(parent),
    d_ptr(nullptr) // Initialize d_ptr to nullptr, it will be set by instance()
{
    // The actual initialization of d_ptr happens in MWindowState::instance()
    // to ensure the singleton pattern.
}

// Implementation of the new private slot
void MWindowState::_q_onVisibleChangedTimeout()
{
    Q_D(MWindowState); // Get pointer to private class
    d->doVisibleChangedNotVisible(); // Call the private implementation method
}

MWindowState::ViewMode MWindowState::viewMode() const
{
    Q_D(const MWindowState);
    // --- CHANGE START ---
    // Return viewModeInt cast to MWindowState::ViewMode
    return static_cast<MWindowState::ViewMode>(d->viewModeInt);
    // --- CHANGE END ---
}

QString MWindowState::viewModeString() const
{
    Q_D(const MWindowState);

    const char *s = nullptr; // Use nullptr
    // --- CHANGE START ---
    // Use viewModeInt in the switch statement
    switch (static_cast<MWindowState::ViewMode>(d->viewModeInt)) {
    // --- CHANGE END ---
    case Fullsize:
        s = "Fullsize";
        break;
    case Thumbnail:
        s = "Thumbnail";
        break;
    default:
        s = "Unknown";
        break;
    }
    return QString::fromLatin1(s);
}

bool MWindowState::visible() const
{
    Q_D(const MWindowState);
    // In Qt6, visible state of the main QQuickWindow can be queried directly.
    // This 'visible' property is now managed by the custom logic in doVisibleChanged.
    return d->visible;
}

bool MWindowState::active() const
{
    Q_D(const MWindowState);
    // In Qt6, QWindow::isActive() is the standard way to check activity.
    // This 'active' property is now managed by the custom logic in doActiveChanged.
    return d->active;
}

bool MWindowState::animating() const
{
    Q_D(const MWindowState);
    return d->animating;
}

void MWindowState::setAnimating(bool animatingStatus)
{
    Q_D(MWindowState);
    if (animatingStatus != d->animating) {
        d->animating = animatingStatus;
        emit animatingChanged();
    }
}
