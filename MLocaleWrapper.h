// MLocaleWrapper.h - Qt 6.6 Compatible Version
#ifndef MLOCALEWRAPPER_H
#define MLOCALEWRAPPER_H

#include <QObject>
#include <QString>
#include <QStringList>
#include <QDateTime>
#include <QDebug>

#ifdef HAVE_MEEGOTOUCH
#include <MLocale>
#endif

class MLocaleWrapper : public QObject {
    Q_OBJECT

public:
    explicit MLocaleWrapper(QObject *parent = nullptr)
#ifdef HAVE_MEEGOTOUCH
        : QObject(parent), ml(new MLocale)
#else
        : QObject(parent)
#endif
    {}

    ~MLocaleWrapper() {
#ifdef HAVE_MEEGOTOUCH
        delete ml;
        ml = nullptr;
#endif
    }

    // Enums
    enum DateType { DateNone, DateShort, DateMedium, DateLong, DateFull, DateYearAndMonth };
    enum TimeType { TimeNone, TimeShort, TimeMedium, TimeLong, TimeFull };
    enum Category { MLcMessages, MLcTime, MLcCollate, MLcNumeric, MLcMonetary, MLcName, MLcTelephone };
    enum Collation {
        DefaultCollation, PhonebookCollation, PinyinCollation, TraditionalCollation,
        StrokeCollation, DirectCollation, PosixCollation, Big5hanCollation, Gb2312hanCollation
    };
    enum CalendarType {
        DefaultCalendar, GregorianCalendar, IslamicCalendar, ChineseCalendar,
        IslamicCivilCalendar, HebrewCalendar, JapaneseCalendar, BuddhistCalendar,
        PersianCalendar, CopticCalendar, EthiopicCalendar
    };
    enum TimeFormat24h {
        LocaleDefaultTimeFormat24h, TwelveHourTimeFormat24h, TwentyFourHourTimeFormat24h
    };
    enum Weekday {
        Monday = 1, Tuesday, Wednesday, Thursday, Friday, Saturday, Sunday
    };

    // Qt Meta-Object Declarations (must follow enum declarations)
    Q_ENUM(DateType)
    Q_ENUM(TimeType)
    Q_ENUM(Category)
    Q_ENUM(Collation)
    Q_ENUM(CalendarType)
    Q_ENUM(TimeFormat24h)
    Q_ENUM(Weekday)

#ifdef HAVE_MEEGOTOUCH
    // QML-visible properties
    Q_PROPERTY(bool valid READ isValid NOTIFY isValidChanged FINAL)
    Q_PROPERTY(int calendarType READ calendarType WRITE setCalendarType NOTIFY calendarTypeChanged)
    Q_PROPERTY(int timeFormat24h READ timeFormat24h WRITE setTimeFormat24h NOTIFY timeFormat24hChanged)
    Q_PROPERTY(int defaultTimeFormat24h READ defaultTimeFormat24h NOTIFY defaultTimeFormat24hChanged FINAL)
    Q_PROPERTY(QString language READ language NOTIFY languageChanged FINAL)

    bool isValid() const { Q_ASSERT(ml); return ml->isValid(); }

    int calendarType() const { Q_ASSERT(ml); return static_cast<int>(ml->calendarType()); }
    void setCalendarType(int type) {
        Q_ASSERT(ml);
        if (type != static_cast<int>(ml->calendarType())) {
            ml->setCalendarType(static_cast<MLocale::CalendarType>(type));
            emit calendarTypeChanged();
        }
    }

    int timeFormat24h() const { Q_ASSERT(ml); return static_cast<int>(ml->timeFormat24h()); }
    void setTimeFormat24h(int fmt) {
        Q_ASSERT(ml);
        if (fmt != static_cast<int>(ml->timeFormat24h())) {
            ml->setTimeFormat24h(static_cast<MLocale::TimeFormat24h>(fmt));
            emit timeFormat24hChanged();
        }
    }

    int defaultTimeFormat24h() const { Q_ASSERT(ml); return static_cast<int>(ml->defaultTimeFormat24h()); }

    QString language() const { Q_ASSERT(ml); return ml->language(); }

public slots:
    void setLocale(const QString &localeName) {
        delete ml;
        ml = new MLocale(localeName);
        emit isValidChanged();
        emit calendarTypeChanged();
        emit timeFormat24hChanged();
        emit defaultTimeFormat24hChanged();
        emit languageChanged();
    }

signals:
    void isValidChanged();
    void calendarTypeChanged();
    void timeFormat24hChanged();
    void defaultTimeFormat24hChanged();
    void languageChanged();

private:
    MLocale *ml = nullptr;

#else
    // Minimal stub when HAVE_MEEGOTOUCH is not defined
    Q_PROPERTY(QString language READ language NOTIFY languageChanged FINAL)
    QString language() const { return QStringLiteral("en"); }

signals:
    void languageChanged();
#endif
};

#endif // MLOCALEWRAPPER_H
