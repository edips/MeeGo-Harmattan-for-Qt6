#include "mScrollDecoratorSizer.h"

MScrollDecoratorSizer::MScrollDecoratorSizer(QQuickItem *parent)
    : QQuickItem(parent)
{
    // All member variables are initialized inline in the header now
}

MScrollDecoratorSizer::~MScrollDecoratorSizer() = default;

qreal MScrollDecoratorSizer::positionRatio() const {
    return m_positionRatio;
}

void MScrollDecoratorSizer::setPositionRatio(qreal val) {
    if (!qFuzzyCompare(val, m_positionRatio)) {
        m_positionRatio = val;
        emit positionRatioChanged();
        recompute();
    }
}

qreal MScrollDecoratorSizer::sizeRatio() const {
    return m_sizeRatio;
}

void MScrollDecoratorSizer::setSizeRatio(qreal val) {
    if (!qFuzzyCompare(val, m_sizeRatio)) {
        m_sizeRatio = val;
        emit sizeRatioChanged();
        recompute();
    }
}

qreal MScrollDecoratorSizer::maxPosition() const {
    return m_maxPosition;
}

void MScrollDecoratorSizer::setMaxPosition(qreal val) {
    if (!qFuzzyCompare(val, m_maxPosition)) {
        m_maxPosition = val;
        emit maxPositionChanged();
        recompute();
    }
}

qreal MScrollDecoratorSizer::minSize() const {
    return m_minSize;
}

void MScrollDecoratorSizer::setMinSize(qreal val) {
    if (!qFuzzyCompare(val, m_minSize)) {
        m_minSize = val;
        emit minSizeChanged();
        recompute();
    }
}

int MScrollDecoratorSizer::position() const {
    return m_position;
}

int MScrollDecoratorSizer::size() const {
    return m_size;
}

void MScrollDecoratorSizer::recompute() {
    // Calculate potential underflow in size
    qreal sizeUnderflow = (m_sizeRatio * m_maxPosition) < m_minSize
                              ? m_minSize - (m_sizeRatio * m_maxPosition)
                              : 0.0;

    // Raw positions
    qreal rawStartPos = m_positionRatio * (m_maxPosition - sizeUnderflow);
    qreal rawEndPos = (m_positionRatio + m_sizeRatio) * (m_maxPosition - sizeUnderflow) + sizeUnderflow;

    // Overshoot correction
    qreal overshootStart = qMax(0.0, -rawStartPos);
    qreal overshootEnd = qMax(0.0, rawEndPos - m_maxPosition);

    qreal adjStartPos = rawStartPos + overshootStart;
    qreal adjEndPos = rawEndPos - overshootStart - overshootEnd;

    int newPos = static_cast<int>(0.5 + (adjStartPos + m_minSize > m_maxPosition
                                             ? m_maxPosition - m_minSize
                                             : adjStartPos));
    int newSize = static_cast<int>(0.5 + ((adjEndPos - newPos) < m_minSize
                                              ? m_minSize
                                              : (adjEndPos - newPos)));

    if (newPos != m_position) {
        m_position = newPos;
        emit positionChanged();
    }

    if (newSize != m_size) {
        m_size = newSize;
        emit sizeChanged();
    }
}
