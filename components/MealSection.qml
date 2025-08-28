import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Controls.Material

Card {
    id: root
    property string title: ""
    property string mealType: ""
    property date currentDate: new Date()

    Layout.fillWidth: true
    Layout.bottomMargin: 12
    padding: 16

    Column {
        id: contentColumn
        width: parent.width
        spacing: 8

        Row {
            width: parent.width
            spacing: 8

            Label {
                text: root.title
                font.pixelSize: 16
                font.bold: true
            }

            Item { width: 1; Layout.fillWidth: true }

            ToolButton {
                icon.source: "qrc:/images/add.svg"
                text: qsTr("添加")
                onClicked: {
                    if (typeof addMealDialog !== "undefined") {
                        addMealDialog.mealType = root.mealType
                        addMealDialog.open()
                    }
                }
            }
        }

        // 水平图片列表
        Flickable {
            id: flick
            width: parent.width
            height: 96
            contentWidth: rowContent.width
            interactive: rowContent.width > width
            clip: true

            Row {
                id: rowContent
                spacing: 8
                anchors.verticalCenter: parent.verticalCenter

                // 基于 mealModel 过滤当日该餐别
                Repeater {
                    model: mealModel
                    delegate: Item {
                        property bool match: (mealType === root.mealType) && (Qt.formatDate(date, "yyyy-MM-dd") === Qt.formatDate(root.currentDate, "yyyy-MM-dd"))
                        visible: match
                        width: match ? 96 : 0
                        height: 96

                        Rectangle {
                            anchors.fill: parent
                            radius: 8
                            color: Material.Grey[200]

                            Image {
                                anchors.fill: parent
                                anchors.margins: 4
                                source: imagePath && imagePath.length > 0 ? imagePath : "qrc:/images/restaurant.svg"
                                fillMode: Image.PreserveAspectCrop
                                cache: false
                            }
                        }
                    }
                }

                // 空状态
                Item {
                    id: emptySpacer
                    width: (rowContent.children.length <= 1) ? flick.width : 0
                    height: 96

                    Label {
                        anchors.centerIn: parent
                        text: qsTr("暂无图片")
                        color: Material.Grey
                        visible: rowContent.children.length <= 1
                    }
                }
            }
        }
    }

    // 数据加载（确保当天数据已加载）
    Component.onCompleted: mealModel.loadMealsForDate(root.currentDate)
    onCurrentDateChanged: mealModel.loadMealsForDate(root.currentDate)
} 