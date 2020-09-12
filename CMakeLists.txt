project(plasma-phonebook)

cmake_minimum_required(VERSION 2.8.12)
set(KF5_MIN_VERSION "5.65.0")
set(QT_MIN_VERSION "5.11.0")

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

################# Disallow in-source build #################

if("${CMAKE_SOURCE_DIR}" STREQUAL "${CMAKE_BINARY_DIR}")
   message(FATAL_ERROR "This application requires an out of source build. Please create a separate build directory.")
endif()

include(FeatureSummary)

################# set KDE specific information #################

find_package(ECM ${KF5_MIN_VERSION} REQUIRED NO_MODULE)

# where to look first for cmake modules, before ${CMAKE_ROOT}/Modules/ is checked
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${ECM_MODULE_PATH} ${ECM_KDE_MODULE_DIR})

include(ECMSetupVersion)
include(ECMGenerateHeaders)
include(KDEInstallDirs)
include(KDECMakeSettings)
include(ECMPoQmTools)
include(KDECompilerSettings NO_POLICY_SCOPE)
include(KDEClangFormat)

################# Find dependencies #################

find_package(Qt5 ${QT_MIN_VERSION} REQUIRED NO_MODULE COMPONENTS Core Quick Test Gui Svg QuickControls2)
find_package(KF5 ${KF5_MIN_VERSION} REQUIRED COMPONENTS CoreAddons Kirigami2 People Contacts)
find_package(KF5PeopleVCard REQUIRED)

if(ANDROID)
    find_package(Qt5 ${QT_MIN_VERSION} REQUIRED NO_MODULE COMPONENTS AndroidExtras)
endif()

################# build and install #################
add_subdirectory(src)

install(PROGRAMS org.kde.phonebook.desktop DESTINATION ${KDE_INSTALL_APPDIR})
install(FILES org.kde.phonebook.appdata.xml DESTINATION ${KDE_INSTALL_METAINFODIR})
install(FILES org.kde.phonebook.svg DESTINATION ${KDE_INSTALL_FULL_ICONDIR}/hicolor/scalable/apps)

feature_summary(WHAT ALL INCLUDE_QUIET_PACKAGES FATAL_ON_MISSING_REQUIRED_PACKAGES)

# add clang-format target for all our real source files
file(GLOB_RECURSE ALL_CLANG_FORMAT_SOURCE_FILES *.cpp *.h)
kde_clang_format(${ALL_CLANG_FORMAT_SOURCE_FILES})
