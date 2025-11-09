#ifndef MWINDOWSTATE_H
#define MWINDOWSTATE_H

#include <qglobal.h>
#include <qqml.h>

#ifdef HAVE_MALIIT
#include <maliit/inputmethod.h>
#endif

class MWindowStatePrivate;

// MWindowState provides visibility information on the window
// associated to a QML application in MeeGo.
class MWindowState : public QObject
{
    Q_OBJECT

    Q_PROPERTY(bool visible READ visible NOTIFY visibleChanged FINAL)
    Q_PROPERTY(bool active READ active NOTIFY activeChanged FINAL)
    Q_PROPERTY(bool animating READ animating WRITE setAnimating NOTIFY animatingChanged FINAL)
    Q_PROPERTY(ViewMode viewMode READ viewMode NOTIFY viewModeChanged FINAL)
    Q_PROPERTY(QString viewModeString READ viewModeString NOTIFY viewModeChanged FINAL)

    Q_ENUMS(ViewMode)

public:

    Q_INVOKABLE void startSipOrientationChange(int newOrientation) {
#ifdef HAVE_MALIIT
        Maliit::OrientationAngle newOrientationAngle = static_cast<Maliit::OrientationAngle>(newOrientation);
        Maliit::InputMethod::instance()->startOrientationAngleChange(newOrientationAngle);
#else
        Q_UNUSED(newOrientation)
#endif
    }
    
    Q_INVOKABLE void finishSipOrientationChange(int newOrientation) {
#ifdef HAVE_MALIIT
        Maliit::OrientationAngle newOrientationAngle = static_cast<Maliit::OrientationAngle>(newOrientation);
        Maliit::InputMethod::instance()->setOrientationAngle(newOrientationAngle);
#else
        Q_UNUSED(newOrientation)
#endif
    }

    // Possible view modes for a window:
    // - Fullsize for a window that is in the maximized state.
    //   This is the default state.
    // - Thumbnail for a window that is minimized to the switcher.
    //   Thumbnail mode is activated when the window can be seen
    //   in the switcher.
    enum ViewMode {
        Fullsize,
        Thumbnail
    };

    static MWindowState* instance();
    ~MWindowState();

    // Return the current view mode
    ViewMode viewMode() const;

    // Return the current view mode as a string:
    // - "Fullsize" for Fullsize
    // - "Thumbnail" for Thumbnail
    QString viewModeString() const;

    // Returns true, if the window or its thumbnail can be seen.
    // Returns false, if the window or its thumbnail has been hidden
    // at least for 1000 ms.
    bool visible() const;

    // Return true, if the window is active (has focus).
    bool active() const;

    // Return true, if the window orientation is animated
    bool animating() const;

    void setAnimating(bool animatingStatus);

Q_SIGNALS:

    // Signal that is emitted when active-property changes.
    void activeChanged();

    // Signal that is emitted when viewMode-property changes.
    void viewModeChanged();

    // Signal that is emitted when visible-property changes.
    void visibleChanged();

    // Signal that is emitted when orientation animation starts or finishes.
    void animatingChanged();
protected:

    MWindowStatePrivate *const d_ptr;

private:
    explicit MWindowState(QObject *parent = 0);
    Q_DECLARE_PRIVATE(MWindowState)
    Q_DISABLE_COPY(MWindowState)

#ifdef Q_WS_X11
private Q_SLOTS:
    void _q_doVisibleChangedNotVisible();
#endif // Q_WS_X11

#ifdef UNIT_TEST
    friend class tst_MWindowState;
#endif // UNIT_TEST
};

QML_DECLARE_TYPE(MWindowState)
#endif // MWINDOWSTATE_H
