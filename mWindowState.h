#ifndef MWINDOWSTATE_H
#define MWINDOWSTATE_H

#include <QObject>
#include <QPointer>

class QWindow;

class MWindowState : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool active READ active NOTIFY activeChanged FINAL)

public:
    static MWindowState* instance();

    explicit MWindowState(QObject *parent = nullptr);
    ~MWindowState() override;

    bool extracted() const;
    bool active() const;

Q_SIGNALS:
    void activeChanged();

private Q_SLOTS:
    void onApplicationFocusWindowChanged(QWindow *newFocusedWindow);
    void onWindowActiveChanged();

private:
    void updateActive(bool newActive);

    bool m_active = false;
    QPointer<QWindow> m_trackedWindow;
};

#endif // MWINDOWSTATE_H
