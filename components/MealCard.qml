import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Controls.Material

Card {
    id: root
    property var mealData: ({})
    signal deleteRequested()
    
    Layout.fillWidth: true
    Layout.preferredHeight: 120
    
    RowLayout {
        anchors.fill: parent
        anchors.margins: 12
        spacing: 12
        
        // 餐食图片
        Rectangle {
            Layout.preferredWidth: 80
            Layout.preferredHeight: 80
            radius: 8
            color: Material.Grey[200]
            
            Image {
                id: mealImage
                anchors.fill: parent
                anchors.margins: 4
                source: root.mealData.imagePath || ""
                fillMode: Image.PreserveAspectCrop
                cache: false
                
                // 默认图标
                Rectangle {
                    anchors.fill: parent
                    color: Material.Grey[300]
                    visible: !mealImage.source || mealImage.status !== Image.Ready
                    
                    Image {
                        anchors.centerIn: parent
                        source: "qrc:/images/restaurant.svg"
                        sourceSize.width: 32
                        sourceSize.height: 32
                        fillMode: Image.PreserveAspectFit
                    }
                }
            }
        }
        
        // 餐食信息
        ColumnLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 4
            
            RowLayout {
                Layout.fillWidth: true
                
                Label {
                    text: root.mealData.name || qsTr("未命名餐食")
                    font.pixelSize: 16
                    font.bold: true
                    Layout.fillWidth: true
                }
                
                Label {
                    text: "¥" + (root.mealData.price || 0).toFixed(2)
                    font.pixelSize: 18
                    font.bold: true
                    color: Material.Green
                }
            }
            
            RowLayout {
                Layout.fillWidth: true
                
                Label {
                    text: getMealTypeText(root.mealData.mealType)
                    font.pixelSize: 12
                    color: Material.Grey[600]
                    background: Rectangle {
                        color: getMealTypeColor(root.mealData.mealType)
                        opacity: 0.2
                        radius: 4
                    }
                    padding: 4
                }
                
                Item { Layout.fillWidth: true }
                
                Label {
                    text: root.mealData.time || ""
                    font.pixelSize: 12
                    color: Material.Grey[600]
                }
            }
            
            Label {
                text: root.mealData.notes || ""
                font.pixelSize: 12
                color: Material.Grey[600]
                visible: root.mealData.notes && root.mealData.notes.length > 0
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                maximumLineCount: 2
                elide: Text.ElideRight
            }
            
            Item { Layout.fillHeight: true }
        }
        
        // 操作按钮
        ColumnLayout {
            spacing: 4
            
            ToolButton {
                icon.source: "qrc:/images/edit.svg"
                text: qsTr("编辑")
                onClicked: {
                    // TODO: 实现编辑功能
                }
            }
            
            ToolButton {
                icon.source: "qrc:/images/delete.svg"
                text: qsTr("删除")
                onClicked: {
                    deleteDialog.open()
                }
            }
        }
    }
    
    // 删除确认对话框
    Dialog {
        id: deleteDialog
        title: qsTr("确认删除")
        modal: true
        standardButtons: Dialog.Yes | Dialog.No
        
        Label {
            text: qsTr("确定要删除这个餐食记录吗？")
        }
        
        onAccepted: {
            root.deleteRequested()
        }
    }
    
    // 辅助函数
    function getMealTypeText(type) {
        switch(type) {
            case "breakfast": return qsTr("早餐")
            case "lunch": return qsTr("午餐")
            case "dinner": return qsTr("晚餐")
            default: return qsTr("其他")
        }
    }
    
    function getMealTypeColor(type) {
        switch(type) {
            case "breakfast": return Material.Orange
            case "lunch": return Material.Green
            case "dinner": return Material.Blue
            default: return Material.Grey
        }
    }
} 