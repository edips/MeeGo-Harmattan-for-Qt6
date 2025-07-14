#ifndef MSCROLLDECORATORSIZER_H
#define MSCROLLDECORATORSIZER_H

#include <QQuickItem>

class MScrollDecoratorSizer : public QQuickItem
{
    Q_OBJECT

    Q_PROPERTY(qreal positionRatio READ positionRatio WRITE setPositionRatio NOTIFY positionRatioChanged)
    Q_PROPERTY(qreal sizeRatio READ sizeRatio WRITE setSizeRatio NOTIFY sizeRatioChanged)
    Q_PROPERTY(qreal maxPosition READ maxPosition WRITE setMaxPosition NOTIFY maxPositionChanged)
    Q_PROPERTY(qreal minSize READ minSize WRITE setMinSize NOTIFY minSizeChanged)

    Q_PROPERTY(int position READ position NOTIFY positionChanged FINAL)
    Q_PROPERTY(int size READ size NOTIFY sizeChanged FINAL)

public:
    explicit MScrollDecoratorSizer(QQuickItem *parent = nullptr);
    ~MScrollDecoratorSizer() override;

    qreal positionRatio() const;
    void setPositionRatio(qreal val);

    qreal sizeRatio() const;
    void setSizeRatio(qreal val);

    qreal maxPosition() const;
    void setMaxPosition(qreal val);

    qreal minSize() const;
    void setMinSize(qreal val);

    int position() const;
    int size() const;

Q_SIGNALS:
    void positionRatioChanged();
    void sizeRatioChanged();
    void maxPositionChanged();
    void minSizeChanged();
    void positionChanged();
    void sizeChanged();

protected:
    void recompute();

private:
    qreal m_positionRatio = 0.0;
    qreal m_sizeRatio = 0.0;
    qreal m_maxPosition = 0.0;
    qreal m_minSize = 0.0;

    int m_position = 0;
    int m_size = 0;
};

#endif // MSCROLLDECORATORSIZER_H
