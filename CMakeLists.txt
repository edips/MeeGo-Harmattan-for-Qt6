cmake_minimum_required(VERSION 3.16)
project(meego VERSION 0.1 LANGUAGES CXX)

include(GNUInstallDirs)
include(FetchContent)
set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_INCLUDE_CURRENT_DIR ON)

find_package(Qt6 6.4 REQUIRED COMPONENTS Quick Svg)
qt_standard_project_setup(REQUIRES 6.6)

set(HEADERS

)

set(HEADERS
    #mDeclarativeImageprovider.h
    mDialogStatus.h
    mScrollDecoratorSizer.h
    mDeclarativeScreen.h
    mPageStatus.h
    mPageOrientation.h
    MLocaleWrapper.h
    mDeclarativeImObserver.h
    mDeclarativeMouseFilter.h
    mInverseMouseArea.h
    models/qRangeModel.h
    models/qRangeModel_p.h
    #themedaemon/mAbstractThemeDaemonClient.h
    #themedaemon/mLocalThemeDaemonClient.h
    #themedaemon/mRemoteThemeDaemonClient.h
    #themedaemon/mThemeDaemonProtocol.h
    #mThemePlugin.h
)

set(SOURCES
    main.cpp
    mDeclarativeImObserver.cpp
    mInverseMouseArea.cpp
    mDeclarativeMouseFilter.cpp
    #mDeclarativeImageprovider.cpp
    mDeclarativeScreen.cpp
    mScrollDecoratorSizer.cpp
    models/qRangeModel.cpp
    #themedaemon/mAbstractThemeDaemonClient.cpp
    #themedaemon/mLocalThemeDaemonClient.cpp
    #themedaemon/mRemoteThemeDaemonClient.cpp
    #themedaemon/mThemeDaemonProtocol.cpp
    #mThemePlugin.cpp
)

qt_add_executable(appmeego
    ${SOURCES}
    ${HEADERS}
)

set(QML_SOURCES
    Main.qml
    components/Dialog.qml
    components/DialogStyle.qml
    components/PageStackWindow.qml
    components/ToolItemStyle.qml
    components/ToolItem.qml
    components/PageStackWindowStyle.qml
    components/SoftwareInputPanel.qml
    components/ToolIcon.qml
    components/StatusBar.qml
    components/StatusBarStyle.qml
    components/TabBarLayout.qml
    components/ToolBar.qml
    components/ToolBarLayout.js
    components/ToolBarLayout.qml
    components/ToolBarStyle.qml
    components/Window2.qml
    components/WindowStyle.qml
    components/Fader.qml
    components/Popup.qml
    components/ButtonColumn.qml
    components/ButtonRow.qml
    components/ButtonGroup.js
    components/QueryDialogStyle.qml
    components/QueryDialog.qml
    components/ScrollDecorator.qml
    components/ScrollDecoratorSizer.qml
    components/ScrollDecoratorStyle.qml
    components/SectionScroller.js
    components/SelectionDialog.qml
    components/SelectionDialogStyle.qml
    components/SectionScroller.qml
    components/SectionScrollerLabel.qml
    components/SectionScrollerStyle.qml
    components/CommonDialog.qml
    components/UIConstants.js
    components/Button.qml
    components/ButtonStyle.qml
    components/LabelStyle.qml
    components/Label.qml
    components/Page.qml
    components/Style.qml
    components/InfoBanner.qml
    components/constants.js
    components/PageStack.js
    components/PageStack.qml
    components/TabButton.qml
    components/TabGroup.qml
    components/TabButtonStyle.qml
    components/Menu.qml
    components/MenuItem.qml
    components/MenuLayout.qml
    components/AbstractMenu.qml
    components/MenuItemStyle.qml
    components/MenuStyle.qml
    components/ToolButton.qml
    components/ToolButtonRow.qml
    components/ToolButtonStyle.qml
    components/SelectionHandles.js
    components/Utils.js
    components/EditBubble.js
    components/EditBubble.qml
    components/TextAreaHelper.js
    components/TextField.qml
    components/EditBubbleStyle.qml
    components/EditBubbleButton.qml
    components/TextFieldStyle.qml
    components/BasicRow.js
    components/BasicRow.qml
    components/NotificationBanner.qml
    components/Magnifier.js
    components/Slider.qml
    components/SliderStyle.qml
    components/SliderTemplate.qml
    components/EditBubbleButtonStyle.qml
)



# This is the only requirement to mark a QML file as a singleton.
#set_source_files_properties(Global.qml PROPERTIES
#    QT_QML_SINGLETON_TYPE TRUE
#)
#set_source_files_properties(components/FUnits.qml PROPERTIES
#    QT_QML_SINGLETON_TYPE TRUE
#)


qt_add_qml_module(appmeego
    URI ${PROJECT_NAME}
    VERSION 1.0
    NO_RESOURCE_TARGET_PATH
    IMPORTS
        QtQml
        QtQuick
    IMPORT_PATH
        ${PROJECT_BINARY_DIR}
    QML_FILES
        ${QML_SOURCES}
    RESOURCES images.qrc
)





target_compile_definitions(appmeego
    PRIVATE
    $<$<OR:$<CONFIG:Debug>,$<CONFIG:RelWithDebInfo>>:QT_QML_DEBUG>
)
target_link_libraries(appmeego
    PRIVATE
    Qt6::Quick
    Qt::Svg
)

include(GNUInstallDirs)
install(TARGETS appmeego
    RUNTIME DESTINATION "${CMAKE_INSTALL_BINDIR}"
    BUNDLE DESTINATION "."
    LIBRARY DESTINATION "${CMAKE_INSTALL_LIBDIR}"
)


# Enable Android support
if(ANDROID)
    set(CMAKE_ANDROID_ARCH_ABI arm64-v8a)
endif()
