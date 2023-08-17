add_executable(plasma-phonebook
    main.cpp
    contactcontroller.cpp
    contactimporter.cpp
)

qt_add_qml_module(plasma-phonebook URI org.kde.phonebook VERSION 1.0

    QML_FILES
    qml/AddContactPage.qml
    qml/components/ActionButton.qml
    qml/components/BottomDrawer.qml
    qml/components/DoubleActionButton.qml
    qml/ContactListItem.qml
    qml/ContactsPage.qml
    qml/DetailPage.qml
    qml/Header.qml
    qml/main.qml
    qml/PhoneNumberDialog.qml
    qml/RoundImage.qml

    NO_RESOURCE_TARGET_PATH
)

target_include_directories(plasma-phonebook PRIVATE ${CMAKE_BINARY_DIR})

target_link_libraries(plasma-phonebook PRIVATE
        Qt::Core Qt::Qml Qt::Quick Qt::Svg Qt::Widgets
        KF${QT_MAJOR_VERSION}::Contacts KF${QT_MAJOR_VERSION}::People KF${QT_MAJOR_VERSION}::I18n KF${QT_MAJOR_VERSION}::CoreAddons
        KF${QT_MAJOR_VERSION}::ConfigCore KF${QT_MAJOR_VERSION}::ConfigGui
)

if(ANDROID)
    target_link_libraries(plasma-phonebook PRIVATE KF${QT_MAJOR_VERSION}::Kirigami2 Qt::Svg Qt::AndroidExtras)

    kirigami_package_breeze_icons(ICONS
        go-down-symbolic
        go-next-symbolic
        go-up-symbolic
        view-refresh
        search
        view-pim-contacts
        dialog-ok-apply
        dialog-cancel
        list-add
        list-remove
        list-add_executable
        contact-new-symbolic
        document-import
        mail-message
        call-start
        document-edit
        delete
        # im-* icons used by KContacts::Impp::serviceIcon
        im-google
        im-gadugadu
        im-twitter
        im-irc
        im-google-talk
        im-yahoo
        im-jabber
        im skype
        im-icq
        im-qq
        im-facebook
        im-aim
        im-identi.ca
        im-youtube
    )

endif()

install(TARGETS plasma-phonebook ${KDE_INSTALL_TARGETS_DEFAULT_ARGS})

add_subdirectory(kpeopleactionplugin)
