// mDeclarativeMouseFilter.cpp - Qt 6.6 Compatible Version
#include "mDeclarativeMouseFilter.h"

#include <QEvent>
#include <QTimerEvent>
#include <QDebug>
#include <QCoreApplication>
#include <algorithm>

static const int PressAndHoldDelay = 800;
static const int FlickThresholdSquare = 900;

MDeclarativeMouseFilter::MDeclarativeMouseFilter(QQuickItem *parent)
    : QQuickItem(parent),
    pressAndHoldTimerId(-1),
    lastPos(0, 0)
{
    setFlag(ItemHasContents, false);
    setAcceptedMouseButtons(Qt::LeftButton);
}

MDeclarativeMouseFilter::~MDeclarativeMouseFilter() = default;

void MDeclarativeMouseFilter::itemChange(ItemChange change, const ItemChangeData &)
{
    if (change == ItemParentHasChanged || change == ItemSceneChange) {
        if (parentItem()) {
            parentItem()->setFiltersChildMouseEvents(true);
        }
    }
}

bool MDeclarativeMouseFilter::event(QEvent *event)
{
    switch (event->type()) {
    case QEvent::MouseButtonDblClick: {
        auto *me = static_cast<QMouseEvent *>(event);
        clampMousePosition(me);
        QPointF mappedPos = mapFromScene(me->scenePosition());
        auto *mdme = new MDeclarativeMouseEvent(mappedPos);
        emit doubleClicked(mdme);
        bool filtered = mdme->isFiltered();
        delete mdme;
        return filtered;
    }
    case QEvent::MouseButtonPress: {
        auto *me = static_cast<QMouseEvent *>(event);
        clampMousePosition(me);
        QPointF mappedPos = mapFromScene(me->scenePosition());
        lastPos = mappedPos.toPoint();
        pressAndHoldTimerId = startTimer(PressAndHoldDelay);
        auto *mdme = new MDeclarativeMouseEvent(mappedPos);
        emit pressed(mdme);
        bool filtered = mdme->isFiltered();
        delete mdme;
        if (filtered) {
            event->accept();
            return true;
        }
        break;
    }
    case QEvent::MouseMove: {
        auto *me = static_cast<QMouseEvent *>(event);
        QPointF dist = me->position() - QPointF(lastPos);
        clampMousePosition(me);
        QPointF mappedPos = mapFromScene(me->scenePosition());
        lastPos = mappedPos.toPoint();
        auto *mdme = new MDeclarativeMouseEvent(mappedPos);

        if (pressAndHoldTimerId != -1 && dist.manhattanLength() * dist.manhattanLength() > FlickThresholdSquare) {
            killTimer(pressAndHoldTimerId);
            pressAndHoldTimerId = -1;
            if (std::abs(dist.x()) < std::abs(dist.y())) {
                emit delayedPressSent();
            } else {
                emit horizontalDrag();
            }
        } else if (pressAndHoldTimerId == -1) {
            emit mousePositionChanged(mdme);
            if (mdme->isFiltered()) {
                delete mdme;
                return true;
            }
        }

        if (pressAndHoldTimerId != -1) {
            delete mdme;
            return true;
        }
        delete mdme;
        break;
    }
    case QEvent::MouseButtonRelease: {
        if (pressAndHoldTimerId != -1) {
            killTimer(pressAndHoldTimerId);
            pressAndHoldTimerId = -1;
        }
        auto *me = static_cast<QMouseEvent *>(event);
        clampMousePosition(me);
        QPointF mappedPos = mapFromScene(me->scenePosition());
        auto *mdme = new MDeclarativeMouseEvent(mappedPos);
        emit released(mdme);
        bool filtered = mdme->isFiltered();
        delete mdme;
        emit finished();
        if (filtered) return true;
        return QQuickItem::event(event);
    }
    case QEvent::UngrabMouse: {
        if (pressAndHoldTimerId != -1) {
            killTimer(pressAndHoldTimerId);
            pressAndHoldTimerId = -1;
        }
        break;
    }
    default:
        break;
    }
    return QQuickItem::event(event);
}

void MDeclarativeMouseFilter::timerEvent(QTimerEvent *event)
{
    if (event->timerId() == pressAndHoldTimerId) {
        killTimer(pressAndHoldTimerId);
        pressAndHoldTimerId = -1;
        auto *mdme = new MDeclarativeMouseEvent(lastPos);
        emit pressAndHold(mdme);
        delete mdme;
    }
}

void MDeclarativeMouseFilter::clampMousePosition(QMouseEvent *me)
{
    QRectF targetRect(0, -y(), width(), parentItem() ? parentItem()->height() : height());
    QPointF pos = me->position();
    pos.setX(std::clamp(pos.x(), targetRect.left(), targetRect.right()));
    pos.setY(std::clamp(pos.y(), targetRect.top(), targetRect.bottom() - 1));
    lastPos = pos.toPoint();
}
