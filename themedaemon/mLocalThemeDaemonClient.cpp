#include "mLocalThemeDaemonClient.h"

#include <QCoreApplication>
#include <QDebug>
#include <QDir>
#include <QSettings>
#include <QFileInfo>

MLocalThemeDaemonClient::MLocalThemeDaemonClient(const QString &testPath, QObject *parent)
    : MAbstractThemeDaemonClient(parent),
    m_pixmapCache()
#ifdef HAVE_MLITE
    , themeItem("/meegotouch/theme/name")
#endif
{
    QStringList themeRoots;
    QString themeRoot = testPath;
    bool testMode = false;

    if (themeRoot.isEmpty()) {
        themeRoot = qEnvironmentVariable("M_THEME_DIR");
    } else {
        testMode = true;
    }

    if (themeRoot.isEmpty()) {
#if defined(THEME_DIR)
        themeRoot = THEME_DIR;
#else
#ifdef Q_OS_WIN
        themeRoot = "c:\\";
#else
        themeRoot = "/usr/share/themes";
#endif
#endif
    }

    if (!testMode) {
        QString themeName;
#ifndef THEME_NAME
#define THEME_NAME "blanco"
#endif
#ifdef HAVE_MLITE
        qDebug() << Q_FUNC_INFO << "Theme:" << themeItem.value(THEME_NAME).toString();
        themeName = themeItem.value(THEME_NAME).toString();
#else
        qDebug() << Q_FUNC_INFO << "Theme:" << THEME_NAME << "(hardcoded)";
        themeName = QLatin1String(THEME_NAME);
#endif

        // Find inheritance chain
        QString nextTheme = themeName;
        QSet<QString> inheritanceChain;

        while (true) {
            const QString themeIndexFileName = themeRoot + QDir::separator() + nextTheme + QDir::separator() + "index.theme";
            QSettings themeIndexFile(themeIndexFileName, QSettings::IniFormat);

            if (themeIndexFile.status() != QSettings::NoError) {
                qWarning() << Q_FUNC_INFO << "Theme" << themeName << "does not exist! Falling back to" << THEME_NAME;
                break;
            }

            if (!themeIndexFile.childGroups().contains(QStringLiteral("X-MeeGoTouch-Metatheme"))) {
                qWarning() << Q_FUNC_INFO << "Theme" << themeName << "is invalid";
                break;
            }

            if (inheritanceChain.contains(nextTheme)) {
                qFatal("%s: cyclic dependency in theme: %s", Q_FUNC_INFO, themeName.toUtf8().constData());
            }

            inheritanceChain.insert(nextTheme);

            // Prepend paths in reverse order of inheritance
            themeRoots.prepend(themeRoot + QDir::separator() + nextTheme + QDir::separator() + QStringLiteral("meegotouch"));

            QString parentTheme = themeIndexFile.value("X-MeeGoTouch-Metatheme/X-Inherits", "").toString();
            if (parentTheme.isEmpty()) {
                break;
            }
            nextTheme = parentTheme;
        }
    } else {
        qDebug() << Q_FUNC_INFO << "Theme: test mode:" << themeRoot;
        themeRoots.append(themeRoot);
    }

    for (const QString &root : themeRoots) {
        QString normalizedRoot = root;
        if (normalizedRoot.endsWith(QDir::separator())) {
            normalizedRoot.chop(1);
        }
        buildHash(QDir(normalizedRoot + QDir::separator() + QStringLiteral("icons")),
                  QStringList() << QStringLiteral("*.svg") << QStringLiteral("*.png") << QStringLiteral("*.jpg"));
    }

    qDebug() << "LocalThemeDaemonClient: Looking for assets in" << themeRoots;
}

MLocalThemeDaemonClient::~MLocalThemeDaemonClient()
{
}

QPixmap MLocalThemeDaemonClient::requestPixmap(const QString &id, const QSize &requestedSize)
{
    QSize size = requestedSize;
    if (size.width() < 1)
        size.setWidth(0);
    if (size.height() < 1)
        size.setHeight(0);

    const PixmapIdentifier pixmapId(id, size);
    QPixmap pixmap = m_pixmapCache.value(pixmapId);
    if (pixmap.isNull()) {
        QImage image = readImage(id);
        if (!image.isNull()) {
            pixmap = QPixmap::fromImage(image);
            if (requestedSize.isValid() && pixmap.size() != requestedSize) {
                pixmap = pixmap.scaled(requestedSize);
            }
            m_pixmapCache.insert(pixmapId, pixmap);
        }
    }
    return pixmap;
}

QImage MLocalThemeDaemonClient::readImage(const QString &id) const
{
    if (!id.isEmpty()) {
        QString filePath = m_filenameHash.value(id);
        if (!filePath.isNull()) {
            QImage image(filePath);
            if (!image.isNull()) {
                return image;
            }
        }
        qDebug() << "Unknown theme image:" << id;
    }
    return QImage();
}

void MLocalThemeDaemonClient::buildHash(const QDir &rootDir, const QStringList &nameFilter)
{
    QDir rDir = rootDir;
    rDir.setNameFilters(nameFilter);
    const QStringList files = rDir.entryList(QDir::Files);
    for (const QString &filename : files) {
        QFileInfo fi(rDir.filePath(filename));
        m_filenameHash.insert(fi.baseName(), fi.absoluteFilePath());
    }

    const QStringList dirList = rDir.entryList(QDir::AllDirs | QDir::NoDotAndDotDot);
    for (const QString &nextDir : dirList) {
        QDir nextDirObj(rDir.filePath(nextDir));
        buildHash(nextDirObj, nameFilter);
    }
}

// PixmapIdentifier definitions

MLocalThemeDaemonClient::PixmapIdentifier::PixmapIdentifier()
    : imageId(), size()
{
}

MLocalThemeDaemonClient::PixmapIdentifier::PixmapIdentifier(const QString &imageId, const QSize &size)
    : imageId(imageId), size(size)
{
}

bool MLocalThemeDaemonClient::PixmapIdentifier::operator==(const PixmapIdentifier &other) const
{
    return imageId == other.imageId && size == other.size;
}

bool MLocalThemeDaemonClient::PixmapIdentifier::operator!=(const PixmapIdentifier &other) const
{
    return !(*this == other);
}

uint qHash(const MLocalThemeDaemonClient::PixmapIdentifier &id)
{
    return qHash(id.imageId) ^
           (qHash(id.size.width()) << 8) ^
           (qHash(id.size.width()) >> 24) ^
           (qHash(id.size.height()) << 24) ^
           (qHash(id.size.height()) >> 8);
}
