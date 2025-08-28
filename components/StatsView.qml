import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Controls.Material

Rectangle {
    id: root
    color: "transparent"
    
    property date startDate: new Date(new Date().getFullYear(), new Date().getMonth(), 1)
    property date endDate: new Date()
    
    ColumnLayout {
        anchors.fill: parent
        spacing: 16
        
        // 时间范围选择
        Card {
            Layout.fillWidth: true
            Layout.preferredHeight: 80
            
            RowLayout {
                anchors.fill: parent
                anchors.margins: 16
                spacing: 16
                
                Label {
                    text: qsTr("统计时间范围:")
                    font.pixelSize: 14
                }
                
                TextField {
                    id: startDateField
                    text: startDate.toLocaleDateString(Qt.locale(), "yyyy-MM-dd")
                    readOnly: true
                    Layout.preferredWidth: 120
                }
                
                Label {
                    text: qsTr("至")
                }
                
                TextField {
                    id: endDateField
                    text: endDate.toLocaleDateString(Qt.locale(), "yyyy-MM-dd")
                    readOnly: true
                    Layout.preferredWidth: 120
                }
                
                Item { Layout.fillWidth: true }
                
                Button {
                    text: qsTr("刷新统计")
                    onClicked: refreshStats()
                }
            }
        }
        
        // 总览卡片
        RowLayout {
            Layout.fillWidth: true
            spacing: 16
            
            // 总餐食数
            Card {
                Layout.fillWidth: true
                Layout.preferredHeight: 100
                
                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 16
                    spacing: 8
                    
                    Image {
                        source: "qrc:/images/restaurant.svg"
                        sourceSize.width: 32
                        sourceSize.height: 32
                        fillMode: Image.PreserveAspectFit
                        Layout.alignment: Qt.AlignHCenter
                    }
                    
                    Label {
                        text: qsTr("总餐食数")
                        font.pixelSize: 12
                        color: Material.Grey[600]
                        Layout.alignment: Qt.AlignHCenter
                    }
                    
                    Label {
                        id: totalMealsLabel
                        text: "0"
                        font.pixelSize: 24
                        font.bold: true
                        color: Material.Blue
                        Layout.alignment: Qt.AlignHCenter
                    }
                }
            }
            
            // 总花费
            Card {
                Layout.fillWidth: true
                Layout.preferredHeight: 100
                
                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 16
                    spacing: 8
                    
                    Image {
                        source: "qrc:/images/payments.svg"
                        sourceSize.width: 32
                        sourceSize.height: 32
                        fillMode: Image.PreserveAspectFit
                        Layout.alignment: Qt.AlignHCenter
                    }
                    
                    Label {
                        text: qsTr("总花费")
                        font.pixelSize: 12
                        color: Material.Grey[600]
                        Layout.alignment: Qt.AlignHCenter
                    }
                    
                    Label {
                        id: totalSpentLabel
                        text: "¥0.00"
                        font.pixelSize: 24
                        font.bold: true
                        color: Material.Green
                        Layout.alignment: Qt.AlignHCenter
                    }
                }
            }
            
            // 平均每日花费
            Card {
                Layout.fillWidth: true
                Layout.preferredHeight: 100
                
                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 16
                    spacing: 8
                    
                    Image {
                        source: "qrc:/images/trending_up.svg"
                        sourceSize.width: 32
                        sourceSize.height: 32
                        fillMode: Image.PreserveAspectFit
                        Layout.alignment: Qt.AlignHCenter
                    }
                    
                    Label {
                        text: qsTr("日均花费")
                        font.pixelSize: 12
                        color: Material.Grey[600]
                        Layout.alignment: Qt.AlignHCenter
                    }
                    
                    Label {
                        id: avgDailySpentLabel
                        text: "¥0.00"
                        font.pixelSize: 24
                        font.bold: true
                        color: Material.Orange
                        Layout.alignment: Qt.AlignHCenter
                    }
                }
            }
        }
        
        // 详细统计表格
        Card {
            Layout.fillWidth: true
            Layout.fillHeight: true
            
            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 16
                spacing: 8
                
                Label {
                    text: qsTr("详细统计")
                    font.pixelSize: 16
                    font.bold: true
                }
                
                ListView {
                    id: statsListView
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    clip: true
                    model: ListModel {
                        id: statsModel
                    }
                    
                    delegate: Rectangle {
                        width: parent.width
                        height: 40
                        color: index % 2 === 0 ? Material.Grey[50] : "white"
                        
                        RowLayout {
                            anchors.fill: parent
                            anchors.margins: 8
                            spacing: 16
                            
                            Label {
                                text: model.date
                                Layout.preferredWidth: 100
                                font.pixelSize: 12
                            }
                            
                            Label {
                                text: model.breakfast
                                Layout.preferredWidth: 60
                                font.pixelSize: 12
                                horizontalAlignment: Text.AlignHCenter
                            }
                            
                            Label {
                                text: model.lunch
                                Layout.preferredWidth: 60
                                font.pixelSize: 12
                                horizontalAlignment: Text.AlignHCenter
                            }
                            
                            Label {
                                text: model.dinner
                                Layout.preferredWidth: 60
                                font.pixelSize: 12
                                horizontalAlignment: Text.AlignHCenter
                            }
                            
                            Label {
                                text: "¥" + model.total.toFixed(2)
                                Layout.preferredWidth: 80
                                font.pixelSize: 12
                                font.bold: true
                                color: Material.Green
                                horizontalAlignment: Text.AlignRight
                            }
                        }
                    }
                    
                    // 表头
                    header: Rectangle {
                        width: parent.width
                        height: 40
                        color: Material.Grey[200]
                        
                        RowLayout {
                            anchors.fill: parent
                            anchors.margins: 8
                            spacing: 16
                            
                            Label {
                                text: qsTr("日期")
                                Layout.preferredWidth: 100
                                font.pixelSize: 12
                                font.bold: true
                            }
                            
                            Label {
                                text: qsTr("早餐")
                                Layout.preferredWidth: 60
                                font.pixelSize: 12
                                font.bold: true
                                horizontalAlignment: Text.AlignHCenter
                            }
                            
                            Label {
                                text: qsTr("午餐")
                                Layout.preferredWidth: 60
                                font.pixelSize: 12
                                font.bold: true
                                horizontalAlignment: Text.AlignHCenter
                            }
                            
                            Label {
                                text: qsTr("晚餐")
                                Layout.preferredWidth: 60
                                font.pixelSize: 12
                                font.bold: true
                                horizontalAlignment: Text.AlignHCenter
                            }
                            
                            Label {
                                text: qsTr("总花费")
                                Layout.preferredWidth: 80
                                font.pixelSize: 12
                                font.bold: true
                                horizontalAlignment: Text.AlignRight
                            }
                        }
                    }
                }
            }
        }
    }
    
    // 方法
    function refreshStats() {
        updateOverview()
        updateStatsTable()
    }
    
    function updateOverview() {
        const meals = mealModel.getMealsByDateRange(startDate, endDate)
        const totalSpent = mealModel.getTotalSpentForDateRange(startDate, endDate)
        const daysDiff = Math.ceil((endDate - startDate) / (1000 * 60 * 60 * 24)) + 1
        
        totalMealsLabel.text = meals.length
        totalSpentLabel.text = "¥" + totalSpent.toFixed(2)
        avgDailySpentLabel.text = "¥" + (totalSpent / daysDiff).toFixed(2)
    }
    
    function updateStatsTable() {
        statsModel.clear()
        
        const currentDate = new Date(startDate)
        
        while (currentDate <= endDate) {
            const meals = mealModel.getMealsByDate(currentDate)
            const typeCount = { breakfast: 0, lunch: 0, dinner: 0 }
            let total = 0
            
            for (let meal of meals) {
                if (typeCount[meal.mealType] !== undefined) {
                    typeCount[meal.mealType]++
                    total += meal.price
                }
            }
            
            statsModel.append({
                date: currentDate.toLocaleDateString(Qt.locale(), "MM-dd"),
                breakfast: typeCount.breakfast,
                lunch: typeCount.lunch,
                dinner: typeCount.dinner,
                total: total
            })
            
            currentDate.setDate(currentDate.getDate() + 1)
        }
    }
    
    // 初始化
    Component.onCompleted: {
        refreshStats()
    }
} 