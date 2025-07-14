// qRangeModel.cpp - Qt 6.6 compatible

#include "qRangeModel.h"
#include "qRangeModel_p.h"

#include <QtCore/qmath.h>

QRangeModelPrivate::QRangeModelPrivate(QRangeModel *qq)
    : q_ptr(qq)
{
    init();
}

QRangeModelPrivate::~QRangeModelPrivate() = default;

void QRangeModelPrivate::init()
{
    minimum = 0;
    maximum = 99;
    stepSize = 0;
    value = 0;
    pos = 0;
    posatmin = 0;
    posatmax = 0;
    inverted = false;
}

qreal QRangeModelPrivate::publicPosition(qreal position) const
{
    const qreal min = effectivePosAtMin();
    const qreal max = effectivePosAtMax();
    const qreal valueRange = maximum - minimum;
    const qreal positionValueRatio = valueRange ? (max - min) / valueRange : 0;
    const qreal positionStep = stepSize * positionValueRatio;

    if (positionStep == 0)
        return (min < max) ? qBound(min, position, max) : qBound(max, position, min);

    const int stepSizeMultiplier = (position - min) / positionStep;
    if (stepSizeMultiplier < 0)
        return min;

    qreal leftEdge = (stepSizeMultiplier * positionStep) + min;
    qreal rightEdge = ((stepSizeMultiplier + 1) * positionStep) + min;

    if (min < max) {
        leftEdge = qMin(leftEdge, max);
        rightEdge = qMin(rightEdge, max);
    } else {
        leftEdge = qMax(leftEdge, max);
        rightEdge = qMax(rightEdge, max);
    }

    return (qAbs(leftEdge - position) <= qAbs(rightEdge - position)) ? leftEdge : rightEdge;
}

qreal QRangeModelPrivate::publicValue(qreal value) const
{
    if (stepSize == 0)
        return qBound(minimum, value, maximum);

    const int stepSizeMultiplier = (value - minimum) / stepSize;
    if (stepSizeMultiplier < 0)
        return minimum;

    const qreal leftEdge = qMin(maximum, (stepSizeMultiplier * stepSize) + minimum);
    const qreal rightEdge = qMin(maximum, ((stepSizeMultiplier + 1) * stepSize) + minimum);
    const qreal middle = (leftEdge + rightEdge) / 2;

    return (value <= middle) ? leftEdge : rightEdge;
}

void QRangeModelPrivate::emitValueAndPositionIfChanged(qreal oldValue, qreal oldPosition)
{
    Q_Q(QRangeModel);
    const qreal newValue = q->value();
    const qreal newPosition = q->position();

    if (!qFuzzyCompare(newValue, oldValue))
        emit q->valueChanged(newValue);
    if (!qFuzzyCompare(newPosition, oldPosition))
        emit q->positionChanged(newPosition);
}

QRangeModel::QRangeModel(QObject *parent)
    : QObject(parent), d_ptr(new QRangeModelPrivate(this))
{}

QRangeModel::QRangeModel(QRangeModelPrivate &dd, QObject *parent)
    : QObject(parent), d_ptr(&dd)
{}

QRangeModel::~QRangeModel() = default;

void QRangeModel::setRange(qreal min, qreal max)
{
    Q_D(QRangeModel);
    if (qFuzzyCompare(min, d->minimum) && qFuzzyCompare(max, d->maximum))
        return;

    const qreal oldValue = value();
    const qreal oldPosition = position();

    d->minimum = min;
    d->maximum = qMax(min, max);
    d->pos = d->equivalentPosition(d->value);

    emit minimumChanged(d->minimum);
    emit maximumChanged(d->maximum);
    d->emitValueAndPositionIfChanged(oldValue, oldPosition);
}

void QRangeModel::setPositionRange(qreal min, qreal max)
{
    Q_D(QRangeModel);
    if (qFuzzyCompare(min, d->posatmin) && qFuzzyCompare(max, d->posatmax))
        return;

    const qreal oldPosition = position();
    d->posatmin = min;
    d->posatmax = max;
    d->pos = d->equivalentPosition(d->value);

    emit positionAtMinimumChanged(d->posatmin);
    emit positionAtMaximumChanged(d->posatmax);
    d->emitValueAndPositionIfChanged(value(), oldPosition);
}

void QRangeModel::setStepSize(qreal stepSize)
{
    Q_D(QRangeModel);
    stepSize = qMax(qreal(0.0), stepSize);
    if (qFuzzyCompare(stepSize, d->stepSize))
        return;

    const qreal oldValue = value();
    const qreal oldPosition = position();
    d->stepSize = stepSize;

    emit stepSizeChanged(d->stepSize);
    d->emitValueAndPositionIfChanged(oldValue, oldPosition);
}

qreal QRangeModel::stepSize() const
{
    Q_D(const QRangeModel);
    return d->stepSize;
}

void QRangeModel::setMinimum(qreal min)
{
    Q_D(const QRangeModel);
    setRange(min, d->maximum);
}

qreal QRangeModel::minimum() const
{
    Q_D(const QRangeModel);
    return d->minimum;
}

void QRangeModel::setMaximum(qreal max)
{
    Q_D(const QRangeModel);
    setRange(qMin(d->minimum, max), max);
}

qreal QRangeModel::maximum() const
{
    Q_D(const QRangeModel);
    return d->maximum;
}

void QRangeModel::setPositionAtMinimum(qreal min)
{
    Q_D(QRangeModel);
    setPositionRange(min, d->posatmax);
}

qreal QRangeModel::positionAtMinimum() const
{
    Q_D(const QRangeModel);
    return d->posatmin;
}

void QRangeModel::setPositionAtMaximum(qreal max)
{
    Q_D(QRangeModel);
    setPositionRange(d->posatmin, max);
}

qreal QRangeModel::positionAtMaximum() const
{
    Q_D(const QRangeModel);
    return d->posatmax;
}

void QRangeModel::setInverted(bool inverted)
{
    Q_D(QRangeModel);
    if (inverted == d->inverted)
        return;

    d->inverted = inverted;
    emit invertedChanged(d->inverted);
    setPosition(d->equivalentPosition(d->value));
}

bool QRangeModel::inverted() const
{
    Q_D(const QRangeModel);
    return d->inverted;
}

qreal QRangeModel::value() const
{
    Q_D(const QRangeModel);
    return d->publicValue(d->value);
}

void QRangeModel::setValue(qreal newValue)
{
    Q_D(QRangeModel);
    if (qFuzzyCompare(newValue, d->value))
        return;

    const qreal oldValue = value();
    const qreal oldPosition = position();

    d->value = newValue;
    d->pos = d->equivalentPosition(newValue);
    d->emitValueAndPositionIfChanged(oldValue, oldPosition);
}

qreal QRangeModel::position() const
{
    Q_D(const QRangeModel);
    return d->publicPosition(d->pos);
}

void QRangeModel::setPosition(qreal newPosition)
{
    Q_D(QRangeModel);
    if (qFuzzyCompare(newPosition, d->pos))
        return;

    const qreal oldValue = value();
    const qreal oldPosition = position();

    d->pos = newPosition;
    d->value = d->equivalentValue(newPosition);
    d->emitValueAndPositionIfChanged(oldValue, oldPosition);
}

qreal QRangeModel::positionForValue(qreal value) const
{
    Q_D(const QRangeModel);
    return d->publicPosition(d->equivalentPosition(value));
}

qreal QRangeModel::valueForPosition(qreal position) const
{
    Q_D(const QRangeModel);
    return d->publicValue(d->equivalentValue(position));
}

void QRangeModel::toMinimum()
{
    Q_D(const QRangeModel);
    setValue(d->minimum);
}

void QRangeModel::toMaximum()
{
    Q_D(const QRangeModel);
    setValue(d->maximum);
}
