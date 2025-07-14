#ifndef MDIALOGSTATUS_H
#define MDIALOGSTATUS_H

// MDialogStatus.h
#pragma once

#include <QObject>

class MDialogStatus : public QObject
{
    Q_OBJECT
public:
    enum Status {
        Opening,
        Open,
        Closing,
        Closed
    };
    Q_ENUM(Status)  // ✅ Qt6-compatible reflection
};

#endif // MDIALOGSTATUS_H
