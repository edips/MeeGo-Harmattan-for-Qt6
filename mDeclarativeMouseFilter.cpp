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

// mDeclarativeMouseFilter.cpp
#include "mDeclarativeMouseFilter.h"

#include <QEvent>
#include <QMouseEvent>
#include <QDebug>
#include <QtMath> // For qAbs and qBound

// Constants for gesture detection
static const int PressAndHoldDelay = 800; // Time in ms for long press
// Threshold for movement before a press-and-hold timer is cancelled or a drag starts
// This is the square of the distance (e.g., 30*30 = 900)
static const int FlickThresholdSquare = 900;

MDeclarativeMouseFilter::MDeclarativeMouseFilter(QQuickItem *parent)
    : QQuickItem(parent),
    pressAndHoldTimerId(-1),
    lastMappedClampedPos(QPointF(0, 0)),
    initialPressMappedClampedPos(QPointF(0, 0)),
    pressPos(QPointF(0, 0)), // Initialize pressPos
    hasDelayedPress(false),
    delayedPressMappedClampedPos(QPointF(0,0))
{
    // Set flag to indicate this item does not have its own visual contents
    setFlag(ItemHasContents, false);
    // Only accept left mouse button events for gesture detection
    setAcceptedMouseButtons(Qt::LeftButton);
}

MDeclarativeMouseFilter::~MDeclarativeMouseFilter()
{
    // Nothing dynamically allocated to clean up here.
    // QMouseEvent objects are not owned by this filter.
}

// Helper function to map a raw mouse position to the parent's coordinates
// and then clamp it to the filter's effective interaction area.
QPointF MDeclarativeMouseFilter::mapAndClampPosition(const QPointF &rawPos)
{
    if (!parentItem()) {
        return rawPos; // Cannot map/clamp without a parent
    }

    // Map the raw mouse position from this item's coordinates to its parent's coordinates
    QPointF mappedPos = parentItem()->mapFromItem(this, rawPos);

    // Define the target rectangle in parent's coordinates where the mouse filter is active.
    // The filter effectively covers the area of the TextInput within its parent.
    // We are essentially mapping our filter's 0,0 (its top-left relative to its parent)
    // and its width/height. The -y() part is important if the filter itself has a Y offset.
    QRectF targetRect(0, -y(), width(), parentItem()->height());

    // Clamp the mapped position to this target rectangle
    qreal clampedX = qBound(targetRect.left(), mappedPos.x(), targetRect.right());
    qreal clampedY = qBound(targetRect.top(), mappedPos.y(), targetRect.bottom() - 1); // -1 to stay within bounds

    return QPointF(clampedX, clampedY);
}

// Called when the item's state changes (e.g., parent changes)
void MDeclarativeMouseFilter::itemChange(ItemChange change, const ItemChangeData &value)
{
    QQuickItem::itemChange(change, value); // Call base implementation

    if (change == QQuickItem::ItemParentHasChanged || change == QQuickItem::ItemSceneChange) {
        if (parentItem()) {
            // This filter handles mouse events for its children (which would be TextInput)
            parentItem()->setFiltersChildMouseEvents(true);
            // Keep the mouse grab to receive all events for the gesture,
            // even if the mouse moves outside the item's visual bounds.
            setKeepMouseGrab(true);
        }
    }
}

// Handler for double-click events
void MDeclarativeMouseFilter::mouseDoubleClickEvent(QMouseEvent *event)
{
    // Map and clamp the event's position for internal use and QML signal
    QPointF mappedClampedPos = mapAndClampPosition(event->position());
    MDeclarativeMouseEvent mdme(mappedClampedPos);

    emit doubleClicked(&mdme); // Emit signal to QML
    if (mdme.isFiltered()) {
        event->accept(); // If QML signals it handled the event, accept it
    } else {
        QQuickItem::mouseDoubleClickEvent(event); // Otherwise, pass to base class
    }
}

// Handler for mouse button press events
void MDeclarativeMouseFilter::mousePressEvent(QMouseEvent *event)
{
    // Store the raw event position
    pressPos = event->position();
    // Map and clamp the event's position
    QPointF mappedClampedPos = mapAndClampPosition(event->position());

    // Store the initial press position (mapped and clamped)
    initialPressMappedClampedPos = mappedClampedPos;
    // Store the last known position
    lastMappedClampedPos = mappedClampedPos;

    // Reset long press timer and delayed press state
    if (pressAndHoldTimerId != -1) {
        killTimer(pressAndHoldTimerId);
    }
    pressAndHoldTimerId = startTimer(PressAndHoldDelay); // Start long press timer

    // Store info for delayed press replay (if a drag cancels long press)
    hasDelayedPress = true;
    delayedPressMappedClampedPos = mappedClampedPos; // Store mapped and clamped position

    MDeclarativeMouseEvent mdme(mappedClampedPos);
    emit pressed(&mdme); // Emit 'pressed' signal to QML

    if (mdme.isFiltered()) {
        event->accept(); // If QML handles it, accept the event
        return;
    }

    QQuickItem::mousePressEvent(event); // Otherwise, pass to base class
}

// Handler for mouse movement events
void MDeclarativeMouseFilter::mouseMoveEvent(QMouseEvent *event)
{
    // Calculate distance from initial RAW press position to current RAW position
    QPointF dist = event->position() - pressPos;

    // Map and clamp the current event position
    QPointF currentMappedClampedPos = mapAndClampPosition(event->position());
    lastMappedClampedPos = currentMappedClampedPos; // Update last known position

    MDeclarativeMouseEvent mdme(currentMappedClampedPos);

    // Check if movement exceeds threshold while waiting for long press
    if (pressAndHoldTimerId != -1 &&
        (dist.x() * dist.x() + dist.y() * dist.y()) > FlickThresholdSquare)
    {
        killTimer(pressAndHoldTimerId); // Movement detected, cancel long press timer
        pressAndHoldTimerId = -1;

        // If a delayed press was active (i.e., this move cancels a potential long press),
        // emit signals to allow QML to re-interpret this as a drag initiation.
        if (hasDelayedPress) {
            // Signal to QML that a delayed press has occurred and movement is now a drag.
            // QML should then use delayedPressMappedClampedPos to start a selection drag.
            emit delayedPressSent();
            // Also emit 'pressed' again with the initial position to signal the start of a drag context.
            MDeclarativeMouseEvent replayMdme(delayedPressMappedClampedPos);
            emit pressed(&replayMdme);
            hasDelayedPress = false; // Consume the delayed press
        }

        // Always emit horizontalDrag if movement is significant, regardless of direction.
        // QML's DragHandler will then filter this by axis.
        emit horizontalDrag(); // Signal potential drag start for QML

        event->accept(); // Filter has processed the gesture initiation
        return;
    }
    else if (pressAndHoldTimerId == -1)
    {
        // If no long press timer is active (i.e., a drag is already underway or a simple move)
        // emit mousePositionChanged to continuously update QML on mouse location.
        emit mousePositionChanged(&mdme);
        if (mdme.isFiltered()) {
            event->accept(); // If QML handled the position change, accept event
            return;
        }
    }

    // If the long press timer is still running (no significant movement yet),
    // we want to swallow the move events so TextInput doesn't interpret them prematurely.
    if (pressAndHoldTimerId != -1) {
        event->accept();
        return;
    }

    QQuickItem::mouseMoveEvent(event); // Pass unhandled events to base class
}

// Handler for mouse button release events
void MDeclarativeMouseFilter::mouseReleaseEvent(QMouseEvent *event)
{
    // If long press timer is active, kill it as button is released
    if (pressAndHoldTimerId != -1) {
        killTimer(pressAndHoldTimerId);
        pressAndHoldTimerId = -1;
    }

    // Map and clamp the event's position
    QPointF mappedClampedPos = mapAndClampPosition(event->position());
    MDeclarativeMouseEvent mdme(mappedClampedPos);

    emit released(&mdme); // Emit 'released' signal to QML

    if (mdme.isFiltered()) {
        emit finished(); // Signal end of gesture handling
        event->accept(); // If QML handled it, accept the event
        return;
    }

    QQuickItem::mouseReleaseEvent(event); // Pass to base class
    emit finished(); // Signal end of gesture handling
}

// Handler for when mouse grab is lost unexpectedly
void MDeclarativeMouseFilter::mouseUngrabEvent()
{
    // If long press timer is active, kill it
    if (pressAndHoldTimerId != -1) {
        killTimer(pressAndHoldTimerId);
        pressAndHoldTimerId = -1;
    }
    // Re-establish mouse grab for future events (if parent has setFiltersChildMouseEvents)
    setKeepMouseGrab(true);
    hasDelayedPress = false; // Reset delayed press flag on ungrab
    QQuickItem::mouseUngrabEvent(); // Call base implementation
}

// Handler for timer events (specifically the press-and-hold timer)
void MDeclarativeMouseFilter::timerEvent(QTimerEvent *ev)
{
    if (ev->timerId() == pressAndHoldTimerId) {
        killTimer(pressAndHoldTimerId); // Timer fired, kill it
        pressAndHoldTimerId = -1; // Reset timer ID

        // Create MDeclarativeMouseEvent using the last known position
        // This is the position where the long press was detected without significant movement.
        MDeclarativeMouseEvent mdme(lastMappedClampedPos);
        emit pressAndHold(&mdme); // Emit 'pressAndHold' signal to QML
    }
}
