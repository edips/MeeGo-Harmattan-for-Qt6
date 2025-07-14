#ifndef MDECLARATIVEIMOBSERVER_H
#define MDECLARATIVEIMOBSERVER_H

#include <QQuickItem>
#include <QString>
#include <QEvent>

class MDeclarativeIMObserver : public QQuickItem
{
    Q_OBJECT
    Q_PROPERTY(QString preedit READ preedit NOTIFY preeditChanged FINAL)
    Q_PROPERTY(int preeditCursorPosition READ preeditCursorPosition NOTIFY preeditCursorPositionChanged FINAL)

public:
    explicit MDeclarativeIMObserver(QQuickItem *parent = nullptr);

    QString preedit() const { return m_preedit; }
    int preeditCursorPosition() const { return m_preeditCursorPosition; }

signals:
    void preeditChanged();
    void preeditCursorPositionChanged();

protected:
    void componentComplete() override;
    bool event(QEvent *event) override;

private:
    QString m_preedit;
    int m_preeditCursorPosition = 0;
};

#endif // MDECLARATIVEIMOBSERVER_H

