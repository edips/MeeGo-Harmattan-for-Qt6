#ifndef MPAGEORIENTATION_H
#define MPAGEORIENTATION_H

#include <QObject>

class MPageOrientation : public QObject
{
    Q_OBJECT

public:
    enum PageOrientation {
        Automatic,
        LockPortrait,
        LockLandscape,
        LockPrevious
    };
    Q_ENUM(PageOrientation)  // ✅ Must come after enum declaration

    explicit MPageOrientation(QObject *parent = nullptr) : QObject(parent) {}
};

#endif // MPAGEORIENTATION_H
