/****************************************************************************
**
** Originally part of the MeeGo Harmattan Qt Components project
** © 2011 Nokia Corporation and/or its subsidiary(-ies). All rights reserved.
**
** Licensed under the BSD License.
** See the original license text for redistribution and use conditions.
**
** Ported from MeeGo Harmattan (Qt 4.7) to Qt 6 by Edip Ahmet Taskin, 2025.
**
****************************************************************************/
#include "mdatetimehelper.h"
#include <QDate>   // Still valid
#include <QLocale> // Still valid

#if defined(Q_OS_WIN)
#include <qt_windows.h> // Still valid for Windows specific calls
#endif

// FIX: Removed HAVE_MEEGOTOUCH and <MLocale> as they are not part of standard Qt 6.
// #elif defined(HAVE_MEEGOTOUCH)
// #include <MLocale>

MDateTimeHelper::MDateTimeHelper(QObject *parent) : QObject(parent)
{
}

MDateTimeHelper::~MDateTimeHelper()
{
}

QString MDateTimeHelper::shortMonthName(int month)
{
    // FIX: Changed from QLocale().shortMonthName to QLocale().monthName(month, QLocale::ShortFormat) for Qt 6 compatibility
    return QLocale().monthName(month, QLocale::ShortFormat);
}

bool MDateTimeHelper::isLeapYear(int year)
{
    return QDate::isLeapYear(year);
}

int MDateTimeHelper::daysInMonth(int year, int month)
{
    return QDate(year, month, 1).daysInMonth();
}

int MDateTimeHelper::currentYear()
{
    return QDate::currentDate().year();
}

QString MDateTimeHelper::amText()
{
    return QLocale().amText();
}

QString MDateTimeHelper::pmText()
{
    return QLocale().pmText();
}

int MDateTimeHelper::hourMode()
{
    bool format12h = false;
#if defined(Q_OS_WIN)
    wchar_t data[10];
    GetLocaleInfo(LOCALE_USER_DEFAULT, LOCALE_STIMEFORMAT, data, 10);
    format12h = QString::fromWCharArray(data).startsWith(QLatin1Char('h'));
#else
    // FIX: Replaced MeeGo-specific MLocale logic with standard QLocale logic.
    // QLocale::timeFormat() returns a QLocale::FormatType enum that indicates
    // whether the time format is 12-hour or 24-hour.
    // We check if the format contains 'h' (12-hour) or 'H' (24-hour).
    // This is a more robust way to determine the hour mode across platforms in Qt 6.
    QString timeFormatString = QLocale().timeFormat(QLocale::LongFormat); // Get a detailed time format string
    if (timeFormatString.contains(QLatin1Char('h'), Qt::CaseSensitive) &&
        !timeFormatString.contains(QLatin1Char('H'), Qt::CaseSensitive)) {
        format12h = true; // Contains 'h' but not 'H' -> likely 12-hour
    } else {
        format12h = false; // Otherwise, assume 24-hour or a mix that defaults to 24-hour for this enum
    }
#endif
    return format12h ? TwelveHours : TwentyFourHours;
}
