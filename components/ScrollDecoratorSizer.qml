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

import QtQuick
import com.meego.components 1.0

Item {
    // relative (0..1) position of top and bottom
    property real positionRatio
    property real sizeRatio
    
    // max position and min size
    property real maxPosition
    property real minSize
    
    // size underflow
    property real sizeUnderflow: (sizeRatio * maxPosition) < minSize ? minSize - (sizeRatio * maxPosition) : 0
    
    // raw start and end position considering minimum size
    property real rawStartPos: positionRatio * (maxPosition - sizeUnderflow)
    property real rawEndPos: (positionRatio + sizeRatio) * (maxPosition - sizeUnderflow) + sizeUnderflow
    
    // overshoot amount at start and end
    property real overshootStart: rawStartPos < 0 ? -rawStartPos : 0
    property real overshootEnd: rawEndPos > maxPosition ? rawEndPos - maxPosition : 0
    
    // overshoot adjusted start and end
    property real adjStartPos: rawStartPos + overshootStart
    property real adjEndPos: rawEndPos - overshootStart - overshootEnd
    
    // final position and size of thumb
    property int position: 0.5 + (adjStartPos + minSize > maxPosition ? maxPosition - minSize : adjStartPos)
    property int size: 0.5 + ((adjEndPos - position) < minSize ? minSize : (adjEndPos - position))
}

