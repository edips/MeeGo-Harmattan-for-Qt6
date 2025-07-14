#ifndef QRANGEMODEL_H
#define QRANGEMODEL_H

#include <QObject>
#include <QtQml/qqml.h>

class QRangeModelPrivate;

class QRangeModel : public QObject
{
    Q_OBJECT
    Q_PROPERTY(qreal value READ value WRITE setValue NOTIFY valueChanged USER true FINAL)
    Q_PROPERTY(qreal minimumValue READ minimum WRITE setMinimum NOTIFY minimumChanged FINAL)
    Q_PROPERTY(qreal maximumValue READ maximum WRITE setMaximum NOTIFY maximumChanged FINAL)
    Q_PROPERTY(qreal stepSize READ stepSize WRITE setStepSize NOTIFY stepSizeChanged FINAL)
    Q_PROPERTY(qreal position READ position WRITE setPosition NOTIFY positionChanged FINAL)
    Q_PROPERTY(qreal positionAtMinimum READ positionAtMinimum WRITE setPositionAtMinimum NOTIFY positionAtMinimumChanged FINAL)
    Q_PROPERTY(qreal positionAtMaximum READ positionAtMaximum WRITE setPositionAtMaximum NOTIFY positionAtMaximumChanged FINAL)
    Q_PROPERTY(bool inverted READ inverted WRITE setInverted NOTIFY invertedChanged FINAL)

public:
    explicit QRangeModel(QObject *parent = nullptr);
    ~QRangeModel() override;

    void setRange(qreal min, qreal max);
    void setPositionRange(qreal min, qreal max);

    void setStepSize(qreal stepSize);
    qreal stepSize() const;

    void setMinimum(qreal min);
    qreal minimum() const;

    void setMaximum(qreal max);
    qreal maximum() const;

    void setPositionAtMinimum(qreal posAtMin);
    qreal positionAtMinimum() const;

    void setPositionAtMaximum(qreal posAtMax);
    qreal positionAtMaximum() const;

    void setInverted(bool inverted);
    bool inverted() const;

    qreal value() const;
    qreal position() const;

    Q_INVOKABLE qreal valueForPosition(qreal position) const;
    Q_INVOKABLE qreal positionForValue(qreal value) const;

public slots:
    void toMinimum();
    void toMaximum();
    void setValue(qreal value);
    void setPosition(qreal position);

signals:
    void valueChanged(qreal value);
    void positionChanged(qreal position);
    void stepSizeChanged(qreal stepSize);
    void invertedChanged(bool inverted);
    void minimumChanged(qreal min);
    void maximumChanged(qreal max);
    void positionAtMinimumChanged(qreal min);
    void positionAtMaximumChanged(qreal max);

protected:
    QRangeModel(QRangeModelPrivate &dd, QObject *parent = nullptr);
    QScopedPointer<QRangeModelPrivate> d_ptr;

private:
    Q_DISABLE_COPY(QRangeModel)
    Q_DECLARE_PRIVATE(QRangeModel)
};

QML_DECLARE_TYPE(QRangeModel)

#endif // QRANGEMODEL_H
