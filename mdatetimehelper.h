#ifndef MDATETIMEHELPER_H
#define MDATETIMEHELPER_H

#include <QObject> // Replaces <QtCore> for QObject
#include <qqml.h>   // Still valid for QML integration macros

class MDateTimeHelper : public QObject
{
    Q_OBJECT

public:
    // Enums for QML exposure using Q_ENUM
    enum TimeUnit {
        Hours = 1,
        Minutes = 2,
        Seconds = 4,
        All = 7
    };
    Q_ENUM(TimeUnit) // FIX: Replaced Q_ENUMS(TimeUnit) with Q_ENUM(TimeUnit)

    enum HourMode {
        TwelveHours = 1,
        TwentyFourHours = 2
    };
    Q_ENUM(HourMode) // FIX: Replaced Q_ENUMS(HourMode) with Q_ENUM(HourMode)

public:
    explicit MDateTimeHelper(QObject *parent = nullptr); // FIX: Use nullptr instead of 0
    virtual ~MDateTimeHelper();

    Q_INVOKABLE static QString shortMonthName(int month);
    Q_INVOKABLE static bool isLeapYear(int year);
    Q_INVOKABLE static int daysInMonth(int year, int month);
    Q_INVOKABLE static int currentYear();
    Q_INVOKABLE static QString amText();
    Q_INVOKABLE static QString pmText();
    Q_INVOKABLE static int hourMode(); // This logic will be updated in .cpp

private:
    Q_DISABLE_COPY(MDateTimeHelper)
};

// FIX: QML_DECLARE_TYPE is removed in Qt 6.
// Type registration will be done in main.cpp using qmlRegisterType.

#endif // MDATETIMEHELPER_H
