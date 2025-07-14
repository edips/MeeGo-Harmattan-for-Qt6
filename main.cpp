#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "mPageOrientation.h"
//#include "mDeclarativeImageprovider.h"
#include "mDialogStatus.h"
#include "mPageStatus.h"
#include "mScrollDecoratorSizer.h"
//#include "mThemePlugin.h"
#include "mDeclarativeScreen.h"
#include <QQmlPropertyMap>
#include "MLocaleWrapper.h" // your class
#include "mInverseMouseArea.h"
#include "mDeclarativeMouseFilter.h"
#include "mDeclarativeImObserver.h"
#include "models/qRangeModel.h"



QQmlPropertyMap *uiConstants(MLocaleWrapper *locale = nullptr, qreal scaleFactor = 1.0)
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

/*qreal calculateScaleFactor(const QSize &screenSize) {
    const qreal refWidth = 480.0;
    const qreal refHeight = 854.0;
    return std::min(screenSize.width() / refWidth, screenSize.height() / refHeight);
}*/


int main(int argc, char *argv[])
{
    QGuiApplication::setHighDpiScaleFactorRoundingPolicy(Qt::HighDpiScaleFactorRoundingPolicy::PassThrough);

    QGuiApplication app(argc, argv);
    QQmlApplicationEngine engine;

    qreal scaleFactor = std::min(QGuiApplication::primaryScreen()->size().width() / 480.0,
                                 QGuiApplication::primaryScreen()->size().height() / 854.0);

    // Expose scaleFactor to QML
    engine.rootContext()->setContextProperty("ScaleFactor", scaleFactor);


    // Add MDeclarativeScreen to QML as context property "screen"
    engine.rootContext()->setContextProperty("screen", MDeclarativeScreen::instance());

    // Set up theme data
    MLocaleWrapper *locale = new MLocaleWrapper;
    engine.rootContext()->setContextProperty("locale", locale);
    engine.rootContext()->setContextProperty("UiConstants", uiConstants(locale, scaleFactor));
    qmlRegisterUncreatableType<MLocaleWrapper>("com.meego.components", 1, 0, "Locale", "");

    // Assuming MDeclarativeInputContext inherits QObject
    //MDeclarativeInputContext *declarativeInputContext = new MDeclarativeInputContext;
    //engine.rootContext()->setContextProperty("inputContext", static_cast<QObject*>(declarativeInputContext));

    // Register uncreatable type for QML so you can use InputContext as a type (but can't instantiate)
    qmlRegisterUncreatableType<MDeclarativeInputContext>(
        "com.meego.components", 1, 0, "InputContext", "Use the singleton inputContext instead");


    // Custom primitives
    qmlRegisterType<MInverseMouseArea>("com.meego.components", 1, 0, "InverseMouseArea");
    qmlRegisterType<MDeclarativeMouseFilter>("com.meego.components", 1, 0, "MouseFilter");
    qmlRegisterType<MDeclarativeMouseEvent>("com.meego.components", 1, 0, "MMouseEvent");
    //qmlRegisterType<MDeclarativeIMAttributeExtension>("com.meego.components", 1, 0, "SipAttributes");
    qmlRegisterType<MDeclarativeIMObserver>("com.meego.components", 1, 0, "InputMethodObserver");
    qmlRegisterType<QRangeModel>("com.meego.components", 1, 0, "RangeModel");

    qmlRegisterType<MScrollDecoratorSizer>("com.meego.components", 1, 0, "ScrollDecoratorSizerCPP");


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
    return app.exec();
}
