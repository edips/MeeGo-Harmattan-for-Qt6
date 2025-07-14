#ifndef MPAGESTATUS_H
#define MPAGESTATUS_H

#include <QObject>

class MPageStatus : public QObject
{
    Q_OBJECT

public:
    enum Status {
        Inactive,
        Activating,
        Active,
        Deactivating
    };
    Q_ENUM(Status)  // ✅ Must come after enum declaration

    explicit MPageStatus(QObject *parent = nullptr) : QObject(parent) {}
};

#endif // MPAGESTATUS_H
