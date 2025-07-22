#ifndef MDECLARATIVEINPUTCONTEXT_H
#define MDECLARATIVEINPUTCONTEXT_H

#include <QObject> // Base class for Q_OBJECT
#include <QQuickItem> // For QQuickItem* properties
#include <QRectF> // For microFocus() return type
#include <QQmlComponent> // For customSoftwareInputPanelComponent
#include <QVariant> // For sipEvent

class MDeclarativeInputContextPrivate; // Forward declaration for PIMPL

class MDeclarativeInputContext : public QObject
{
    Q_OBJECT // Required for signals, slots, and properties

public:
    // Constructor and Destructor
    explicit MDeclarativeInputContext(QQuickItem *parent = nullptr); // Use nullptr for modern C++
    virtual ~MDeclarativeInputContext();

    // Q_PROPERTY declarations (updated for Qt 6 syntax)
    Q_PROPERTY(bool softwareInputPanelVisible READ softwareInputPanelVisible NOTIFY softwareInputPanelVisibleChanged FINAL)
    Q_PROPERTY(QRect softwareInputPanelRect READ softwareInputPanelRect NOTIFY softwareInputPanelRectChanged FINAL)
    // microFocus is still useful for text input, keep it for now.
    Q_PROPERTY(QRectF microFocus READ microFocus NOTIFY microFocusChanged FINAL)
    Q_PROPERTY(QVariant softwareInputPanelEvent READ softwareInputPanelEvent WRITE setSoftwareInputPanelEvent NOTIFY softwareInputPanelEventChanged FINAL)
    Q_PROPERTY(QQmlComponent* customSoftwareInputPanelComponent READ customSoftwareInputPanelComponent WRITE setCustomSoftwareInputPanelComponent NOTIFY customSoftwareInputPanelComponentChanged FINAL)
    Q_PROPERTY(QQuickItem* customSoftwareInputPanelTextField READ customSoftwareInputPanelTextField WRITE setCustomSoftwareInputPanelTextField NOTIFY customSoftwareInputPanelTextFieldChanged FINAL)
    Q_PROPERTY(bool customSoftwareInputPanelVisible READ customSoftwareInputPanelVisible WRITE setCustomSoftwareInputPanelVisible NOTIFY customSoftwareInputPanelVisibleChanged FINAL)

    // Public methods (READ functions for properties)
    QRectF microFocus() const;
    bool softwareInputPanelVisible() const;
    QRect softwareInputPanelRect() const;
    QVariant softwareInputPanelEvent() const;
    QQmlComponent *customSoftwareInputPanelComponent() const;
    bool customSoftwareInputPanelVisible() const;
    QQuickItem *customSoftwareInputPanelTextField() const;

    // Public methods (WRITE functions for properties)
    void setSoftwareInputPanelEvent(const QVariant& event);
    void setCustomSoftwareInputPanelComponent(QQmlComponent *component);
    void setCustomSoftwareInputPanelVisible(bool visible);
    void setCustomSoftwareInputPanelTextField(QQuickItem *item);

    // Q_INVOKABLE methods (callable from QML)
    Q_INVOKABLE void updateMicroFocus();
    Q_INVOKABLE void reset();
    Q_INVOKABLE void update();
    Q_INVOKABLE bool setPreeditText(const QString &newPreedit, int eventCursorPosition, int replacementStart, int replacementLength);
    Q_INVOKABLE QQuickItem * targetInputFor(QQmlComponent *customSoftwareInputPanelComponent); // Unlikely to be used in Qt6
    Q_INVOKABLE void simulateSipOpen(); // Custom simulation, keep
    Q_INVOKABLE void simulateSipClose(); // Custom simulation, keep
    Q_INVOKABLE void clearClipboard();

Q_SIGNALS:
    // Signals (updated for Qt 6 syntax - no FINAL keyword here)
    void softwareInputPanelVisibleChanged();
    void softwareInputPanelRectChanged();
    void microFocusChanged();
    void softwareInputPanelEventChanged();
    void customSoftwareInputPanelComponentChanged();
    void customSoftwareInputPanelVisibleChanged();
    void customSoftwareInputPanelTextFieldChanged();

private:
    Q_DISABLE_COPY(MDeclarativeInputContext) // Disables copy constructor and assignment operator

    // PIMPL idiom to hide private implementation details
    MDeclarativeInputContextPrivate *d;

    // --- CHANGE START ---
private Q_SLOTS: // New private slot to act as a bridge
    void _q_onKeyboardRectangleChanged();
    // --- CHANGE END ---
};

#endif // MDECLARATIVEINPUTCONTEXT_H
