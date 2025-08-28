import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Controls.Material

Rectangle {
    id: root
    color: "transparent"
    
    property date selectedDate: new Date()
    property int currentMonth: selectedDate.getMonth()
    property int currentYear: selectedDate.getFullYear()
    
    ColumnLayout {
        anchors.fill: parent
        spacing: 16
        
        // 月份导航
        RowLayout {
            Layout.fillWidth: true
            Layout.preferredHeight: 50
            
            ToolButton {
                icon.source: "qrc:/images/chevron_left.png"
                text: qsTr("上月")
                onClicked: previousMonth()
            }
            
            Label {
                text: getMonthYearText()
                font.pixelSize: 20
                font.bold: true
                Layout.fillWidth: true
                horizontalAlignment: Text.AlignHCenter
            }
            
            ToolButton {
                icon.source: "qrc:/images/chevron_right.png"
                text: qsTr("下月")
                onClicked: nextMonth()
            }
        }
        
        // 星期标题
        RowLayout {
            Layout.fillWidth: true
            Layout.preferredHeight: 40
            
            Repeater {
                model: ["日", "一", "二", "三", "四", "五", "六"]
                
                Label {
                    text: modelData
                    font.pixelSize: 14
                    font.bold: true
                    color: Material.Grey[600]
                    Layout.fillWidth: true
                    horizontalAlignment: Text.AlignHCenter
                }
            }
        }
        
        // 日历网格
        GridLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            columns: 7
            rowSpacing: 4
            columnSpacing: 4
            
            Repeater {
                model: getDaysInMonth()
                
                Rectangle {
                    id: dayRect
                    property date dayDate: getDateForIndex(index)
                    property bool isCurrentMonth: dayDate.getMonth() === currentMonth
                    property bool isToday: dayDate.toDateString() === new Date().toDateString()
                    property bool isSelected: dayDate.toDateString() === selectedDate.toDateString()
                    
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Layout.minimumHeight: 60
                    Layout.minimumWidth: 80
                    
                    color: {
                        if (isSelected) return Material.Green[100]
                        if (isToday) return Material.Blue[50]
                        if (isCurrentMonth) return "white"
                        return Material.Grey[100]
                    }
                    
                    border.color: {
                        if (isSelected) return Material.Green
                        if (isToday) return Material.Blue
                        return Material.Grey[300]
                    }
                    border.width: isSelected || isToday ? 2 : 1
                    radius: 8
                    
                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 4
                        spacing: 2
                        
                        // 日期
                        Label {
                            text: dayDate.getDate()
                            font.pixelSize: 14
                            font.bold: isToday || isSelected
                            color: {
                                if (!isCurrentMonth) return Material.Grey[400]
                                if (isToday || isSelected) return Material.Green[800]
                                return "black"
                            }
                            Layout.alignment: Qt.AlignHCenter
                        }
                        
                        // 餐食指示器
                        RowLayout {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 16
                            spacing: 2
                            
                            Repeater {
                                model: getMealIndicators(dayDate)
                                
                                Rectangle {
                                    Layout.preferredWidth: 8
                                    Layout.preferredHeight: 8
                                    radius: 4
                                    color: getMealTypeColor(modelData)
                                }
                            }
                            
                            Item { Layout.fillWidth: true }
                        }
                        
                        // 花费
                        Label {
                            text: "¥" + getTotalSpentForDay(dayDate).toFixed(0)
                            font.pixelSize: 10
                            color: Material.Grey[600]
                            visible: getTotalSpentForDay(dayDate) > 0
                            Layout.alignment: Qt.AlignHCenter
                        }
                        
                        Item { Layout.fillHeight: true }
                    }
                    
                    MouseArea {
                        anchors.fill: parent
                        enabled: isCurrentMonth
                        onClicked: {
                            selectedDate = dayDate
                            showDayDetails()
                        }
                    }
                }
            }
        }
        
        // 选中日期的餐食列表
        Card {
            Layout.fillWidth: true
            Layout.preferredHeight: 200
            visible: true
            
            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 16
                spacing: 8
                
                RowLayout {
                    Layout.fillWidth: true
                    
                    Label {
                        text: selectedDate.toLocaleDateString(Qt.locale(), "yyyy年MM月dd日") + qsTr("的餐食")
                        font.pixelSize: 16
                        font.bold: true
                    }
                    
                    Item { Layout.fillWidth: true }
                    
                    Label {
                        text: "总花费: ¥" + getTotalSpentForDay(selectedDate).toFixed(2)
                        font.pixelSize: 14
                        color: Material.Green
                    }
                }
                
                ListView {
                    id: dayMealsListView
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    clip: true
                    model: ListModel {
                        id: dayMealsModel
                    }
                    
                    delegate: MealCard {
                        width: parent.width
                        mealData: model
                        onDeleteRequested: {
                            dayMealsModel.remove(index)
                            refreshDayMeals()
                        }
                    }
                    
                    // 空状态
                    Label {
                        text: qsTr("该日暂无餐食记录")
                        color: Material.Grey
                        visible: dayMealsListView.count === 0
                        anchors.centerIn: parent
                    }
                }
            }
        }
    }
    
    // 方法
    function getMonthYearText() {
        const monthNames = ["一月", "二月", "三月", "四月", "五月", "六月",
                           "七月", "八月", "九月", "十月", "十一月", "十二月"]
        return monthNames[currentMonth] + " " + currentYear
    }
    
    function getDaysInMonth() {
        const firstDay = new Date(currentYear, currentMonth, 1)
        const lastDay = new Date(currentYear, currentMonth + 1, 0)
        const daysInMonth = lastDay.getDate()
        const firstDayOfWeek = firstDay.getDay()
        
        // 返回42个格子（6行7列）
        return 42
    }
    
    function getDateForIndex(index) {
        const firstDay = new Date(currentYear, currentMonth, 1)
        const firstDayOfWeek = firstDay.getDay()
        const offset = index - firstDayOfWeek
        return new Date(currentYear, currentMonth, offset + 1)
    }
    
    function previousMonth() {
        if (currentMonth === 0) {
            currentMonth = 11
            currentYear--
        } else {
            currentMonth--
        }
        updateCalendar()
    }
    
    function nextMonth() {
        if (currentMonth === 11) {
            currentMonth = 0
            currentYear++
        } else {
            currentMonth++
        }
        updateCalendar()
    }
    
    function updateCalendar() {
        // 触发重新计算
        selectedDate = new Date(currentYear, currentMonth, 1)
    }
    
    function getMealIndicators(date) {
        const meals = mealModel.getMealsByDate(date)
        const indicators = []
        
        for (let meal of meals) {
            if (!indicators.includes(meal.mealType)) {
                indicators.push(meal.mealType)
            }
        }
        
        return indicators
    }
    
    function getMealTypeColor(mealType) {
        switch(mealType) {
            case "breakfast": return Material.Orange
            case "lunch": return Material.Green
            case "dinner": return Material.Blue
            default: return Material.Grey
        }
    }
    
    function getTotalSpentForDay(date) {
        return mealModel.getTotalSpentForDate(date)
    }
    
    function showDayDetails() {
        refreshDayMeals()
    }
    
    function refreshDayMeals() {
        dayMealsModel.clear()
        const meals = mealModel.getMealsByDate(selectedDate)
        
        for (let meal of meals) {
            dayMealsModel.append({
                id: meal.id,
                name: meal.name,
                mealType: meal.mealType,
                price: meal.price,
                imagePath: meal.imagePath,
                dateTime: meal.dateTime,
                notes: meal.notes,
                date: meal.dateTime.toLocaleDateString(Qt.locale(), "yyyy-MM-dd"),
                time: meal.dateTime.toLocaleTimeString(Qt.locale(), "HH:mm")
            })
        }
    }
    
    // 初始化
    Component.onCompleted: {
        refreshDayMeals()
    }
} 