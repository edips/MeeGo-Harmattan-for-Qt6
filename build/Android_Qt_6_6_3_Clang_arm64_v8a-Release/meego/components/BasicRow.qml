import QtQuick
import "BasicRow.js" as Private

/*
  This element should be used in place of the Row element to
  avoid visual artifacts during the relayout operation.

  The QML Row element updates its children position using a
  singleShot, so a paint operation could happen before the items
  are positioned in the right place.

  This element reposition its children immediately to avoid this,
  so it's recommended to be used with just a few elements, since
  it's not optimized.

  This element can be removed when the following bug is solved:
  http://bugreports.qt.nokia.com/browse/QTBUG-18919
*/

Item {
    id: row

    onChildrenChanged: Private.updateChildren();
    Component.onCompleted: Private.updateChildren();
}
