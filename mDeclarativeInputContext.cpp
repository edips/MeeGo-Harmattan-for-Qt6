/****************************************************************************
**
** Originally part of the MeeGo Harmattan Qt Components project
** © 2011 Nokia Corporation and/or its subsidiary(-ies). All rights reserved.
**
** Licensed under the BSD License.
** See the original license text for redistribution and use conditions.
**
** Ported from MeeGo Harmattan (Qt 4.7) to Qt 6 by Edip Ahmet Taskin, 2025.
**
****************************************************************************/
#include <QGuiApplication> // For QGuiApplication::inputMethod() and QGuiApplication::instance()
#include <QInputMethod> // Use QInputMethod for SIP interaction
#include <QClipboard>
#include <QDebug>
#include <QQuickItem> // For QQuickItem*
#include <QQmlComponent> // For QQmlComponent*
#include <QRect> // For QRect
#include <QRectF> // For QRectF
#include <QWindow> // For QWindow and focus object

#include "mDeclarativeInputContext.h"

// Private implementation class (PIMPL)
class MDeclarativeInputContextPrivate
{
public:
    MDeclarativeInputContextPrivate(MDeclarativeInputContext *qq);
    ~MDeclarativeInputContextPrivate();

    // Private helper methods
    void updateKeyboardRectangle(); // Handles logic for keyboard rectangle changes
    void sipChanged(const QRect &rect); // Handles logic for SIP visibility and geometry

    MDeclarativeInputContext *q; // Pointer to the public API class

    bool sipVisible; // Tracks visibility of the software input panel
    QRect sipRect; // Geometry of the software input panel

    // Custom SIP simulation properties (for development/testing purposes)
    bool simulateSip;
    bool customSoftwareInputPanelVisible;
    QRect sipSimulationRect;
    QRect sipDefaultSimulationRect;

    QRectF microFocus; // Cursor rectangle
    QVariant sipEvent; // Custom SIP event data (if any)
    QQmlComponent *sipVkbComponent; // Component for custom virtual keyboard
    QQuickItem *sipVkbTextField; // Text field associated with custom VKB
};

MDeclarativeInputContextPrivate::MDeclarativeInputContextPrivate(MDeclarativeInputContext *qq)
    : q(qq)
    , sipVisible(false)
    , sipRect(QRect())
    , simulateSip(true) // Default to true for simulation, can be configured
    , customSoftwareInputPanelVisible(false)
    // Default simulation rectangle (adjust as needed for typical Android SIP size)
    , sipSimulationRect(QRect(0, 0, 240, 240))
    , sipDefaultSimulationRect(QRect(0, 0, 240, 240))
    , sipVkbComponent(nullptr) // Use nullptr for modern C++
    , sipVkbTextField(nullptr) // Use nullptr for modern C++
{
    // The connection to QInputMethod::keyboardRectangleChanged is now handled in the public class
    // via a private slot, which then calls updateKeyboardRectangle() here.
}

MDeclarativeInputContextPrivate::~MDeclarativeInputContextPrivate()
{
    // No explicit cleanup needed for QObjects with parents or raw pointers handled by Qt
}

// Method to update keyboard rectangle from QInputMethod
void MDeclarativeInputContextPrivate::updateKeyboardRectangle()
{
    // Convert QRectF to QRect if necessary for sipRect
    sipChanged(QGuiApplication::inputMethod()->keyboardRectangle().toRect());
}

// Method to handle SIP visibility and geometry changes
void MDeclarativeInputContextPrivate::sipChanged(const QRect &rect)
{
    bool visible = !rect.isEmpty();

    if (sipRect != rect) {
        sipRect = rect;
        // Emit signal from the public API class
        emit q->softwareInputPanelRectChanged();
    }

    if (visible != sipVisible) {
        sipVisible = visible;
        q->updateMicroFocus(); // Update micro focus when SIP visibility changes
        // Emit signal from the public API class
        emit q->softwareInputPanelVisibleChanged();
    }
}

// Public API implementation
// Static method to get the singleton instance
MDeclarativeInputContext* MDeclarativeInputContext::instance()
{
    static MDeclarativeInputContext* s_instance = nullptr;
    if (!s_instance) {
        // Create the instance with QGuiApplication as its parent.
        // This ensures it's cleaned up automatically when the application exits.
        s_instance = new MDeclarativeInputContext(QGuiApplication::instance());
    }
    return s_instance;
}

// Constructor - now takes QObject* parent
MDeclarativeInputContext::MDeclarativeInputContext(QObject *parent)
    : QObject(parent),
    d(new MDeclarativeInputContextPrivate(this)) // Initialize PIMPL
{
    // Connect to Qt's standard input method signals from the public QObject
    QObject::connect(QGuiApplication::inputMethod(), &QInputMethod::keyboardRectangleChanged,
                     this, &MDeclarativeInputContext::_q_onKeyboardRectangleChanged);
}

MDeclarativeInputContext::~MDeclarativeInputContext()
{
    delete d; // Delete the private implementation object
}

// Implementation of the new private slot
void MDeclarativeInputContext::_q_onKeyboardRectangleChanged()
{
    d->updateKeyboardRectangle(); // Call the private implementation method
}

// Accessor methods for Q_PROPERTY (READ functions)
bool MDeclarativeInputContext::softwareInputPanelVisible() const
{
    return d->sipVisible;
}

QRect MDeclarativeInputContext::softwareInputPanelRect() const
{
    return d->sipRect;
}

QRectF MDeclarativeInputContext::microFocus() const
{
    return d->microFocus;
}

QVariant MDeclarativeInputContext::softwareInputPanelEvent() const
{
    return d->sipEvent;
}

QQmlComponent *MDeclarativeInputContext::customSoftwareInputPanelComponent() const
{
    return d->sipVkbComponent;
}

bool MDeclarativeInputContext::customSoftwareInputPanelVisible() const
{
    return d->customSoftwareInputPanelVisible;
}

QQuickItem *MDeclarativeInputContext::customSoftwareInputPanelTextField() const
{
    return d->sipVkbTextField;
}

// Mutator methods for Q_PROPERTY (WRITE functions)
void MDeclarativeInputContext::setSoftwareInputPanelEvent(const QVariant& event)
{
    if (d->sipEvent != event) { // Check for actual change
        d->sipEvent = event;
        emit softwareInputPanelEventChanged();
    }
}

void MDeclarativeInputContext::setCustomSoftwareInputPanelComponent(QQmlComponent * component)
{
    if(d->sipVkbComponent != component) {
        d->sipVkbComponent = component;
        emit customSoftwareInputPanelComponentChanged();
    }
}

void MDeclarativeInputContext::setCustomSoftwareInputPanelVisible(bool visible)
{
    if(d->customSoftwareInputPanelVisible != visible) {
        d->customSoftwareInputPanelVisible = visible;
        emit customSoftwareInputPanelVisibleChanged();
    }
}

void MDeclarativeInputContext::setCustomSoftwareInputPanelTextField(QQuickItem *item)
{
    if(d->sipVkbTextField != item) {
        d->sipVkbTextField = item; // No need for static_cast if item is QQuickItem*
        emit customSoftwareInputPanelTextFieldChanged();
    }
}


// Implementation of updateMicroFocus()
void MDeclarativeInputContext::updateMicroFocus()
{
    // This function typically updates the input method's knowledge of the cursor position.
    // It's crucial for correct magnifier and selection handle positioning.
    // Qt's QInputMethod::update(Qt::ImQueryInput) is the standard way to do this.
    QGuiApplication::inputMethod()->update(Qt::ImQueryInput);
}

void MDeclarativeInputContext::reset()
{
    QGuiApplication::inputMethod()->reset();
}

void MDeclarativeInputContext::update()
{
    QGuiApplication::inputMethod()->update(Qt::ImQueryAll);
}

QQuickItem *MDeclarativeInputContext::targetInputFor(QQmlComponent *sipVkbComponent)
{
    if(sipVkbComponent)
        return customSoftwareInputPanelTextField();

    return nullptr; // Use nullptr
}

void MDeclarativeInputContext::simulateSipOpen()
{
    if(d->simulateSip) {
        d->sipSimulationRect = d->sipDefaultSimulationRect;
        d->sipChanged(d->sipSimulationRect); // Use private method directly
    }
}

void MDeclarativeInputContext::simulateSipClose()
{
    if(d->simulateSip) {
        d->sipSimulationRect = QRect(); // Empty rect means hidden
        d->sipChanged(d->sipSimulationRect); // Use private method directly
    }
}

bool MDeclarativeInputContext::setPreeditText(const QString &newPreedit, int eventCursorPosition, int replacementStart, int replacementLength)
{
    Q_UNUSED(newPreedit)
    Q_UNUSED(eventCursorPosition)
    Q_UNUSED(replacementStart)
    Q_UNUSED(replacementLength)
    qDebug() << "MDeclarativeInputContext::setPreeditText is not fully implemented for Qt6.";
    return false;
}

void MDeclarativeInputContext::clearClipboard()
{
    if (QGuiApplication::clipboard()) // Use QGuiApplication::clipboard()
        QGuiApplication::clipboard()->clear();
}

// Implementation of the setActiveFocusItem slot - now takes no arguments
void MDeclarativeInputContext::setActiveFocusItem()
{
    // Query the currently focused object from the QGuiApplication
    QObject *focusedObject = QGuiApplication::focusObject();
    QQuickItem *focusedItem = qobject_cast<QQuickItem*>(focusedObject);

    if (focusedItem) {
        qDebug() << "MDeclarativeInputContext: Active focus item changed to:" << focusedItem->objectName();
        // You can now use focusedItem for any logic that depends on the currently active QQuickItem.
        // For example, if you want to store it:
        // d->m_activeFocusItem = focusedItem; // Assuming you add m_activeFocusItem to MDeclarativeInputContextPrivate
    } else {
        qDebug() << "MDeclarativeInputContext: Active focus item changed, but no QQuickItem has focus.";
    }
}
