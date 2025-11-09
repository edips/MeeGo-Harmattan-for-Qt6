// androidviewcontrol.h
#ifndef ANDROIDVIEWCONTROL_H
#define ANDROIDVIEWCONTROL_H

#include <QObject>
#ifdef Q_OS_ANDROID
#include <QJniObject> // Required for Android JNI calls
#endif // ANDROIDVIEWCONTROL_H
#include <QDebug>     // For qWarning and qDebug

class AndroidViewControl : public QObject
{
    Q_OBJECT
public:
    explicit AndroidViewControl(QObject *parent = nullptr);

    Q_INVOKABLE void disableNativeTextSelection();
};

#endif // ANDROIDVIEWCONTROL_H
