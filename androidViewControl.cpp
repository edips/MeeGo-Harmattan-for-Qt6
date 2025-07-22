// androidviewcontrol.cpp
#include "androidViewControl.h"

AndroidViewControl::AndroidViewControl(QObject *parent) : QObject(parent) {}

void AndroidViewControl::disableNativeTextSelection()
{
#ifdef Q_OS_ANDROID
    QJniObject activity = QJniObject::callStaticObjectMethod(
        "org/qtproject/qt/android/QtNative",
        "activity",
        "()Landroid/app/Activity;"
        );

    if (!activity.isValid()) {
        qWarning() << "AndroidViewControl: Invalid Activity. Cannot proceed with JNI calls.";
        return;
    }

    // Call the new Java static method to recursively disable text selection on the window.
    // Ensure the Java class path matches where you place CustomQtAndroidViewUtils.java.
    // If you put it directly in org.qtproject.qt.android, then the path is "org/qtproject/qt/android/CustomQtAndroidViewUtils".
    // If you put it in your main Activity, you'd call it directly on the activity object.
    // For this example, assuming it's in a separate utility class.
    QJniObject::callStaticMethod<void>(
        "org/qtproject/qt/android/CustomQtAndroidViewUtils", // Adjust this path if your Java class is elsewhere
        "disableNativeTextSelectionOnWindow",
        "(Landroid/app/Activity;)V",
        activity.object<jobject>()
        );
    qDebug() << "AndroidViewControl: Called Java method to disable native text selection on window.";

    // The previous calls to hideSoftInputFromWindow are still useful
    // as they can help dismiss existing native UI elements.
    QJniObject inputMethodManager = activity.callObjectMethod(
        "getSystemService",
        "(Ljava/lang/String;)Ljava/lang/Object;",
        QJniObject::fromString("input_method").object<jstring>()
        );

    if (inputMethodManager.isValid()) {
        // Hide the soft input, which can sometimes dismiss native toolbars
        QJniObject currentFocus = activity.callObjectMethod("getCurrentFocus", "()Landroid/view/View;");
        if (currentFocus.isValid()) {
            inputMethodManager.callMethod<jboolean>("hideSoftInputFromWindow",
                                                    "(Landroid/os/IBinder;I)Z",
                                                    currentFocus.callObjectMethod("getWindowToken", "()Landroid/os/IBinder;").object<jobject>(),
                                                    0); // 0 for no flags
            qDebug() << "AndroidViewControl: Called hideSoftInputFromWindow.";
        } else {
            qWarning() << "AndroidViewControl: No current focus view for hideSoftInputFromWindow.";
        }

        // --- CHANGE START ---
        // Removed the problematic restartInput() call as it was causing NoSuchMethodError.
        // We rely on the Java side's setTextIsSelectable(false) for disabling the native dialog.
        // inputMethodManager.callMethod<void>("restartInput", "()V");
        // qDebug() << "AndroidViewControl: Called restartInput.";
        // --- CHANGE END ---
    } else {
        qWarning() << "AndroidViewControl: Could not get InputMethodManager.";
    }

#else
    qDebug() << "AndroidViewControl: JNI calls are only for Android.";
#endif
}
