#pragma once

#include <QQuickPaintedItem>
#include <QQuickItem>
#include <QPainterPath>

class MDeclarativeMaskedItem : public QQuickPaintedItem
{
    Q_OBJECT
    Q_PROPERTY(QQuickItem* mask READ mask WRITE setMask NOTIFY maskChanged)

public:
    explicit MDeclarativeMaskedItem(QQuickItem *parent = nullptr);
    ~MDeclarativeMaskedItem() override = default;

    QQuickItem* mask() const;
    void setMask(QQuickItem* item);

    void paint(QPainter *painter) override;

signals:
    void maskChanged();

private:
    QQuickItem* m_mask = nullptr;
};
