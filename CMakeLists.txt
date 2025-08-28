cmake_minimum_required(VERSION 3.16)

project(daily_diet VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Quick QuickControls2 Sql Charts)

qt_standard_project_setup(REQUIRES 6.8)

qt_add_executable(appdaily_diet
    main.cpp
    models/mealmodel.cpp
    models/mealmodel.h
    database/mealdatabase.cpp
    database/mealdatabase.h
    resources.qrc
)

qt_add_qml_module(appdaily_diet
    URI daily_diet
    VERSION 1.0
    QML_FILES
        Main.qml
        components/MealCard.qml
        components/AddMealDialog.qml
        components/CalendarView.qml
        components/MealListView.qml
        components/StatsView.qml
        components/MealSection.qml
        components/Card.qml
)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(appdaily_diet PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appdaily_diet
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appdaily_diet
    PRIVATE Qt6::Quick Qt6::QuickControls2 Qt6::Sql Qt6::Charts
)

include(GNUInstallDirs)
install(TARGETS appdaily_diet
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
