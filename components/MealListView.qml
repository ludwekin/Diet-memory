import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Controls.Material

Rectangle {
    id: root
    color: "transparent"
    
    property var mealList: []
    
    ColumnLayout {
        anchors.fill: parent
        spacing: 16
        
        // 标题和搜索
        RowLayout {
            Layout.fillWidth: true
            Layout.preferredHeight: 50
            
            Label {
                text: qsTr("餐食记录")
                font.pixelSize: 18
                font.bold: true
                Layout.fillWidth: true
            }
            
            TextField {
                id: searchField
                placeholderText: qsTr("搜索餐食...")
                Layout.preferredWidth: 200
                onTextChanged: filterMeals()
            }
        }
        
        // 餐食列表
        ListView {
            id: mealListView
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            spacing: 8
            
            model: ListModel {
                id: mealListModel
            }
            
            delegate: MealCard {
                width: parent.width
                mealData: model
                onDeleteRequested: {
                    mealModel.deleteMeal(model.id)
                    refreshMeals()
                }
            }
            
            // 空状态
            Label {
                text: qsTr("暂无餐食记录")
                color: Material.Grey
                visible: mealListView.count === 0
                anchors.centerIn: parent
            }
        }
    }
    
    // 方法
    function setMealList(meals) {
        mealList = meals
        refreshMeals()
    }
    
    function refreshMeals() {
        mealListModel.clear()
        
        for (let meal of mealList) {
            mealListModel.append({
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
    
    function filterMeals() {
        const searchText = searchField.text.toLowerCase()
        
        if (!searchText) {
            refreshMeals()
            return
        }
        
        mealListModel.clear()
        
        for (let meal of mealList) {
            if (meal.name.toLowerCase().includes(searchText) ||
                meal.notes.toLowerCase().includes(searchText) ||
                meal.mealType.toLowerCase().includes(searchText)) {
                mealListModel.append({
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
    }
} 