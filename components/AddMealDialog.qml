import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Controls.Material
import QtQuick.Dialogs

Dialog {
    id: root
    title: qsTr("添加餐食")
    modal: true
    width: 500
    height: 600
    
    property string mealType: "breakfast"
    signal mealAdded()
    
    standardButtons: Dialog.Ok | Dialog.Cancel
    
    onAccepted: {
        if (validateForm()) {
            addMeal()
        }
    }
    
    onRejected: {
        clearForm()
    }
    
    ColumnLayout {
        anchors.fill: parent
        spacing: 16
        
        // 餐食名称
        TextField {
            id: nameField
            placeholderText: qsTr("餐食名称（必填）")
            Layout.fillWidth: true
            maximumLength: 50
        }
        
        // 餐食类型选择
        RowLayout {
            Layout.fillWidth: true
            
            Label {
                text: qsTr("餐食类型:")
                Layout.preferredWidth: 80
            }
            
            ComboBox {
                id: mealTypeCombo
                model: [
                    { text: qsTr("早餐"), value: "breakfast" },
                    { text: qsTr("午餐"), value: "lunch" },
                    { text: qsTr("晚餐"), value: "dinner" }
                ]
                textRole: "text"
                valueRole: "value"
                Layout.fillWidth: true
                
                Component.onCompleted: {
                    // 设置默认值
                    for (let i = 0; i < model.length; i++) {
                        if (model[i].value === root.mealType) {
                            currentIndex = i
                            break
                        }
                    }
                }
            }
        }
        
        // 价格输入
        RowLayout {
            Layout.fillWidth: true
            
            Label {
                text: qsTr("价格:")
                Layout.preferredWidth: 80
            }
            
            TextField {
                id: priceField
                placeholderText: qsTr("0.00")
                inputMethodHints: Qt.ImhFormattedNumbersOnly
                Layout.fillWidth: true
                
                validator: DoubleValidator {
                    bottom: 0.0
                    top: 9999.99
                    decimals: 2
                }
            }
            
            Label {
                text: "¥"
                color: Material.Grey[600]
            }
        }
        
        // 日期时间选择
        RowLayout {
            Layout.fillWidth: true
            
            Label {
                text: qsTr("日期:")
                Layout.preferredWidth: 80
            }
            
            TextField {
                id: dateField
                text: new Date().toLocaleDateString(Qt.locale(), "yyyy-MM-dd")
                Layout.fillWidth: true
                placeholderText: qsTr("yyyy-MM-dd")
            }
            
            Label {
                text: qsTr("时间:")
                Layout.preferredWidth: 60
            }
            
            TextField {
                id: timeField
                text: new Date().toLocaleTimeString(Qt.locale(), "HH:mm")
                Layout.fillWidth: true
                placeholderText: qsTr("HH:mm")
            }
        }
        
        // 图片选择
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 8
            
            Label {
                text: qsTr("餐食图片:")
            }
            
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 120
                border.color: Material.Grey[400]
                border.width: 1
                radius: 8
                
                Image {
                    id: mealImage
                    anchors.fill: parent
                    anchors.margins: 8
                    source: imagePath
                    fillMode: Image.PreserveAspectFit
                    cache: false
                    
                    // 默认图标
                    Rectangle {
                        anchors.fill: parent
                        color: Material.Grey[200]
                        visible: !mealImage.source || mealImage.status !== Image.Ready
                        
                        ColumnLayout {
                            anchors.centerIn: parent
                            spacing: 8
                            
                            Image {
                                source: "qrc:/images/add_photo_alternate.svg"
                                sourceSize.width: 32
                                sourceSize.height: 32
                                fillMode: Image.PreserveAspectFit
                                Layout.alignment: Qt.AlignHCenter
                            }
                            
                            Label {
                                text: qsTr("点击选择图片")
                                color: Material.Grey[600]
                                Layout.alignment: Qt.AlignHCenter
                            }
                        }
                    }
                }
                
                MouseArea {
                    anchors.fill: parent
                    onClicked: fileDialog.open()
                }
            }
        }
        
        // 备注输入
        TextArea {
            id: notesField
            placeholderText: qsTr("备注（可选）")
            Layout.fillWidth: true
            Layout.fillHeight: true
            wrapMode: TextArea.Wrap
        }
        
        // 图片文件对话框
        FileDialog {
            id: fileDialog
            title: qsTr("选择餐食图片")
            nameFilters: ["图片文件 (*.png *.jpg *.jpeg *.bmp *.gif)"]
            onAccepted: {
                imagePath = selectedFile
            }
        }
        
        // 移除平台不一定可用的日期/时间选择器，改为手动输入并校验
    }
    
    // 属性
    property string imagePath: ""
    
    // 方法
    function validateForm() {
        if (!nameField.text.trim()) {
            showError(qsTr("请输入餐食名称"))
            return false
        }
        
        if (!priceField.text || parseFloat(priceField.text) <= 0) {
            showError(qsTr("请输入有效的价格"))
            return false
        }
        
        return true
    }
    
    function addMeal() {
        const name = nameField.text.trim()
        const mealType = mealTypeCombo.currentValue
        const price = parseFloat(priceField.text)
        const dateTime = new Date(dateField.text + "T" + timeField.text)
        const notes = notesField.text.trim()
        
        // 调用C++模型添加餐食
        mealModel.addMeal(name, mealType, price, imagePath, dateTime, notes)
        
        // 发送信号
        root.mealAdded()
        
        // 清空表单
        clearForm()
    }
    
    function clearForm() {
        nameField.text = ""
        priceField.text = ""
        dateField.text = new Date().toLocaleDateString(Qt.locale(), "yyyy-MM-dd")
        timeField.text = new Date().toLocaleTimeString(Qt.locale(), "HH:mm")
        notesField.text = ""
        imagePath = ""
        mealTypeCombo.currentIndex = 0
    }
    
    function showError(message) {
        errorDialog.text = message
        errorDialog.open()
    }
    
    // 错误提示对话框
    Dialog {
        id: errorDialog
        title: qsTr("错误")
        modal: true
        standardButtons: Dialog.Ok
        
        property string text: ""
        
        Label {
            text: errorDialog.text
        }
    }
}
 