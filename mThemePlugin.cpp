#include "mThemePlugin.h"

MThemePlugin::MThemePlugin(QObject *parent)
    : QObject(parent),
    m_inverted(false),
    m_colorScheme(QStringLiteral("default")),
    m_colorString(QStringLiteral("#000000")),
    m_selectionColor(QStringLiteral("#0078d7"))
{
}

MThemePlugin::~MThemePlugin()
{
}

bool MThemePlugin::isInverted() const
{
    return m_inverted;
}

void MThemePlugin::setInverted(bool inverted)
{
    if (m_inverted != inverted) {
        m_inverted = inverted;
        emit invertedChanged();
        // You can add logic here to update dependent properties or reload colors
    }
}

QString MThemePlugin::colorScheme() const
{
    return m_colorScheme;
}

void MThemePlugin::setColorScheme(const QString &colorScheme)
{
    if (m_colorScheme != colorScheme) {
        m_colorScheme = colorScheme;  // no need to move because param is const ref
        emit colorSchemeChanged();

        // Update dependent properties
        if (m_colorScheme == QLatin1String("dark")) {
            m_colorString = QStringLiteral("#FFFFFF");
            m_selectionColor = QStringLiteral("#3399FF");
        } else {
            m_colorString = QStringLiteral("#000000");
            m_selectionColor = QStringLiteral("#0078d7");
        }

        emit colorStringChanged();
        emit selectionColorChanged();
    }
}

QString MThemePlugin::colorString() const
{
    return m_colorString;
}

QString MThemePlugin::selectionColor() const
{
    return m_selectionColor;
}
