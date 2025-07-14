#ifndef MDECLARATIVEMOUSEFILTER_H
#define MDECLARATIVEMOUSEFILTER_H

#include <QQuickItem>
#include <QPointF>
#include <QObject>

class MDeclarativeMouseEvent : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int x READ x NOTIFY xChanged)
    Q_PROPERTY(int y READ y NOTIFY yChanged)
    Q_PROPERTY(bool filtered READ isFiltered WRITE setFiltered NOTIFY filteredChanged)

public:
    explicit MDeclarativeMouseEvent(QObject *parent = nullptr)
        : QObject(parent), _x(0), _y(0), _filtered(false) {}

    explicit MDeclarativeMouseEvent(const QPointF &point, QObject *parent = nullptr)
        : QObject(parent), _x(static_cast<int>(point.x())), _y(static_cast<int>(point.y())), _filtered(false) {}

    int x() const { return _x; }
    int y() const { return _y; }

    bool isFiltered() const { return _filtered; }
    void setFiltered(bool filtered) {
        if (_filtered != filtered) {
            _filtered = filtered;
            emit filteredChanged();
        }
    }

signals:
    void xChanged();
    void yChanged();
    void filteredChanged();

private:
    int _x;
    int _y;
    bool _filtered;
};

class MDeclarativeMouseFilter : public QQuickItem
{
    Q_OBJECT

public:
    explicit MDeclarativeMouseFilter(QQuickItem *parent = nullptr);
    ~MDeclarativeMouseFilter();

signals:
    void mousePositionChanged(MDeclarativeMouseEvent *mouse);
    void pressed(MDeclarativeMouseEvent *mouse);
    void delayedPressSent();
    void pressAndHold(MDeclarativeMouseEvent *mouse);
    void released(MDeclarativeMouseEvent *mouse);
    void finished();
    void horizontalDrag();
    void doubleClicked(MDeclarativeMouseEvent *mouse);

protected:
    bool event(QEvent *event) override;
    void itemChange(ItemChange change, const ItemChangeData &data) override;
    void timerEvent(QTimerEvent *event) override;

private:
    void clampMousePosition(QMouseEvent *me);

    int pressAndHoldTimerId;
    QPoint lastPos;
};

#endif // MDECLARATIVEMOUSEFILTER_H
