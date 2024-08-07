cmake_minimum_required(VERSION 3.15)

set(PROJECT_VERSION "24.02.0")
project(plasma-phonebook VERSION ${PROJECT_VERSION})

set(KF_MIN_VERSION "6.3.0")
set(QT_MIN_VERSION "6.6.0")

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(ECM ${KF_MIN_VERSION} REQUIRED)

set(CMAKE_MODULE_PATH ${ECM_MODULE_PATH})

include(FeatureSummary)
include(ECMSetupVersion)
include(ECMGenerateHeaders)
include(KDEInstallDirs)
include(KDECMakeSettings)
include(ECMPoQmTools)
include(KDECompilerSettings NO_POLICY_SCOPE)
include(KDEClangFormat)
include(KDEGitCommitHooks)
include(ECMQmlModule)

ecm_setup_version(${PROJECT_VERSION}
    VARIABLE_PREFIX PLASMAPHONEBOOK
    VERSION_HEADER ${CMAKE_CURRENT_BINARY_DIR}/version.h
)
find_package(Qt6 ${QT_MIN_VERSION} REQUIRED NO_MODULE COMPONENTS Core Quick Test Gui Svg QuickControls2 Widgets)
find_package(KF6 ${KF_MIN_VERSION} REQUIRED COMPONENTS CoreAddons Kirigami People Contacts Config)
find_package(KF6KirigamiAddons 1.0.0 REQUIRED)

add_subdirectory(src)

ki18n_install(po)

install(PROGRAMS org.kde.phonebook.desktop DESTINATION ${KDE_INSTALL_APPDIR})
install(FILES org.kde.phonebook.metainfo.xml DESTINATION ${KDE_INSTALL_METAINFODIR})
install(FILES org.kde.phonebook.svg DESTINATION ${KDE_INSTALL_FULL_ICONDIR}/hicolor/scalable/apps)

feature_summary(WHAT ALL INCLUDE_QUIET_PACKAGES FATAL_ON_MISSING_REQUIRED_PACKAGES)

file(GLOB_RECURSE ALL_CLANG_FORMAT_SOURCE_FILES *.cpp *.h)
kde_clang_format(${ALL_CLANG_FORMAT_SOURCE_FILES})

kde_configure_git_pre_commit_hook(CHECKS CLANG_FORMAT)
