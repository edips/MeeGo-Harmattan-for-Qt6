#ifndef MDECLARATIVESCREEN_H
#define MDECLARATIVESCREEN_H

#include <QObject>
#include <QQuickItem>
#include <QScreen>
#include <QPointer>
#include <QSize>
#include <QWindow>
#include <QGuiApplication>
#include <cmath>

// Dummy placeholder for MWindowState
class MWindowState : public QObject {
    Q_OBJECT
public:
    static MWindowState* instance() {
        static MWindowState s;
        return &s;
    }
    bool animating() const { return false; }  // Dummy implementation
signals:
    void animatingChanged();
};

// Dummy placeholder for MDeclarativeInputContext
class MDeclarativeInputContext {
public:
    static void setKeyboardOrientation(int /*orientation*/) {} // Dummy stub
};

class MDeclarativeScreen : public QObject
{
    Q_OBJECT
public:
    enum Orientation {
        Default = 0,
        Portrait = 1,
        Landscape = 2,
        PortraitInverted = 4,
        LandscapeInverted = 8,
        All = 15
    };
    Q_DECLARE_FLAGS(Orientations, Orientation)
    Q_FLAG(Orientations)

    enum Direction {
        Clockwise = -1,
        NoDirection = 0,
        CounterClockwise = 1
    };
    Q_ENUM(Direction)

    enum DisplayCategory {
        Small,
        Normal,
        Large,
        ExtraLarge
    };
    Q_ENUM(DisplayCategory)

    enum Density {
        Low,
        Medium,
        High,
        ExtraHigh
    };
    Q_ENUM(Density)

    Q_PROPERTY(Orientation currentOrientation READ currentOrientation NOTIFY currentOrientationChanged FINAL)
    Q_PROPERTY(Orientations allowedOrientations READ allowedOrientations WRITE setAllowedOrientations NOTIFY allowedOrientationsChanged FINAL)
    Q_PROPERTY(QString orientationString READ orientationString NOTIFY currentOrientationChanged FINAL)

    Q_PROPERTY(bool covered READ isCovered NOTIFY coveredChanged FINAL)
    Q_PROPERTY(bool keyboardOpen READ isKeyboardOpen NOTIFY keyboardOpenChanged FINAL)
    Q_PROPERTY(int width READ width NOTIFY widthChanged FINAL)
    Q_PROPERTY(int height READ height NOTIFY heightChanged FINAL)
    Q_PROPERTY(int displayWidth READ displayWidth NOTIFY displayChanged FINAL)
    Q_PROPERTY(int displayHeight READ displayHeight NOTIFY displayChanged FINAL)
    Q_PROPERTY(int rotation READ rotation NOTIFY currentOrientationChanged FINAL)
    Q_PROPERTY(Direction rotationDirection READ rotationDirection NOTIFY rotationDirectionChanged FINAL)
    Q_PROPERTY(bool minimized READ isMinimized WRITE setMinimized NOTIFY minimizedChanged FINAL)
    Q_PROPERTY(bool allowSwipe READ allowSwipe WRITE setAllowSwipe NOTIFY allowSwipeChanged FINAL)
    Q_PROPERTY(bool isPortrait READ isPortrait NOTIFY currentOrientationChanged FINAL)
    Q_PROPERTY(qreal dpi READ dpi NOTIFY displayChanged FINAL)
    Q_PROPERTY(DisplayCategory displayCategory READ displayCategory NOTIFY displayChanged FINAL)
    Q_PROPERTY(Density density READ density NOTIFY displayChanged FINAL)
    Q_PROPERTY(int platformWidth READ platformWidth NOTIFY platformWidthChanged FINAL)
    Q_PROPERTY(int platformHeight READ platformHeight NOTIFY platformHeightChanged FINAL)
    Q_PROPERTY(bool isDisplayLandscape READ isDisplayLandscape NOTIFY physicalDisplayChanged FINAL)
    Q_PROPERTY(int frameBufferRotation READ frameBufferRotation CONSTANT FINAL)

    static MDeclarativeScreen* instance();
    ~MDeclarativeScreen();

    Q_INVOKABLE void updatePlatformStatusBarRect(QQuickItem *statusBar);

    Orientation currentOrientation() const;
    Orientations allowedOrientations() const;
    QString orientationString() const;

    int rotation() const;
    Direction rotationDirection() const;
    bool isCovered() const;
    bool isKeyboardOpen() const;
    bool isMinimized() const;
    void setMinimized(bool minimized);

    int width() const;
    int height() const;
    int displayWidth() const;
    int displayHeight() const;
    int platformWidth() const;
    int platformHeight() const;

    bool allowSwipe() const;
    void setAllowSwipe(bool enabled);
    bool isPortrait() const;
    bool isDisplayLandscape() const;
    int frameBufferRotation() const;

    qreal dpi() const;
    DisplayCategory displayCategory() const;
    Density density() const;

    MWindowState* windowState() const { return MWindowState::instance(); }

signals:
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

public slots:
    void setAllowedOrientations(Orientations orientation);

private:
    explicit MDeclarativeScreen(QObject *parent = nullptr);
    Q_DISABLE_COPY(MDeclarativeScreen)

    friend class MDeclarativeScreenPrivate;
    class MDeclarativeScreenPrivate *d;
};

Q_DECLARE_OPERATORS_FOR_FLAGS(MDeclarativeScreen::Orientations)

#endif // MDECLARATIVESCREEN_H
