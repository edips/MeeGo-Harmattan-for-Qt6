#ifndef MTHEMEPLUGIN_H
#define MTHEMEPLUGIN_H

#include <QObject>
#include <QString>
#include <qqml.h>

class MThemePlugin : public QObject
{
    Q_OBJECT

    Q_PROPERTY(bool inverted READ isInverted WRITE setInverted NOTIFY invertedChanged FINAL)
    Q_PROPERTY(QString colorScheme READ colorScheme WRITE setColorScheme NOTIFY colorSchemeChanged FINAL)
    Q_PROPERTY(QString colorString READ colorString NOTIFY colorStringChanged FINAL)
    Q_PROPERTY(QString selectionColor READ selectionColor NOTIFY selectionColorChanged FINAL)

public:
    explicit MThemePlugin(QObject *parent = nullptr);
    ~MThemePlugin() override;

    bool isInverted() const;
    void setInverted(bool inverted);

    QString colorScheme() const;
    void setColorScheme(const QString &colorScheme);

    QString colorString() const;
    QString selectionColor() const;

Q_SIGNALS:
    void invertedChanged();
    void colorSchemeChanged();
    void colorStringChanged();
    void selectionColorChanged();

private:
    bool m_inverted;
    QString m_colorScheme;
    QString m_colorString;
    QString m_selectionColor;

    Q_DISABLE_COPY(MThemePlugin)
};

QML_DECLARE_TYPE(MThemePlugin)

#endif // MTHEMEPLUGIN_H
