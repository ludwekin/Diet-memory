# 每日饮食记录应用

一个基于Qt Quick的每日三餐记录软件，支持记录餐食名称、价格、图片和备注，并提供日历查看和统计分析功能。

## 功能特性

### 🍽️ 餐食记录
- 记录三餐（早餐、午餐、晚餐）的详细信息
- 支持餐食名称、价格、图片和备注
- 自动记录日期和时间
- 图片保存和管理

### 📅 日历查看
- 月历视图，直观显示每日餐食
- 餐食类型指示器（不同颜色区分）
- 每日总花费显示
- 点击日期查看详细餐食记录

### 📊 统计分析
- 总餐食数和总花费统计
- 平均每日花费计算
- 按时间范围的详细统计表格
- 支持自定义统计时间范围

### 💾 数据管理
- SQLite数据库存储
- 数据持久化
- 支持增删改查操作

## 技术架构

- **前端**: Qt Quick (QML) + Material Design
- **后端**: C++ + Qt6
- **数据库**: SQLite
- **构建系统**: CMake

## 系统要求

- Qt 6.8 或更高版本
- C++17 兼容的编译器
- CMake 3.16 或更高版本

## 安装和构建

### 1. 克隆项目
```bash
git clone <repository-url>
cd daily_diet
```

### 2. 安装依赖
确保已安装Qt6和相关组件：
- Qt6 Quick
- Qt6 QuickControls2
- Qt6 Sql
- Qt6 Charts

### 3. 构建项目
```bash
# 使用构建脚本
./build.sh

# 或手动构建
mkdir build && cd build
cmake ..
make
```

### 4. 运行应用
```bash
./appdaily_diet
```

## 项目结构

```
daily_diet/
├── CMakeLists.txt          # CMake构建配置
├── main.cpp                # 主程序入口
├── Main.qml                # 主界面
├── components/             # QML组件
│   ├── MealCard.qml       # 餐食卡片
│   ├── AddMealDialog.qml  # 添加餐食对话框
│   ├── CalendarView.qml   # 日历视图
│   ├── StatsView.qml      # 统计视图
│   └── MealListView.qml   # 餐食列表视图
├── models/                 # 数据模型
│   ├── mealmodel.h        # 餐食模型头文件
│   └── mealmodel.cpp      # 餐食模型实现
├── database/               # 数据库层
│   ├── mealdatabase.h     # 数据库操作头文件
│   └── mealdatabase.cpp   # 数据库操作实现
├── images/                 # 图片资源
└── build.sh               # 构建脚本
```

## 使用说明

### 添加餐食
1. 点击主界面右下角的"+"按钮
2. 填写餐食名称、选择类型、输入价格
3. 选择日期和时间
4. 可选择添加图片和备注
5. 点击"确定"保存

### 查看日历
1. 点击主界面右上角的"日历"按钮
2. 在日历视图中浏览不同月份
3. 点击日期查看该日的餐食记录
4. 使用左右箭头切换月份

### 查看统计
1. 点击主界面右上角的"统计"按钮
2. 选择统计时间范围
3. 查看总览数据和详细统计表格

## 开发说明

### 添加新功能
1. 在相应的QML文件中添加UI组件
2. 在C++模型中添加数据操作方法
3. 更新数据库结构（如需要）
4. 在CMakeLists.txt中添加新文件

### 自定义样式
- 修改Material主题颜色
- 调整组件布局和间距
- 添加自定义图标和图片

## 贡献指南

欢迎提交Issue和Pull Request来改进这个项目！

## 许可证

本项目采用MIT许可证，详见LICENSE文件。

## 联系方式

如有问题或建议，请通过以下方式联系：
- 提交GitHub Issue
- 发送邮件至：[welfarewangyifei@gmail.com]

---

**注意**: 首次运行时会自动创建数据库文件，请确保应用有写入权限。 
