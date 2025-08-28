import QtQuick
import QtQuick.Controls.Material

Item {
    id: root
    property color backgroundColor: "#ffffff"
    property color borderColor: Material.Grey[300]
    property int borderWidth: 1
    property int radius: 8
    property int padding: 8

    implicitWidth: Math.max(0, contentItem.implicitWidth + padding * 2)
    implicitHeight: Math.max(0, contentItem.implicitHeight + padding * 2)

    Rectangle {
        id: bg
        anchors.fill: parent
        radius: root.radius
        color: root.backgroundColor
        border.color: root.borderColor
        border.width: root.borderWidth
    }

    Item {
        id: contentItem
        anchors.fill: bg
        anchors.margins: root.padding
    }

    default property alias contentData: contentItem.data
} 