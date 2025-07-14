// mDeclarativeImObserver.cpp - Qt 6.6 Compatible Version
#include "mDeclarativeImObserver.h"

#include <QGuiApplication>
#include <QInputMethod>
#include <QInputMethodEvent>

MDeclarativeIMObserver::MDeclarativeIMObserver(QQuickItem *parent)
    : QQuickItem(parent)
{
    setFlag(ItemHasContents, false); // No visual content
    setFlag(ItemAcceptsInputMethod, true); // Accept IM events
}

void MDeclarativeIMObserver::componentComplete()
{
    QQuickItem::componentComplete();
    // No need to manually set input item in Qt 6
}

bool MDeclarativeIMObserver::event(QEvent *event)
{
    if (event->type() == QEvent::InputMethod) {
        auto *ime = static_cast<QInputMethodEvent *>(event);

        if (m_preedit != ime->preeditString()) {
            m_preedit = ime->preeditString();
            emit preeditChanged();
        }

        int newCursor = ime->replacementStart();
        if (m_preeditCursorPosition != newCursor) {
            m_preeditCursorPosition = newCursor;
            emit preeditCursorPositionChanged();
        }

        return true;
    }

    return QQuickItem::event(event);
}
