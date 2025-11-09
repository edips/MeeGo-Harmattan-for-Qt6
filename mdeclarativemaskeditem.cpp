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
#include "mdeclarativemaskeditem.h"
#include <QPainter>
#include <QQuickImageProvider>
#include <QQuickItemGrabResult>
#include <QDebug>

MDeclarativeMaskedItem::MDeclarativeMaskedItem(QQuickItem *parent)
    : QQuickPaintedItem(parent)
{
    setClip(true);
}

QQuickItem* MDeclarativeMaskedItem::mask() const
{
    return m_mask;
}

void MDeclarativeMaskedItem::setMask(QQuickItem* item)
{
    if (m_mask == item)
        return;

    m_mask = item;
    emit maskChanged();
    update();
}

void MDeclarativeMaskedItem::paint(QPainter *painter)
{
    if (!m_mask) {
        return;
    }

    painter->setRenderHint(QPainter::Antialiasing, true);

    QPainterPath path;
    if (m_mask->inherits("QQuickBorderImage")) {
        qreal w = m_mask->width();
        qreal h = m_mask->height();

        path.addRect(0, 0, w, h);
    } else {
        path.addRect(m_mask->x(), m_mask->y(), m_mask->width(), m_mask->height());
    }

    painter->setClipPath(path);
}
