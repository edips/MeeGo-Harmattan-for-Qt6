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

find_package(Qt6 6.6 REQUIRED COMPONENTS Quick Svg)
qt_standard_project_setup(REQUIRES 6.6)

set(HEADERS
    mDialogStatus.h
    mScrollDecoratorSizer.h
    mDeclarativeScreen.h
    mPageStatus.h
    mPageOrientation.h
    mDeclarativeImObserver.h
    mDeclarativeMouseFilter.h
    mInverseMouseArea.h
    models/qRangeModel.h
    models/qRangeModel_p.h
    mOrientationHelper.h
    mWindowState.h
    mWindowState_p.h
    mDeclarativeInputContext.h
    androidViewControl.h
    mdatetimehelper.h
    mtoolbarvisibility.h
    mdeclarativemaskeditem.h
    globalsettings.h
    device.h
)
set(SOURCES
    main.cpp
    mDeclarativeImObserver.cpp
    mInverseMouseArea.cpp
    mOrientationHelper.cpp
    mDeclarativeMouseFilter.cpp
    mDeclarativeScreen.cpp
    mScrollDecoratorSizer.cpp
    models/qRangeModel.cpp
    mWindowState.cpp
    androidViewControl.cpp
    mDeclarativeInputContext.cpp
    mdatetimehelper.cpp
    mdeclarativemaskeditem.cpp
    globalsettings.cpp
    device.cpp
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
    components/TabBarLayout.qml
    components/ToolBar.qml
    components/ToolBarLayout.js
    components/ToolBarLayout.qml
    components/ToolBarStyle.qml
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
    components/Utils.js
    components/TextAreaHelper.js
    components/TextField.qml
    components/TextFieldStyle.qml
    components/BasicRow.js
    components/BasicRow.qml
    components/NotificationBanner.qml
    components/Slider.qml
    components/SliderStyle.qml
    components/SliderTemplate.qml
    components/ContextMenu.qml
    components/CheckBox.qml
    components/BusyIndicator.qml
    components/DatePickerDialog.qml
    components/ListButton.qml
    components/ListDelegate.qml
    components/MoreIndicator.qml
    components/MultiSelectionDialog.qml
    components/MultiSelectionDialog.js
    components/NetPromoterScore.qml
    components/PageHeader.qml
    components/PageIndicator.qml
    components/ProgressBar.qml
    components/RadioButton.qml
    components/RatingIndicator.qml
    components/SheetButton.qml
    components/Sheet.qml
    components/SipSimulator.qml
    components/Snapshot.qml
    components/Switch.qml
    components/SystemBanner.qml
    components/TimePickerDialog.qml
    components/TumblerButton.qml
    components/TumblerColumn.qml
    components/TumblerDialogNew.qml
    components/TumblerDialog.qml
    components/TumblerIndexHelper.js
    components/Tumbler.js
    components/TumblerNew.qml
    components/Tumbler.qml
    components/TumblerTemplate.qml
    components/ViewPlaceholder.qml
    components/BusyIndicatorStyle.qml
    components/CheckBoxStyle.qml
    components/ContextMenuStyle.qml
    components/GroupButtonStyle.qml
    components/ListButtonStyle.qml
    components/NegativeButtonStyle.qml
    components/PositiveButtonStyle.qml
    components/ProgressBarStyle.qml
    components/RadioButtonStyle.qml
    components/SheetButtonAccentStyle.qml
    components/SheetButtonStyle.qml
    components/SheetStyle.qml
    components/SwitchStyle.qml
    components/TumblerButtonStyle.qml
    components/TextArea.qml
    components/TextAreaStyle.qml
    components/CountBubble.qml
    components/MaskedItem.qml
    components/EditBubble.js
    components/EditBubble.qml
    components/EditBubbleButton.qml
    components/EditBubbleButtonStyle.qml
    components/EditBubbleStyle.qml
    components/SelectionHandles.js
    components/SelectableLabel.qml
    components/SelectionHandles.qml
    components/SelectionHandlesStyle.qml
    ButtonPage.qml
    ChangeToolbarPage.qml
    CustomVkbPage.qml
    DialogPage.qml
    DialogsPage.qml
    DynamicNavigationPage.qml
    LabelPage.qml
    ListPage.qml
    MainPage.qml
    MiscPage.qml
    OrientationModePage.qml
    OrientationModeScreen.qml
    OrientationPage.qml
    PageStackWindowPage.qml
    PlaybackPage.qml
    SectionScrollerPage.qml
    SheetPage.qml
    SimpleExamplesPage.qml
    SliderPage.qml
    StaticNavigationPage.qml
    TabBarPage.qml
    TextInputPage.qml
    ToolBarPage.qml
    VisibilityPage.qml
    InfoBannerPage.qml
    PageIndicatorPage.qml
    StyledButtons.qml
    TumblerDialogPage.qml
    TumblerPage.qml

)
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
    RESOURCES images.qrc fonts.qrc
)

target_compile_definitions(appmeego
    PRIVATE
    $<$<OR:$<CONFIG:Debug>,$<CONFIG:RelWithDebInfo>>:QT_QML_DEBUG>
)
target_link_libraries(appmeego
    PRIVATE
    Qt::Quick
    Qt6::Svg
    Qt6::Gui
    Qt6::Qml
)

include(GNUInstallDirs)
install(TARGETS appmeego
    RUNTIME DESTINATION "${CMAKE_INSTALL_BINDIR}"
    BUNDLE DESTINATION "."
    LIBRARY DESTINATION "${CMAKE_INSTALL_LIBDIR}"
)

