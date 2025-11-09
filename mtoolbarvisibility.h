#ifndef MTOOLBARVISIBILITY_H
#define MTOOLBARVISIBILITY_H

#include <QObject>

class MToolBarVisibility : public QObject
{
    Q_OBJECT // Q_OBJECT should be at the beginning of the class definition

public:
    enum Visibility { Visible, Hidden, HiddenImmediately };
    Q_ENUM(Visibility) // Changed from Q_ENUMS(Visibility) to Q_ENUM(Visibility) for Qt 6.6
};

#endif // MTOOLBARVISIBILITY_H
