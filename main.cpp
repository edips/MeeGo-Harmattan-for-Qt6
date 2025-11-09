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

#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QScreen>
#include <QDebug>

#include <QCoreApplication>
#include <QtMath>
#include <QFont> // Include QFont for font scaling
#include <QColor> // Include QColor for colors
#include <QFontDatabase>

#include "mPageOrientation.h"
//#include "mDeclarativeImageprovider.h"
#include "mDialogStatus.h"
#include "mPageStatus.h"
#include "mScrollDecoratorSizer.h"
//#include "mThemePlugin.h"
#include "mDeclarativeScreen.h"
#include <QQmlPropertyMap>
//#include "MLocaleWrapper.h" // your class
#include "mInverseMouseArea.h"
#include "mDeclarativeMouseFilter.h"
#include "mDeclarativeImObserver.h"
#include "mDeclarativeInputContext.h"
#include "models/qRangeModel.h"
#include <QQuickWindow>
#include "mOrientationHelper.h"
#include "mdatetimehelper.h"
#include "mtoolbarvisibility.h"
#include "globalsettings.h"
#include "mWindowState.h"
#include "device.h"

// This static function provides the singleton instance to QML.
// It will be called by the QML engine when the singleton is first accessed.
static QObject *MDeclarativeScreen_qmlSingleton(QQmlEngine *engine, QJSEngine *scriptEngine)
{
    Q_UNUSED(engine)
    Q_UNUSED(scriptEngine)
    // Return the singleton instance of MDeclarativeScreen
    return MDeclarativeScreen::instance();
}


int main(int argc, char *argv[])
{
    //qputenv("QT_SCALE_FACTOR", QByteArray::number(0.78));

    QGuiApplication app(argc, argv);

    // Add custom font
    int fontId = QFontDatabase::addApplicationFont(":/assets/NokiaPureText_Rg.ttf");
    if (fontId != -1) {
        QStringList fontFamilies = QFontDatabase::applicationFontFamilies(fontId);
        if (!fontFamilies.isEmpty()) {
            QFont font(fontFamilies.at(0));
            app.setFont(font);
        }
    }
    //QQmlApplicationEngine engine;

    QQmlApplicationEngine *engine = new QQmlApplicationEngine();
    // Setting up QML function from c++
    GlobalSettings::init(engine);


    // Create OrientationMonitor on the heap and set its parent to &app.
    // This ensures it's deleted automatically when the QGuiApplication exits,
    // thereby outliving the QML engine's cleanup phase and preventing null pointer access.
    OrientationMonitor *orientationMonitor = new OrientationMonitor(&app);
    engine->rootContext()->setContextProperty("orientation", orientationMonitor);



    // Add MDeclarativeScreen to QML as context property "screen"
    engine->rootContext()->setContextProperty("screen", MDeclarativeScreen::instance());

    // Set up theme data
    //MLocaleWrapper *locale = new MLocaleWrapper;
    //engine.rootContext()->setContextProperty("locale", locale);
    //engine.rootContext()->setContextProperty("UiConstants", uiConstants(locale, scaleFactor));
    //qmlRegisterUncreatableType<MLocaleWrapper>("com.meego.components", 1, 0, "Locale", "");

    engine->rootContext()->setContextProperty("inputContext", new MDeclarativeInputContext);
    qmlRegisterUncreatableType<MDeclarativeInputContext>("com.meego.components", 1, 0, "InputContext", "");





    // Date time picker helper

    engine->rootContext()->setContextProperty("dateTime", new MDateTimeHelper(engine->rootContext()));
    qmlRegisterUncreatableType<MDateTimeHelper>("com.meego.components", 1, 0, "DateTime", "");


    // Custom primitives
    qmlRegisterType<MInverseMouseArea>("com.meego.components", 1, 0, "InverseMouseArea");
    qmlRegisterType<MDeclarativeMouseFilter>("com.meego.components", 1, 0, "MouseFilter");
    qmlRegisterType<MDeclarativeMouseEvent>("com.meego.components", 1, 0, "MMouseEvent");
    //qmlRegisterType<MDeclarativeIMAttributeExtension>("com.meego.components", 1, 0, "SipAttributes");
    qmlRegisterType<MDeclarativeIMObserver>("com.meego.components", 1, 0, "InputMethodObserver");
    qmlRegisterType<QRangeModel>("com.meego.components", 1, 0, "RangeModel");
    //qmlRegisterType<MDeclarativeMaskedItem>("com.meego.components", 1, 0, "MaskedItem");

    engine->rootContext()->setContextProperty("platformWindow", MWindowState::instance());
    qmlRegisterUncreatableType<MWindowState>("com.meego.components", 1, 0, "WindowState","");

    qmlRegisterType<MScrollDecoratorSizer>("com.meego.components", 1, 0, "ScrollDecoratorSizerCPP");

    // Register enums from MDeclarativeScreen under "Screen" type (non-creatable)
    qmlRegisterSingletonType<MDeclarativeScreen>("com.meego.components", 1, 0, "MeeGoScreen", MDeclarativeScreen_qmlSingleton);
    qmlRegisterUncreatableType<MPageStatus>("com.meego.components", 1, 0, "PageStatus", "");
    qmlRegisterUncreatableType<MPageOrientation>("com.meego.components", 1, 0, "PageOrientation", "");


    // Only add theme image provider if not already added
    /*if (!engine.imageProvider("theme")) {
        engine.addImageProvider("theme", new MDeclarativeImageProvider);

        // Set the theme plugin as a context property
        engine.rootContext()->setContextProperty("theme", new MThemePlugin);

        // Register MThemePlugin as an uncreatable type for QML type system
        qmlRegisterUncreatableType<MThemePlugin>("com.meego.components", 1, 0, "Theme", "Cannot create Theme in QML");

        // Add MDeclarativeScreen to QML as context property "screen"
        engine.rootContext()->setContextProperty("screen", MDeclarativeScreen::instance());

        // Register enums from MDeclarativeScreen under "Screen" type (non-creatable)
        qmlRegisterUncreatableType<MDeclarativeScreen>("com.meego.components", 1, 0, "Screen", "Screen is a singleton for screen properties");
    }*/

    // Register C++ types to QML
    qmlRegisterType<MScrollDecoratorSizer>("com.meego.components", 1, 0, "ScrollDecoratorSizerCPP");
    qmlRegisterUncreatableType<MDialogStatus>("com.meego.components", 1, 0, "DialogStatus", "DialogStatus is an enum type and cannot be created");
    qmlRegisterUncreatableType<MToolBarVisibility>("com.meego.components", 1, 0, "ToolBarVisibility", "");

    qmlRegisterSingletonType<Device>("com.meego.components", 1, 0, "Device", &Device::create);

    // Load main QML
    engine->load(QUrl("qrc:/Main.qml"));

    QObject::connect(engine, &QQmlApplicationEngine::objectCreated, &app, [](QObject *obj, const QUrl &objUrl) {
        if (!obj && objUrl.toString() == "qrc:/Main.qml") {
            QCoreApplication::exit(-1);
        }
    }, Qt::QueuedConnection);




    // Fix for clazy-detaching-temporary: Store the temporary QList in a reference
    const QList<QObject*>& rootObjects = engine->rootObjects();

    QObject *rootObject = rootObjects.first(); // Now calling first() on a stable reference





    QQuickWindow *window = qobject_cast<QQuickWindow*>(rootObject);

    if (!window) {
        // Ensure that rootObjects is not empty before accessing parent()
        if (!rootObjects.isEmpty()) {
            window = qobject_cast<QQuickWindow*>(rootObjects.first()->parent());
        }
        if (!window) {
            qWarning("Could not find QQuickWindow from root object or its parent. Orientation monitoring may not work.");
        }
    }

    if (window) {
        orientationMonitor->setWindow(window);
    }


    int ret = app.exec();
    delete engine;
    return ret;
}
