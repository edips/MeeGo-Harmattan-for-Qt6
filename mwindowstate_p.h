#ifndef MWINDOWSTATE_P_H
#define MWINDOWSTATE_P_H

#ifdef Q_WS_X11
#include <QX11Info>
#include "mx11wrapper.h"
#endif

#include <QTimer>

class MWindowStatePrivate
{
public:

    MWindowStatePrivate();
    virtual ~MWindowStatePrivate();

#ifdef Q_WS_X11
    void initVisibilityWatcher();
    void initVisibleChangedTimer();
    void handleXVisibilityEvent(XVisibilityEvent *xevent);
    void handleXPropertyEvent(XPropertyEvent *xevent);
    void handleXFocusChangeEvent(XFocusChangeEvent *xevent);
    void appendEventMask(Window win);
    static bool eventFilter(void *message, long int *result);
    static bool isMeeGoWindowManagerRunning();
    void doActiveChanged(bool newActive);
    void _q_doVisibleChangedNotVisible();
    void doVisibleChanged(bool newVisible);
    void doViewModeChanged(MWindowState::ViewMode newViewMode);
    Window effectiveWinId(Window winIdFromEvent);
#endif // Q_WS_X11

protected:

    MWindowState * q_ptr;

private:

    // Represents the focus information received from X11
    enum FocusEvent { FENone, FEFocusIn, FEFocusOut };

    static bool (*origEventFilter)(void*, long int*);
    static MWindowStatePrivate *instance;

    MWindowState::ViewMode viewMode;

    // Latest FocusChangeEvent received from X11
    FocusEvent focus;

    // True, if window or thumbnail is visible
    bool visible;

    // True, if the window has focus
    bool active;

    // True, if VisibilityFullyObscured was the most recent
    // visibility event received from X11
    bool fullyObscured;

    // True, if _MEEGOTOUCH_VISIBLE_IN_SWITCHER is set
    bool visibleInSwitcherPropertySet;

    // Timer used to delay transitions from visible to hidden.
    // (Solves race condition between _MEEGOTOUCH_VISIBLE_IN_SWITCHER
    //  and fullyObscured).
    QTimer visibleChangedTimer;

    bool animating;

    bool eventMaskSet;

    Q_DECLARE_PUBLIC(MWindowState)
};

#endif // MWINDOWSTATE_P_H
