// androidviewcontrol.h
#ifndef ANDROIDVIEWCONTROL_H
#define ANDROIDVIEWCONTROL_H

#include <QObject>
#include <QJniObject> // Required for Android JNI calls
#include <QDebug>     // For qWarning and qDebug

class AndroidViewControl : public QObject
{
    Q_OBJECT
public:
    explicit AndroidViewControl(QObject *parent = nullptr);

    Q_INVOKABLE void disableNativeTextSelection();
};

#endif // ANDROIDVIEWCONTROL_H
