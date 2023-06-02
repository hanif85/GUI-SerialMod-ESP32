import QtQuick 2.15
import QtQuick.Controls 2.15

ToolButton {
    property string iconSource
    property string iconSourceDisabled
    property int iconSize: 30
    property int implicitSize: 40
    implicitWidth: implicitSize
    implicitHeight: implicitSize
    padding: 0
    icon.source: enabled?iconSource:iconSourceDisabled
    icon.color: "transparent"
    icon.width: iconSize
    icon.height: iconSize
    ToolTip.delay: Qt.styleHints.mousePressAndHoldInterval
    ToolTip.visible: hovered
}
