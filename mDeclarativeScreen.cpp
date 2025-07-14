#include "mDeclarativeScreen.h"

#include <QScreen>
#include <QQuickItem>
#include <QDebug>
#include <QGuiApplication>

class MDeclarativeScreenPrivate {
public:
    MDeclarativeScreenPrivate(MDeclarativeScreen *qq)
        : q(qq),
        orientation(MDeclarativeScreen::Portrait),
        allowedOrientations(MDeclarativeScreen::All),
        rotationDirection(MDeclarativeScreen::NoDirection),
        isCovered(false),
        keyboardOpen(false),
        minimized(false),
        allowSwipe(true)
    {
        displaySize = QGuiApplication::primaryScreen()->size();
        updateScreenSize();
        initOrientation();
    }

    void initOrientation() {
        if (displaySize.height() > displaySize.width()) {
            physicalDisplayOrientation = MDeclarativeScreen::Portrait | MDeclarativeScreen::PortraitInverted;
        } else {
            physicalDisplayOrientation = MDeclarativeScreen::Landscape | MDeclarativeScreen::LandscapeInverted;
        }
    }

    void updateScreenSize() {
        if (orientation & physicalDisplayOrientation) {
            screenSize = displaySize;
        } else {
            screenSize.setWidth(displaySize.height());
            screenSize.setHeight(displaySize.width());
        }
        emit q->platformWidthChanged();
        emit q->platformHeightChanged();
    }

    MDeclarativeScreen *q;
    MDeclarativeScreen::Orientation orientation;
    MDeclarativeScreen::Orientations allowedOrientations;
    MDeclarativeScreen::Direction rotationDirection;

    bool isCovered;
    bool keyboardOpen;
    bool minimized;
    bool allowSwipe;

    QSize displaySize;
    QSize screenSize;
    MDeclarativeScreen::Orientations physicalDisplayOrientation;
};

MDeclarativeScreen *MDeclarativeScreen::instance() {
    static MDeclarativeScreen s;
    return &s;
}

MDeclarativeScreen::MDeclarativeScreen(QObject *parent)
    : QObject(parent), d(new MDeclarativeScreenPrivate(this))
{
    emit physicalDisplayChanged();
}

MDeclarativeScreen::~MDeclarativeScreen() {
    delete d;
}

void MDeclarativeScreen::setAllowedOrientations(Orientations orientation) {
    if (d->allowedOrientations == orientation)
        return;

    d->allowedOrientations = orientation;
    emit allowedOrientationsChanged();
}

MDeclarativeScreen::Orientations MDeclarativeScreen::allowedOrientations() const {
    return d->allowedOrientations;
}

MDeclarativeScreen::Orientation MDeclarativeScreen::currentOrientation() const {
    return d->orientation;
}

QString MDeclarativeScreen::orientationString() const {
    switch (d->orientation) {
    case Portrait: return "Portrait";
    case PortraitInverted: return "PortraitInverted";
    case Landscape: return "Landscape";
    case LandscapeInverted: return "LandscapeInverted";
    default: return "Unknown";
    }
}

int MDeclarativeScreen::rotation() const {
    switch (d->orientation) {
    case Portrait: return 0;
    case Landscape: return 90;
    case PortraitInverted: return 180;
    case LandscapeInverted: return 270;
    default: return 0;
    }
}

MDeclarativeScreen::Direction MDeclarativeScreen::rotationDirection() const {
    return d->rotationDirection;
}

bool MDeclarativeScreen::isCovered() const {
    return d->isCovered;
}

bool MDeclarativeScreen::isKeyboardOpen() const {
    return d->keyboardOpen;
}

bool MDeclarativeScreen::isMinimized() const {
    return d->minimized;
}

void MDeclarativeScreen::setMinimized(bool m) {
    if (m == d->minimized)
        return;

    d->minimized = m;
    emit minimizedChanged();
}

int MDeclarativeScreen::width() const {
    return d->screenSize.width();
}

int MDeclarativeScreen::height() const {
    return d->screenSize.height();
}

int MDeclarativeScreen::platformWidth() const {
    return d->screenSize.width();
}

int MDeclarativeScreen::platformHeight() const {
    return d->screenSize.height();
}

int MDeclarativeScreen::displayWidth() const {
    return d->displaySize.width();
}

int MDeclarativeScreen::displayHeight() const {
    return d->displaySize.height();
}

bool MDeclarativeScreen::allowSwipe() const {
    return d->allowSwipe;
}

void MDeclarativeScreen::setAllowSwipe(bool enabled) {
    if (enabled != d->allowSwipe) {
        d->allowSwipe = enabled;
        emit allowSwipeChanged();
    }
}

bool MDeclarativeScreen::isPortrait() const {
    return platformHeight() > platformWidth();
}

bool MDeclarativeScreen::isDisplayLandscape() const {
    return d->physicalDisplayOrientation & Landscape;
}

int MDeclarativeScreen::frameBufferRotation() const {
    return 0; // Dummy; implement if needed
}

qreal MDeclarativeScreen::dpi() const {
    return QGuiApplication::primaryScreen()->logicalDotsPerInch();
}

MDeclarativeScreen::DisplayCategory MDeclarativeScreen::displayCategory() const {
    const int w = d->displaySize.width();
    const int h = d->displaySize.height();
    const qreal diagInches = std::sqrt(w * w + h * h) / dpi();

    if (diagInches < 3.2) return Small;
    else if (diagInches < 4.5) return Normal;
    else if (diagInches < 7.0) return Large;
    else return ExtraLarge;
}

MDeclarativeScreen::Density MDeclarativeScreen::density() const {
    const qreal dpiVal = dpi();
    if (dpiVal < 140) return Low;
    else if (dpiVal < 180) return Medium;
    else if (dpiVal < 270) return High;
    else return ExtraHigh;
}

void MDeclarativeScreen::updatePlatformStatusBarRect(QQuickItem *statusBar) {
    Q_UNUSED(statusBar);
    // Stubbed out for Qt6 - not needed unless you use X11 hints
}

