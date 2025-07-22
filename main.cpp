#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QScreen>
#include <QDebug>
// --- CHANGE START ---
#include <QJniObject> // Use QJniObject for Qt 6.6 Android JNI calls
// --- CHANGE END ---
#include <QCoreApplication>
#include <QtMath>
#include <QFont> // Include QFont for font scaling
#include <QColor> // Include QColor for colors

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
#include "androidViewControl.h"







// Reference DPI from Nokia N9 (approximate) - This is the DPI for which the original QML components were designed.
const qreal NOKIA_N9_REFERENCE_DPI = 251.0; // ppi
/*QQmlPropertyMap *uiConstants(MLocaleWrapper *locale = nullptr, qreal scaleFactor = 1.0)
{
    QString defaultFontFamily      = QLatin1String("Open Sans");
    QString defaultFontFamilyLight = QLatin1String("Open Sans");

    if (locale && locale->language() == QLatin1String("fa")) {
        defaultFontFamily = QLatin1String("Arial");
        defaultFontFamilyLight = QLatin1String("Arial");
    }

    QQmlPropertyMap *uiConstantsData = new QQmlPropertyMap();

    // Font families
    uiConstantsData->insert("DefaultFontFamily", defaultFontFamily);
    uiConstantsData->insert("DefaultFontFamilyLight", defaultFontFamilyLight);
    uiConstantsData->insert("DefaultFontFamilyBold", "Nokia Pure Text Bold");

    // Scaler lambda
    auto S = [scaleFactor](int v) -> int { return int(std::round(v * scaleFactor)); };

    // Scaled layout metrics
    uiConstantsData->insert("DefaultMargin", S(16));
    uiConstantsData->insert("ButtonSpacing", S(6));
    uiConstantsData->insert("HeaderDefaultHeightPortrait", S(72));
    uiConstantsData->insert("HeaderDefaultHeightLandscape", S(46));
    uiConstantsData->insert("HeaderDefaultTopSpacingPortrait", S(20));
    uiConstantsData->insert("HeaderDefaultBottomSpacingPortrait", S(20));
    uiConstantsData->insert("HeaderDefaultTopSpacingLandscape", S(16));
    uiConstantsData->insert("HeaderDefaultBottomSpacingLandscape", S(14));
    uiConstantsData->insert("ListItemHeightSmall", S(64));
    uiConstantsData->insert("ListItemHeightDefault", S(80));
    uiConstantsData->insert("IndentDefault", S(16));
    uiConstantsData->insert("GroupHeaderHeight", S(40));

    // Fonts with scaled pixel sizes
    QFont font;

    font.setFamily(defaultFontFamilyLight);
    font.setPixelSize(S(24));
    uiConstantsData->insert("BodyTextFont", font);

    font.setPixelSize(S(32));
    uiConstantsData->insert("HeaderFont", font);

    font.setFamily(defaultFontFamily);
    font.setPixelSize(S(18));
    font.setBold(true);
    uiConstantsData->insert("GroupHeaderFont", font);

    font.setPixelSize(S(26));
    uiConstantsData->insert("TitleFont", font);

    font.setPixelSize(S(24));
    uiConstantsData->insert("SmallTitleFont", font);

    font.setFamily(defaultFontFamilyLight);
    font.setPixelSize(S(22));
    font.setBold(false);
    uiConstantsData->insert("FieldLabelFont", font);
    uiConstantsData->insert("FieldLabelColor", QColor("#505050"));

    font.setPixelSize(S(22));
    uiConstantsData->insert("SubtitleFont", font);

    font.setPixelSize(S(18));
    uiConstantsData->insert("InfoFont", font);

    return uiConstantsData;
}
*/

// Your getAndroidDpi function (updated to use QJniObject)
qreal getAndroidDpi()
{
#ifdef Q_OS_ANDROID
    // Access: android.content.Context.getResources().getDisplayMetrics()
    QJniObject activity = QJniObject::callStaticObjectMethod(
        "org/qtproject/qt/android/QtNative",
        "activity",
        "()Landroid/app/Activity;"
        );

    if (!activity.isValid()) {
        qWarning() << "Invalid Activity";
        return -1;
    }

    QJniObject resources = activity.callObjectMethod("getResources", "()Landroid/content/res/Resources;");
    QJniObject metrics = resources.callObjectMethod("getDisplayMetrics", "()Landroid/util/DisplayMetrics;");

    int widthPixels = metrics.getField<jint>("widthPixels");
    int heightPixels = metrics.getField<jint>("heightPixels");
    float xdpi = metrics.getField<jfloat>("xdpi");
    float ydpi = metrics.getField<jfloat>("ydpi");

    qreal dpi = (xdpi + ydpi) / 2.0;

    qDebug() << "Android widthPixels:" << widthPixels;
    qDebug() << "Android heightPixels:" << heightPixels;
    qDebug() << "Android xdpi:" << xdpi;
    qDebug() << "Android ydpi:" << ydpi;
    qDebug() << "Android calculated DPI:" << dpi;

    return dpi;
#else
    return QGuiApplication::primaryScreen()->logicalDotsPerInch();
#endif
}

int main(int argc, char *argv[])
{
    //QGuiApplication::setHighDpiScaleFactorRoundingPolicy(Qt::HighDpiScaleFactorRoundingPolicy::PassThrough);

    QGuiApplication app(argc, argv);
    QQmlApplicationEngine engine;


    // Create OrientationMonitor on the heap and set its parent to &app.
    // This ensures it's deleted automatically when the QGuiApplication exits,
    // thereby outliving the QML engine's cleanup phase and preventing null pointer access.
    OrientationMonitor *orientationMonitor = new OrientationMonitor(&app);
    engine.rootContext()->setContextProperty("orientation", orientationMonitor);






    qreal scaleFactor = 1.0; // Default initialization

#ifdef Q_OS_ANDROID
    qreal avgDpi = getAndroidDpi();

    qreal rawScale = avgDpi / NOKIA_N9_REFERENCE_DPI; // Use the defined constant
    // --- CHANGE START ---
    // Further adjusted the perceptualScale factor to make components smaller.
    // Changed from 0.6 to 0.45 based on your feedback that 0.6 was still too big.
    qreal perceptualScale = rawScale * 0.45;
    // --- CHANGE END ---

    // Re-introducing clamping, but with values that are likely more appropriate
    // for Android devices, allowing for a wider range of scaling.
    // These values might still need fine-tuning based on your testing.
    scaleFactor = std::clamp(perceptualScale, 0.5, 2.0);

    qDebug() << "Android DPI (from JNI):" << avgDpi;
    qDebug() << "MeeGo Raw Scale (avgDpi / N9_REF_DPI):" << rawScale;
    qDebug() << "Perceptual Scale (rawScale * 0.45):" << perceptualScale; // Updated debug output
    qDebug() << "Final ScaleFactor exposed to QML (clamped):" << scaleFactor;

#else
    qreal dpi = QGuiApplication::primaryScreen()->logicalDotsPerInch();
    qreal rawScale = dpi / NOKIA_N9_REFERENCE_DPI; // Use the defined constant
    qreal perceptualScale = rawScale * 0.75; // Keep your perceptual adjustment
    scaleFactor = std::clamp(perceptualScale, 0.85, 1.25); // Original clamp for desktop/non-Android

    qDebug() << "Non-Android DPI (logical):" << dpi;
    qDebug() << "MeeGo Raw Scale (dpi / N9_REF_DPI):" << rawScale;
    qDebug() << "Perceptual Scale (rawScale * 0.75):" << perceptualScale;
    qDebug() << "Final ScaleFactor exposed to QML:" << scaleFactor;
#endif

    engine.rootContext()->setContextProperty("ScaleFactor", scaleFactor);










    // Add MDeclarativeScreen to QML as context property "screen"
    engine.rootContext()->setContextProperty("screen", MDeclarativeScreen::instance());

    // Set up theme data
    //MLocaleWrapper *locale = new MLocaleWrapper;
    //engine.rootContext()->setContextProperty("locale", locale);
    //engine.rootContext()->setContextProperty("UiConstants", uiConstants(locale, scaleFactor));
    //qmlRegisterUncreatableType<MLocaleWrapper>("com.meego.components", 1, 0, "Locale", "");

    engine.rootContext()->setContextProperty("inputContext", new MDeclarativeInputContext);
    qmlRegisterUncreatableType<MDeclarativeInputContext>("com.meego.components", 1, 0, "InputContext", "");


    // Custom primitives
    qmlRegisterType<MInverseMouseArea>("com.meego.components", 1, 0, "InverseMouseArea");
    qmlRegisterType<MDeclarativeMouseFilter>("com.meego.components", 1, 0, "MouseFilter");
    qmlRegisterType<MDeclarativeMouseEvent>("com.meego.components", 1, 0, "MMouseEvent");
    //qmlRegisterType<MDeclarativeIMAttributeExtension>("com.meego.components", 1, 0, "SipAttributes");
    qmlRegisterType<MDeclarativeIMObserver>("com.meego.components", 1, 0, "InputMethodObserver");
    qmlRegisterType<QRangeModel>("com.meego.components", 1, 0, "RangeModel");

    qmlRegisterType<MScrollDecoratorSizer>("com.meego.components", 1, 0, "ScrollDecoratorSizerCPP");
    // --- NEW: Register AndroidViewControl as a singleton ---
    qmlRegisterSingletonType<AndroidViewControl>("com.meego.components", 1, 0, "AndroidViewControl",
                                                 [](QQmlEngine *engine, QJSEngine *scriptEngine) -> QObject* {
                                                     Q_UNUSED(engine);
                                                     Q_UNUSED(scriptEngine);
                                                     return new AndroidViewControl();
                                                 });
    // --- END NEW ---

    // Register enums from MDeclarativeScreen under "Screen" type (non-creatable)
    qmlRegisterSingletonInstance<MDeclarativeScreen>(
        "com.meego.components", 1, 0,
        "Screen", MDeclarativeScreen::instance()
        );
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



    // Load main QML
    const QUrl url(QStringLiteral("qrc:/Main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreationFailed,
                     &app, []() { QCoreApplication::exit(-1); }, Qt::QueuedConnection);

    engine.load(url);



    // Fix for clazy-detaching-temporary: Store the temporary QList in a reference
    const QList<QObject*>& rootObjects = engine.rootObjects();

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





    return app.exec();
}
