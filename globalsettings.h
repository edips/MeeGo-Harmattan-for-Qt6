/***************************************************************************
  Copyright            : (C)  Lutra Consulting
  Modified by          : Edip Ahmet Taşkın
  Email                : geosoft66@gmail.com
 ***************************************************************************
 *                                                                         *
 *   This program is free software; you can redistribute it and/or modify  *
 *   it under the terms of the GNU General Public License as published by  *
 *   the Free Software Foundation; either version 2 of the License, or     *
 *   (at your option) any later version.                                   *
 *                                                                         *
 ***************************************************************************/

#ifndef GLOBALSETTINGS_H
#define GLOBALSETTINGS_H

#include <QObject>
#include <QString>
#include <QColor>
#include <QtQml/qqmlregistration.h>

class QQmlEngine;
class QJSEngine;

class GlobalSettings: public QObject
{
    Q_OBJECT
    QML_ELEMENT
    QML_SINGLETON
    // Settings
    Q_PROPERTY( bool menuFocus READ menuFocus WRITE setMenuFocus NOTIFY menuFocusChanged )
    Q_PROPERTY( bool contextmenuFocus READ contextmenuFocus WRITE setContextmenuFocus NOTIFY contextmenuFocusChanged )
    Q_PROPERTY( bool dialogFocus READ dialogFocus WRITE setDialogFocus NOTIFY dialogFocusChanged )
    Q_PROPERTY( bool sheetFocus READ sheetFocus WRITE setSheetFocus NOTIFY sheetFocusChanged )
public:
    ~GlobalSettings();

    inline static GlobalSettings *instance;
    static void init(QObject *parent = nullptr) {
        instance = new GlobalSettings(parent);
    }
    static GlobalSettings *create(QQmlEngine *, QJSEngine *) { return instance; }

    // Settings
    // menuFocus
    bool menuFocus() const;
    void setMenuFocus(const bool &menuFocus );

    // contextmenuFocus
    bool contextmenuFocus() const;
    void setContextmenuFocus(const bool &contextmenuFocus );

    // dialogFocus
    bool dialogFocus() const;
    void setDialogFocus(const bool &dialogFocus );

    // dialogFocus
    bool sheetFocus() const;
    void setSheetFocus(const bool &sheetFocus );

Q_SIGNALS:
    void menuFocusChanged(const bool &menuFocus);
    void contextmenuFocusChanged(const bool &contextmenuFocus);
    void dialogFocusChanged(const bool &dialogFocus);
    void sheetFocusChanged(const bool &sheetFocus);

private:
    explicit GlobalSettings(QObject *parent = nullptr);
    Q_DISABLE_COPY_MOVE(GlobalSettings)

    // menuFocus
    bool mContextmenuFocus;
    // menuFocus
    bool mMenuFocus;

    // dialogFocus
    bool mDialogFocus;

    // sheetFocus
    bool mSheetFocus;
};

#endif // GLOBALSETTINGS_H
