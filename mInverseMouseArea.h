#ifndef MINVERSEMOUSEAREA_H
#define MINVERSEMOUSEAREA_H

#include <QQuickItem>

class MInverseMouseArea : public QQuickItem
{
    Q_OBJECT
    Q_PROPERTY(bool enabled READ isEnabled WRITE setEnabled NOTIFY enabledChangedCustom)

public:
    explicit MInverseMouseArea(QQuickItem *parent = nullptr);
    ~MInverseMouseArea() override;

    bool isEnabled() const;
    void setEnabled(bool enabled);

signals:
    void pressedOutside(int mouseX, int mouseY);
    void clickedOutside(int mouseX, int mouseY);
    void enabledChangedCustom(); // avoid clazy conflict with QObject::enabledChanged

protected:
    void itemChange(ItemChange change, const ItemChangeData &data) override;
    bool eventFilter(QObject *obj, QEvent *event) override;

private:
    QPointF mapToRootItem(const QPointF &scenePos);

    bool m_pressed = false;
    bool m_enabled = true;
    QPointF m_pressPosScene;
};

#endif // MINVERSEMOUSEAREA_H
