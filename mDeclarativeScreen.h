#ifndef MDECLARATIVESCREEN_H
#define MDECLARATIVESCREEN_H

#include <QObject> // Base class
#include <qglobal.h> // For qreal, Q_DECL_OVERRIDE etc.
#include <QPointer> // For QPointer
#include <QVector3D> // If still used for something, otherwise remove
#include <QQuickItem> // For QQuickItem*
#include <QQuickWindow> // Include full definition for QQuickWindow

#define MEEGOTOUCH_DOUBLETAP_INTERVAL 325 // Still a constant

class MDeclarativeScreenPrivate; // Forward declaration

// --- CHANGE START ---
#include "mWindowState.h" // Include full definition for MWindowState
// --- CHANGE END ---

class MDeclarativeScreen : public QObject
{
    Q_OBJECT // Required for signals, slots, and properties

public:
    // Enums (using Q_ENUM for Qt 6)
    enum Orientation {
        Default = 0,
        Portrait = 1,
        Landscape = 2,
        PortraitInverted = 4,
        LandscapeInverted = 8,
        All = 15
    };
    Q_ENUM(Orientation) // Register Orientation enum for QML

    enum Direction {
        Clockwise = -1,
        NoDirection = 0,
        CounterClockwise = 1
    };
    Q_ENUM(Direction) // Register Direction enum for QML

// OrientationAngle enum (platform-specific, adjust if needed for ARM/Android)
#ifdef Q_OS_ANDROID // Using Q_OS_ANDROID instead of __arm__ for better cross-compilation
    enum OrientationAngle {
        PortraitAngle = 270, // Assuming Android's default portrait is 270deg from landscape
        LandscapeAngle = 0,
        PortraitInvertedAngle = 90,
        LandscapeInvertedAngle = 180
    };
#else
    enum OrientationAngle {
        PortraitAngle = 0,
        LandscapeAngle = 90,
        PortraitInvertedAngle = 180,
        LandscapeInvertedAngle = 270
    };
#endif
    Q_ENUM(OrientationAngle) // Register OrientationAngle enum for QML

    enum DisplayCategory {
        Small,
        Normal,
        Large,
        ExtraLarge
    };
    Q_ENUM(DisplayCategory) // Register DisplayCategory enum for QML

    enum Density {
        Low,
        Medium,
        High,
        ExtraHigh
    };
    Q_ENUM(Density) // Register Density enum for QML

    Q_DECLARE_FLAGS(Orientations, Orientation) // Q_FLAGS is still used

    // Q_PROPERTY declarations (updated for Qt 6 syntax)
    Q_PROPERTY(Orientation currentOrientation READ currentOrientation NOTIFY currentOrientationChanged FINAL)
    Q_PROPERTY(Orientations allowedOrientations READ allowedOrientations WRITE setAllowedOrientations NOTIFY allowedOrientationsChanged FINAL)
    Q_PROPERTY(QString orientationString READ orientationString NOTIFY currentOrientationChanged FINAL)
    Q_PROPERTY(bool covered READ isCovered NOTIFY coveredChanged FINAL) // Likely deprecated/unimplemented for Android
    Q_PROPERTY(bool keyboardOpen READ isKeyboardOpen NOTIFY keyboardOpenChanged FINAL) // Likely tied to old SIP, review implementation

    Q_PROPERTY(int width READ width NOTIFY widthChanged FINAL) // Deprecated, use platformWidth/Height
    Q_PROPERTY(int height READ height NOTIFY heightChanged FINAL) // Deprecated, use platformWidth/Height
    Q_PROPERTY(int displayWidth READ displayWidth NOTIFY displayChanged FINAL)
    Q_PROPERTY(int displayHeight READ displayHeight NOTIFY displayChanged FINAL)

    Q_PROPERTY(int rotation READ rotation NOTIFY currentOrientationChanged FINAL)
    Q_PROPERTY(Direction rotationDirection READ rotationDirection NOTIFY rotationDirectionChanged FINAL)
    Q_PROPERTY(bool minimized READ isMinimized WRITE setMinimized NOTIFY minimizedChanged FINAL) // Relies on MWindowState
    Q_PROPERTY(bool allowSwipe READ allowSwipe WRITE setAllowSwipe NOTIFY allowSwipeChanged FINAL )
    Q_PROPERTY(bool isPortrait READ isPortrait NOTIFY currentOrientationChanged FINAL )

    Q_PROPERTY(MWindowState * windowState READ windowState CONSTANT FINAL) // Deprecated, use platformWindow

    Q_PROPERTY(qreal dpi READ dpi NOTIFY displayChanged FINAL)
    Q_PROPERTY(DisplayCategory displayCategory READ displayCategory NOTIFY displayChanged FINAL)
    Q_PROPERTY(Density density READ density NOTIFY displayChanged FINAL)

    // Orientation corrected screen resolution. These values change depending on orientation.
    Q_PROPERTY(int platformWidth READ platformWidth NOTIFY platformWidthChanged FINAL)
    Q_PROPERTY(int platformHeight READ platformHeight NOTIFY platformHeightChanged FINAL)

    Q_PROPERTY(bool isDisplayLandscape READ isDisplayLandscape NOTIFY physicalDisplayChanged FINAL)

    Q_PROPERTY(int frameBufferRotation READ frameBufferRotation CONSTANT FINAL) // Framebuffer rotation might be OS-managed

public:
    // Singleton instance access
    static MDeclarativeScreen* instance();
    virtual ~MDeclarativeScreen();

    // Q_INVOKABLE methods
    Q_INVOKABLE void updatePlatformStatusBarRect(QQuickItem * statusBar);

    // Public API READ methods
    Orientation currentOrientation() const;
    Orientations allowedOrientations() const;
    QString orientationString() const;
    int rotation() const;
    Direction rotationDirection() const;
    bool isCovered() const;
    bool isKeyboardOpen() const;
    int width() const;
    int height() const;
    int platformWidth() const;
    int platformHeight() const;
    int displayWidth() const;
    int displayHeight() const;
    bool isMinimized() const;
    bool allowSwipe() const;
    bool isPortrait() const;
    bool isDisplayLandscape() const;
    int frameBufferRotation() const;
    qreal dpi() const;
    DisplayCategory displayCategory() const;
    Density density() const;
    MWindowState * windowState() const; // Deprecated
    Orientations platformPhysicalDisplayOrientation() const;

    // Public API WRITE methods
    void setMinimized(bool minimized);
    void setAllowSwipe(bool enabled);

    // Event filter override
    virtual bool eventFilter(QObject *o, QEvent *e) Q_DECL_OVERRIDE; // Use Q_DECL_OVERRIDE

public Q_SLOTS:
    void setAllowedOrientations(Orientations orientation); // Q_SLOT

Q_SIGNALS:
    // Signals (no FINAL keyword here)
    void currentOrientationChanged();
    void allowedOrientationsChanged();
    void rotationDirectionChanged();
    void coveredChanged();
    void minimizedChanged();
    void keyboardOpenChanged();
    void displayChanged();
    void widthChanged();
    void heightChanged();
    void allowSwipeChanged();
    void isPortraitChanged();
    void platformWidthChanged();
    void platformHeightChanged();
    void physicalDisplayChanged();

private:
    // Private constructor for singleton pattern
    explicit MDeclarativeScreen(QObject *parent = nullptr); // Use nullptr
    Q_DISABLE_COPY(MDeclarativeScreen) // Disables copy constructor and assignment operator

    // PIMPL friend
    friend class MDeclarativeScreenPrivate;
    MDeclarativeScreenPrivate *d; // Pointer to private implementation

    void setOrientation(Orientation o); // Private helper
    Orientation physicalOrientation() const; // Private helper

private Q_SLOTS: // New private slot to act as a bridge for MWindowState signals
    void _q_onWindowStateAnimatingChanged();
};

// QML_DECLARE_TYPE is still used for singleton types registered via C++
QML_DECLARE_TYPE(MDeclarativeScreen)

#endif // MDECLARATIVESCREEN_H
