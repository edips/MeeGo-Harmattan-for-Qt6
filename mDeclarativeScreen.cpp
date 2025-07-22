#include <QDebug>
#include <QGuiApplication>
#include <QScreen> // For QScreen and screen orientation
#include <QWindow> // For QWindow and window state
#include <QtMath> // For sqrt
#include <QTimer> // For potential timers (if any remain)

#include "mDeclarativeScreen.h"
#include "mWindowState.h"// Still needed for MWindowState::instance()

// Constants for display categories and densities (kept as they are generic)
static const qreal CATEGORY_SMALL_LIMIT  = 3.2;
static const qreal CATEGORY_MEDIUM_LIMIT = 4.5;
static const qreal CATEGORY_LARGE_LIMIT  = 7.0;
static const qreal DENSITY_SMALL_LIMIT   = 140.0;
static const qreal DENSITY_MEDIUM_LIMIT  = 180.0;
static const qreal DENSITY_LARGE_LIMIT   = 270.0;

// Private implementation class (PIMPL)
class MDeclarativeScreenPrivate
{
public:
    MDeclarativeScreenPrivate(MDeclarativeScreen *qq);
    ~MDeclarativeScreenPrivate();

    // Private helper methods
    void initContextSubscriber(); // Establishes connections to Qt signals
    void updateScreenSize(); // Updates platformWidth/Height based on current orientation
    void updateX11OrientationAngleProperty(); // This will become a no-op or removed for Android
    void updateIsCovered(); // Placeholder for isCovered
    void updateIsKeyboardOpen(); // Placeholder for isKeyboardOpen
    void updateIsTvConnected(); // Placeholder for isTvConnected
    void updateWindowStateAnimation(); // Handles MWindowState animatingChanged

    qreal dpi() const; // Calculates DPI
    int rotation() const; // Calculates rotation angle based on orientation

    MDeclarativeScreen::Orientation physicalOrientation() const; // Gets physical screen orientation

    MDeclarativeScreen *q; // Pointer to the public API class

    MDeclarativeScreen::Orientation orientation; // Current logical orientation
    MDeclarativeScreen::Orientation finalOrientation; // Target orientation after animation
    MDeclarativeScreen::Orientations allowedOrientations; // Allowed orientations
    MDeclarativeScreen::Direction rotationDirection; // Direction of rotation

    bool isCovered; // Placeholder
    bool keyboardOpen; // Placeholder
    bool isTvConnected; // Placeholder

    // QPointer for the main application window (QQuickWindow)
    QPointer<QWindow> window; // Changed from QQuickWindow to QWindow to allow QWindow* assignments

    QSize displaySize; // Native display size (e.g., 1080x2125 for S23 FE)
    QSize screenSize; // Orientation-corrected screen size (e.g., 1080x2125 or 2125x1080)
    int frameBufferRotation; // Framebuffer rotation (often 0 on Android, managed by OS)

    bool allowSwipe; // Placeholder, as X11 specific functionality is removed

    // MWindowState related properties (managed by MWindowState class)
    bool minimized;
    MDeclarativeScreen::Orientations _physicalDisplayOrientation; // Physical orientation of the device

    // Moved these methods from MDeclarativeScreen to MDeclarativeScreenPrivate
    void setMinimized(bool m);
    bool isMinimized() const;
    bool isRemoteScreenPresent() const;
    QString topEdgeValue() const;
};

// Singleton instance retrieval
MDeclarativeScreen* MDeclarativeScreen::instance()
{
    static MDeclarativeScreen *self = nullptr; // Use nullptr

    if (!self)
        self = new MDeclarativeScreen();
    return self;
}

// Private implementation constructor
MDeclarativeScreenPrivate::MDeclarativeScreenPrivate(MDeclarativeScreen *qq)
    : q(qq)
#ifdef Q_OS_ANDROID // Default orientation for Android is usually Portrait
    , orientation(MDeclarativeScreen::Portrait)
    , finalOrientation(MDeclarativeScreen::Portrait)
#else // For desktop, default to Portrait
    , orientation(MDeclarativeScreen::Portrait)
    , finalOrientation(MDeclarativeScreen::Portrait)
#endif
    , allowedOrientations(MDeclarativeScreen::Landscape | MDeclarativeScreen::Portrait) // Default allowed
    , rotationDirection(MDeclarativeScreen::NoDirection)
    , isCovered(false)
    , keyboardOpen(false)
    , isTvConnected(false)
    , frameBufferRotation(0) // Android typically handles framebuffer rotation internally
    , allowSwipe(true)
    , minimized(false)
{
    // Get initial display size from primary screen
    if (QGuiApplication::primaryScreen()) {
        displaySize = QGuiApplication::primaryScreen()->size();
        _physicalDisplayOrientation = physicalOrientation(); // Determine initial physical orientation
    } else {
        qWarning() << "No primary screen found during MDeclarativeScreen initialization.";
    }
}

MDeclarativeScreenPrivate::~MDeclarativeScreenPrivate()
{
    // No explicit cleanup needed for QObjects with parents or raw pointers handled by Qt
}

// Initializes connections to Qt's screen and window state signals
void MDeclarativeScreenPrivate::initContextSubscriber()
{
    QScreen* primaryScreen = QGuiApplication::primaryScreen();
    if (primaryScreen) {
        // Connect to QScreen's orientationChanged for automatic updates
        QObject::connect(primaryScreen, &QScreen::orientationChanged,
                         q, [this](){ q->setOrientation(physicalOrientation()); }); // Use lambda to call private method

        // Connect to QScreen's geometryChanged for display size updates
        QObject::connect(primaryScreen, &QScreen::geometryChanged,
                         q, [this](){
                             displaySize = QGuiApplication::primaryScreen()->size();
                             updateScreenSize();
                             emit q->displayChanged(); // Notify QML about display size changes
                         });
    } else {
        qWarning() << "No valid QScreen found, orientation and display size updates may not work!";
    }

    // Connect to MWindowState's animatingChanged signal
    QObject::connect(MWindowState::instance(), &MWindowState::animatingChanged,
                     q, &MDeclarativeScreen::_q_onWindowStateAnimatingChanged); // Connect to public slot

    // Initial updates
    updateScreenSize();
    // --- CHANGE START ---
    // Emit physicalDisplayChanged here, after connections are established
    emit q->physicalDisplayChanged();
    // --- CHANGE END ---
}

// Updates `screenSize` based on `displaySize` and current `orientation`
void MDeclarativeScreenPrivate::updateScreenSize() {
    if (orientation == MDeclarativeScreen::Portrait || orientation == MDeclarativeScreen::PortraitInverted) {
        screenSize.setWidth(qMin(displaySize.width(), displaySize.height()));
        screenSize.setHeight(qMax(displaySize.width(), displaySize.height()));
    } else { // Landscape or LandscapeInverted
        screenSize.setWidth(qMax(displaySize.width(), displaySize.height()));
        screenSize.setHeight(qMin(displaySize.width(), displaySize.height()));
    }
    emit q->platformWidthChanged();
    emit q->platformHeightChanged();
}

// This function was X11 specific; it will be a no-op for Android/Qt6.
void MDeclarativeScreenPrivate::updateX11OrientationAngleProperty()
{
    if (!window.isNull()) {
        Qt::ScreenOrientation o = Qt::PrimaryOrientation;
        switch (q->rotation()) {
        case MDeclarativeScreen::LandscapeAngle: o = Qt::LandscapeOrientation; break;
        case MDeclarativeScreen::PortraitInvertedAngle: o = Qt::InvertedPortraitOrientation; break;
        case MDeclarativeScreen::LandscapeInvertedAngle: o = Qt::InvertedLandscapeOrientation; break;
        case MDeclarativeScreen::PortraitAngle: o = Qt::PortraitOrientation; break;
        default:
            qCritical() << "MDeclarativeScreen has invalid orientation set.";
        }
        if (o != Qt::PrimaryOrientation) {
            // window.data()->reportContentOrientationChange(o); // Deprecated in Qt6. Qt handles this.
        }
    }
}

// Removed _q_isCoveredChanged and _q_updateIsTvConnected as they were FIXMEs and X11/MeeGo specific.
void MDeclarativeScreenPrivate::updateIsCovered() { /* No-op for Qt6 Android */ }
void MDeclarativeScreenPrivate::updateIsKeyboardOpen() { /* No-op for Qt6 Android, use Qt.inputMethod.keyboardVisible */ }
void MDeclarativeScreenPrivate::updateIsTvConnected() { /* No-op for Qt6 Android */ }


qreal MDeclarativeScreenPrivate::dpi() const
{
    // Prefer logicalDotsPerInch() for UI scaling consistency.
    QScreen *screen = QGuiApplication::primaryScreen();
    // Cast window.data() to QScreen* as screen() returns QScreen*
    if (!window.isNull())
        screen = window.data()->screen();

    if (screen) {
        return screen->logicalDotsPerInch();
    }
    return 0; // Return 0 if no screen found
}

int MDeclarativeScreenPrivate::rotation() const
{
    // This logic calculates the angle based on the current logical orientation
    // relative to the physical display orientation.
    int angle = 0;

    if(_physicalDisplayOrientation & MDeclarativeScreen::Landscape) {
        switch (orientation) {
        case MDeclarativeScreen::Landscape:
            angle = 0;
            break;
        case MDeclarativeScreen::Portrait:
        case MDeclarativeScreen::Default:
            angle = 270;
            break;
        case MDeclarativeScreen::LandscapeInverted:
            angle = 180;
            break;
        case MDeclarativeScreen::PortraitInverted:
            angle = 90;
            break;
        default:
            qCritical() << "MDeclarativeScreen has invalid orientation set.";
        }
    } else { // Physical display is Portrait
        switch (orientation) {
        case MDeclarativeScreen::Landscape:
            angle = 90;
            break;
        case MDeclarativeScreen::Portrait:
        case MDeclarativeScreen::Default:
            angle = 0;
            break;
        case MDeclarativeScreen::LandscapeInverted:
            angle = 270;
            break;
        case MDeclarativeScreen::PortraitInverted:
            angle = 180;
            break;
        default:
            qCritical() << "MDeclarativeScreen has invalid orientation set.";
        }
    }
    return angle;
}

MDeclarativeScreen::Orientation MDeclarativeScreenPrivate::physicalOrientation() const
{
    MDeclarativeScreen::Orientation o = MDeclarativeScreen::Default;
    QScreen *screen = QGuiApplication::primaryScreen();
    // Cast window.data() to QScreen* as screen() returns QScreen*
    if (!window.isNull())
        screen = window.data()->screen();

    if (screen) {
        Qt::ScreenOrientation qtOrientation = screen->orientation();

        switch (qtOrientation) {
        case Qt::LandscapeOrientation:
            o = MDeclarativeScreen::Landscape;
            break;
        case Qt::PortraitOrientation:
            o = MDeclarativeScreen::Portrait;
            break;
        case Qt::InvertedLandscapeOrientation:
            o = MDeclarativeScreen::LandscapeInverted;
            break;
        case Qt::InvertedPortraitOrientation:
            o = MDeclarativeScreen::PortraitInverted;
            break;
        case Qt::PrimaryOrientation: // Fallback for PrimaryOrientation
            if (screen->size().width() > screen->size().height()) {
                o = MDeclarativeScreen::Landscape;
            } else {
                o = MDeclarativeScreen::Portrait;
            }
            break;
        }
    }
    return o;
}

// This function is now called when MWindowState::animatingChanged emits
void MDeclarativeScreenPrivate::updateWindowStateAnimation()
{
    // If MWindowState reports animation finished and target orientation is different, set it.
    if (!MWindowState::instance()->animating() && finalOrientation != orientation) {
        q->setOrientation(finalOrientation);
    }
}

// Moved implementation to MDeclarativeScreenPrivate
void MDeclarativeScreenPrivate::setMinimized(bool m) {
    if(minimized == m)
        return;

    minimized = m;
    emit q->minimizedChanged();
}

// Moved implementation to MDeclarativeScreenPrivate
bool MDeclarativeScreenPrivate::isMinimized() const {
    return minimized;
}

// Moved implementation to MDeclarativeScreenPrivate
bool MDeclarativeScreenPrivate::isRemoteScreenPresent() const {
    return false;
}

// Moved implementation to MDeclarativeScreenPrivate
QString MDeclarativeScreenPrivate::topEdgeValue() const {
    return QString();
}

// MDeclarativeScreen public API implementation
MDeclarativeScreen::MDeclarativeScreen(QObject *parent)
    : QObject(parent),
    d(new MDeclarativeScreenPrivate(this))
{
    d->initContextSubscriber(); // Initialize connections

    // Install event filter on the application object to catch QWindow state changes.
    // This is more robust than trying to install on a specific QQuickWindow instance
    // which might not be available at construction.
    QGuiApplication::instance()->installEventFilter(this);

    // --- CHANGE START ---
    // Removed emit physicalDisplayChanged() from constructor, moved to initContextSubscriber()
    // --- CHANGE END ---
}

MDeclarativeScreen::~MDeclarativeScreen()
{
    delete d;
}

// Event filter implementation
bool MDeclarativeScreen::eventFilter(QObject *o, QEvent *e) {
    if (e->type() != QEvent::WindowStateChange) {
        return QObject::eventFilter(o, e); // Pass to base class if not WindowStateChange
    }

    QWindow* w = qobject_cast<QWindow*>(o);
    if (!w) {
        return QObject::eventFilter(o, e);
    }

    // Assign the main application window if it's the target of the event filter
    // Assign QWindow* directly to QPointer<QWindow>
    if (d->window.isNull() || d->window.data() == w) {
        d->window = w;
    } else {
        qWarning() << "State change event from foreign window, ignoring.";
        return QObject::eventFilter(o, e);
    }

    // Handle minimized state based on QWindow::windowState()
    d->setMinimized(w->windowState() & Qt::WindowMinimized);

    if (!d->isMinimized()) {
        // If not minimized, and physical orientation is allowed, set it.
        if(d->physicalOrientation() & allowedOrientations()) {
            setOrientation(d->physicalOrientation());
        }
    }

    return QObject::eventFilter(o, e);
}

MDeclarativeScreen::Orientations MDeclarativeScreen::platformPhysicalDisplayOrientation() const
{
    return d->_physicalDisplayOrientation; // Use the stored physical orientation
}

void MDeclarativeScreen::setOrientation(Orientation o)
{
    d->finalOrientation = o;
    MDeclarativeScreen::Direction oldDirection = d->rotationDirection;

    if (d->orientation == o || MWindowState::instance()->animating())
        return;

    // Determine rotation direction
    if ( (d->orientation == MDeclarativeScreen::LandscapeInverted && o == MDeclarativeScreen::Portrait) ||
        (d->orientation == MDeclarativeScreen::PortraitInverted && o == MDeclarativeScreen::LandscapeInverted) ||
        (d->orientation == MDeclarativeScreen::Landscape && o == MDeclarativeScreen::PortraitInverted) ||
        (d->orientation == MDeclarativeScreen::Portrait && o == MDeclarativeScreen::Landscape) ) {
        d->rotationDirection = MDeclarativeScreen::CounterClockwise;
    }
    else {
        d->rotationDirection = MDeclarativeScreen::Clockwise;
    }
    if (oldDirection != d->rotationDirection)
        emit rotationDirectionChanged();

    Orientation newOrientation = Default;

    if (!(d->allowedOrientations & o)) {
        qDebug() << "Requested orientation" << o << "not in allowed orientations" << d->allowedOrientations;
        return; // Do not change if not allowed
    }

    newOrientation = o;

    d->orientation = newOrientation;

    d->updateScreenSize(); // Update sizes based on new orientation

    emit widthChanged(); // Deprecated, but kept for compatibility
    emit heightChanged(); // Deprecated, but kept for compatibility

    emit currentOrientationChanged();
}

MDeclarativeScreen::Orientation MDeclarativeScreen::currentOrientation() const
{
    return d->orientation;
}

void MDeclarativeScreen::setAllowedOrientations(Orientations orientation) {
    if (d->allowedOrientations == orientation)
        return;

    d->allowedOrientations = orientation;

    // Check if physical orientation fits allowed orientations, and switch if needed
    if(d->physicalOrientation() != d->orientation) {
        if(d->physicalOrientation() & d->allowedOrientations) {
            setOrientation(d->physicalOrientation());
        }
    }

    // Check if current orientation still fits allowed. If not, try to switch to an allowed one.
    if(!(d->orientation & d->allowedOrientations)) {
        if(d->allowedOrientations & MDeclarativeScreen::Portrait) {
            setOrientation(MDeclarativeScreen::Portrait);
            return;
        } else if(d->allowedOrientations & MDeclarativeScreen::Landscape) {
            setOrientation(MDeclarativeScreen::Landscape);
            return;
        } else if(d->allowedOrientations & MDeclarativeScreen::LandscapeInverted) {
            setOrientation(MDeclarativeScreen::LandscapeInverted);
            return;
        } else if(d->allowedOrientations & MDeclarativeScreen::PortraitInverted) {
            setOrientation(MDeclarativeScreen::PortraitInverted);
            return;
        }
    }
    emit allowedOrientationsChanged();
}

MDeclarativeScreen::Orientations MDeclarativeScreen::allowedOrientations() const {
    return d->allowedOrientations;
}

QString MDeclarativeScreen::orientationString() const
{
    const char *s = nullptr; // Use nullptr
    switch (d->orientation) {
    case Portrait:
        s = "Portrait";
        break;
    case PortraitInverted:
        s = "PortraitInverted";
        break;
    case Landscape:
        s = "Landscape";
        break;
    case LandscapeInverted:
        s = "LandscapeInverted";
        break;
    default:
        qCritical() << "MDeclarativeScreen has invalid orientation set.";
        s = "Unknown"; // Default for safety
        break;
    }
    return QString::fromLatin1(s);
}

int MDeclarativeScreen::rotation() const
{
    return d->rotation();
}

MDeclarativeScreen::Direction MDeclarativeScreen::rotationDirection() const
{
    return d->rotationDirection;
}

bool MDeclarativeScreen::isCovered() const
{
    return d->isCovered; // Placeholder
}

bool MDeclarativeScreen::isKeyboardOpen() const
{
    return d->keyboardOpen; // Placeholder
}

bool MDeclarativeScreen::isMinimized() const
{
    // Call the private implementation's isMinimized method
    return d->isMinimized();
}

void MDeclarativeScreen::setMinimized(bool minimized)
{
    // Call the private implementation's setMinimized method
    if(minimized == d->minimized)
        return;

    if (!d->window.isNull()) {
        d->window.data()->setWindowState(minimized ? Qt::WindowMinimized : Qt::WindowMaximized);
        d->setMinimized(minimized); // Update private state
    } else {
        qWarning() << "No main QQuickWindow set to minimize/maximize.";
    }
}

int MDeclarativeScreen::width() const
{
#ifdef USE_DEPRECATED_SCREEN_WIDTH_HEIGHT
    qWarning() << "The semantics of screen.width property is deprecated, see QTCOMPONENTS-521. Please use screen.displayWidth to query native screen width.";
    return d->displaySize.width();
#else
    return d->screenSize.width();
#endif
}

int MDeclarativeScreen::height() const
{
#ifdef USE_DEPRECATED_SCREEN_WIDTH_HEIGHT
    qWarning() << "The semantics of screen.height property is deprecated, see QTCOMPONENTS-521. Please use screen.displayHeight to query native screen height.";
    return d->displaySize.height();
#else
    return d->screenSize.height();
#endif
}

int MDeclarativeScreen::platformWidth() const
{
    return d->screenSize.width();
}

int MDeclarativeScreen::platformHeight() const
{
    return d->screenSize.height();
}

int MDeclarativeScreen::displayWidth() const
{
    return d->displaySize.width();
}

int MDeclarativeScreen::displayHeight() const
{
    return d->displaySize.height();
}

MWindowState * MDeclarativeScreen::windowState() const
{
    qWarning() << "Warning: screen.windowState() is deprecated, use platformWindow property instead (if available).";
    return MWindowState::instance();
}

qreal MDeclarativeScreen::dpi() const {
    return d->dpi();
}

MDeclarativeScreen::DisplayCategory MDeclarativeScreen::displayCategory() const {
    QScreen *screen = QGuiApplication::primaryScreen();
    if (!screen) return Normal; // Default if no screen

    const int w = screen->size().width();
    const int h = screen->size().height();
    const qreal diagonal = qSqrt(static_cast<qreal>(w * w + h * h)) / dpi();
    if (diagonal < CATEGORY_SMALL_LIMIT)
        return Small;
    else if (diagonal < CATEGORY_MEDIUM_LIMIT)
        return Normal;
    else if (diagonal < CATEGORY_LARGE_LIMIT)
        return Large;
    else
        return ExtraLarge;
}

MDeclarativeScreen::Density MDeclarativeScreen::density() const {
    qreal currentDpi = dpi();
    if (currentDpi < DENSITY_SMALL_LIMIT)
        return Low;
    else if (currentDpi < DENSITY_MEDIUM_LIMIT)
        return Medium;
    else if (currentDpi < DENSITY_LARGE_LIMIT)
        return High;
    else
        return ExtraHigh;
}

void MDeclarativeScreen::updatePlatformStatusBarRect(QQuickItem * statusBar)
{
    Q_UNUSED(statusBar);
    qDebug() << "updatePlatformStatusBarRect is a no-op for Qt6 Android.";
}

bool MDeclarativeScreen::allowSwipe() const
{
    // Call the private implementation's allowSwipe method
    return d->allowSwipe;
}

bool MDeclarativeScreen::isPortrait() const
{
    return platformHeight() > platformWidth();
}

bool MDeclarativeScreen::isDisplayLandscape() const {
    return platformPhysicalDisplayOrientation() & Landscape;
}

int MDeclarativeScreen::frameBufferRotation() const
{
    return d->frameBufferRotation;
}

void MDeclarativeScreen::setAllowSwipe(bool enabled)
{
    // Call the private implementation's setAllowSwipe method
    if (enabled != d->allowSwipe) {
        d->allowSwipe = enabled;
        emit allowSwipeChanged();
        qDebug() << "setAllowSwipe is a no-op for system-level swipe on Qt6 Android.";
    }
}

// Implementation of the new private slot
void MDeclarativeScreen::_q_onWindowStateAnimatingChanged()
{
    d->updateWindowStateAnimation(); // Call the private implementation method
}
