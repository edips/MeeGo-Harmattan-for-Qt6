#include "mInverseMouseArea.h"

#include <QQuickWindow>
#include <QMouseEvent>
#include <QEvent>

// Flick threshold squared (e.g. 20*20)
static constexpr int FlickThresholdSquare = 400;

MInverseMouseArea::MInverseMouseArea(QQuickItem *parent)
    : QQuickItem(parent)
{
    setFlag(ItemHasContents, false);
}

MInverseMouseArea::~MInverseMouseArea()
{
    if (window())
        window()->removeEventFilter(this);
}

bool MInverseMouseArea::isEnabled() const
{
    return m_enabled;
}

void MInverseMouseArea::setEnabled(bool enabled)
{
    if (m_enabled != enabled) {
        m_enabled = enabled;
        m_pressed = false;
        emit enabledChangedCustom();
    }
}

void MInverseMouseArea::itemChange(ItemChange change, const ItemChangeData &data)
{
    if (change == ItemSceneChange) {
        if (window())
            window()->removeEventFilter(this);

        m_pressed = false;

        if (QQuickWindow *newWindow = data.window) {
            newWindow->installEventFilter(this);
        }
    }

    QQuickItem::itemChange(change, data);
}

bool MInverseMouseArea::eventFilter(QObject *obj, QEvent *ev)
{
    Q_UNUSED(obj);
    if (!m_enabled || !isVisible())
        return false;

    switch (ev->type()) {
    case QEvent::MouseButtonPress: {
        auto *me = static_cast<QMouseEvent *>(ev);
        const QPointF scenePos = me->scenePosition();
        m_pressPosScene = scenePos;

        const QPointF mappedPos = mapToRootItem(scenePos);

        m_pressed = !contains(mapFromScene(scenePos));

        if (m_pressed)
            emit pressedOutside(mappedPos.x(), mappedPos.y());
        break;
    }

    case QEvent::MouseMove: {
        if (m_pressed) {
            auto *me = static_cast<QMouseEvent *>(ev);
            const QPointF scenePos = me->scenePosition();
            const QPointF delta = scenePos - m_pressPosScene;

            if (delta.x() * delta.x() + delta.y() * delta.y() > FlickThresholdSquare)
                m_pressed = false;
        }
        break;
    }

    case QEvent::MouseButtonRelease: {
        auto *me = static_cast<QMouseEvent *>(ev);
        const QPointF scenePos = me->scenePosition();
        const QPointF mappedPos = mapToRootItem(scenePos);

        if (m_pressed) {
            m_pressed = false;
            emit clickedOutside(mappedPos.x(), mappedPos.y());
        }
        break;
    }

    default:
        break;
    }

    return false;
}

QPointF MInverseMouseArea::mapToRootItem(const QPointF &scenePos)
{
    QQuickItem *rootItem = parentItem();
    while (rootItem && rootItem->parentItem()) {
        if (rootItem->objectName() == QLatin1String("windowContent"))
            break;
        rootItem = rootItem->parentItem();
    }

    return rootItem ? rootItem->mapFromScene(scenePos) : scenePos;
}
