import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Controls.Material

ApplicationWindow {
    id: window
    width: 800
    height: 600
    visible: true
    title: qsTr("每日饮食记录")
    
    Material.theme: Material.Light
    Material.accent: Material.Green
    
    property date currentDate: new Date()
    property string currentDateString: currentDate.toLocaleDateString(Qt.locale(), "yyyy年MM月dd日")
    
    // 主内容区域
    StackView {
        id: stackView
        anchors.fill: parent
        initialItem: mainPage
    }
    
    // 主页面
    Component {
        id: mainPage
        
        Page {
            id: page
            
            header: ToolBar {
                RowLayout {
                    anchors.fill: parent
                    
                    Label {
                        text: currentDateString
                        font.pixelSize: 18
                        font.bold: true
                        Layout.fillWidth: true
                    }
                    
                    ToolButton {
                        icon.source: "qrc:/images/calendar.svg"
                        text: qsTr("日历")
                        onClicked: stackView.push(calendarView)
                    }
                    
                    ToolButton {
                        icon.source: "qrc:/images/stats.svg"
                        text: qsTr("统计")
                        onClicked: stackView.push(statsView)
                    }
                }
            }
            
            // 主滚动区：只使用一个滚动容器
            ScrollView {
                id: scroller
                anchors.fill: parent
                
                contentItem: Column {
                    id: content
                    width: scroller.width
                    spacing: 16
                    padding: 16
                    
                    // 今日总花费
                    Card {
                        width: parent.width
                        RowLayout {
                            anchors.fill: parent
                            anchors.margins: 16
                            
                            Image {
                                source: "qrc:/images/payments.svg"
                                sourceSize.width: 32
                                sourceSize.height: 32
                            }
                            
                            ColumnLayout {
                                Label {
                                    text: qsTr("今日总花费")
                                    font.pixelSize: 14
                                    color: Material.Grey
                                }
                                
                                Label {
                                    text: "¥" + mealModel.getTotalSpentForDate(currentDate).toFixed(2)
                                    font.pixelSize: 24
                                    font.bold: true
                                    color: Material.Green
                                }
                            }
                            
                            Item { Layout.fillWidth: true }
                        }
                    }
                    
                    // 三餐三行（每行显示图片）
                    MealSection {
                        width: parent.width
                        title: qsTr("早餐")
                        mealType: "breakfast"
                        currentDate: window.currentDate
                    }
                    MealSection {
                        width: parent.width
                        title: qsTr("午餐")
                        mealType: "lunch"
                        currentDate: window.currentDate
                    }
                    MealSection {
                        width: parent.width
                        title: qsTr("晚餐")
                        mealType: "dinner"
                        currentDate: window.currentDate
                    }
                    
                    // 底部留白，避免FAB遮挡
                    Rectangle { width: parent.width; height: 80; color: "transparent" }
                }
            }
            
            // 悬浮添加按钮（不在ScrollView内）
            RoundButton {
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                anchors.margins: 16
                width: 56
                height: 56
                radius: 28
                text: ""
                background: Rectangle {
                    anchors.fill: parent
                    radius: parent.radius
                    color: Material.Green
                    border.width: 0
                    layer.enabled: false
                }
                contentItem: Item {
                    anchors.centerIn: parent
                    Image {
                        anchors.centerIn: parent
                        source: "qrc:/images/add.svg"
                        sourceSize.width: 24
                        sourceSize.height: 24
                    }
                }
                onClicked: addMealDialog.open()
            }
        }
    }
    
    // 日历视图
    Component {
        id: calendarView
        
        Page {
            header: ToolBar {
                ToolButton {
                    icon.source: "qrc:/images/back.svg"
                    text: qsTr("返回")
                    onClicked: stackView.pop()
                }
                
                Label {
                    text: qsTr("日历视图")
                    Layout.fillWidth: true
                    horizontalAlignment: Text.AlignHCenter
                }
            }
            
            CalendarView {
                anchors.fill: parent
                anchors.margins: 16
            }
        }
    }
    
    // 统计视图
    Component {
        id: statsView
        
        Page {
            header: ToolBar {
                ToolButton {
                    icon.source: "qrc:/images/back.svg"
                    text: qsTr("返回")
                    onClicked: stackView.pop()
                }
                
                Label {
                    text: qsTr("统计视图")
                    Layout.fillWidth: true
                    horizontalAlignment: Text.AlignHCenter
                }
            }
            
            StatsView {
                anchors.fill: parent
                anchors.margins: 16
            }
        }
    }
    
    // 添加餐食对话框
    AddMealDialog {
        id: addMealDialog
        onMealAdded: {
            mealModel.loadMealsForDate(window.currentDate)
        }
    }
}
