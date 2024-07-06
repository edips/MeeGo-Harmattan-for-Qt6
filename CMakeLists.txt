cmake_minimum_required(VERSION 3.16)
set(CMAKE_AUTORCC ON)
project(meego VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 6.4 REQUIRED COMPONENTS Quick)

qt_standard_project_setup()

qt_add_executable(appmeego
    main.cpp
)

qt_add_qml_module(appmeego
    URI meego
    VERSION 1.0
    QML_FILES
        Main.qml
        QML_FILES components/PageStackWindow.qml components/PageStackWindowStyle.qml components/SoftwareInputPanel.qml components/StatusBar.qml components/StatusBarStyle.qml components/TabBarLayout.qml components/ToolBar.qml components/ToolBarLayout.js components/ToolBarLayout.qml components/ToolBarStyle.qml components/Window2.qml components/WindowStyle.qml
        QML_FILES components/UIConstants.js
        QML_FILES components/Page.qml
        QML_FILES components/Style.qml
        QML_FILES components/InfoBanner.qml components/constants.js
        QML_FILES components/PageStack.js components/PageStack.qml
        RESOURCES images.qrc
        QML_FILES components/Button.qml components/ButtonStyle.qml
        QML_FILES components/LabelStyle.qml components/Label.qml
)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(appmeego PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appmeego
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appmeego
    PRIVATE Qt6::Quick
)

include(GNUInstallDirs)
install(TARGETS appmeego
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
