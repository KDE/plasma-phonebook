add_executable(plasma-phonebook
    main.cpp
    contactcontroller.cpp
    contactimporter.cpp
)

ecm_add_qml_module(plasma-phonebook URI org.kde.phonebook DEPENDENCIES "org.kde.contacts")

ecm_target_qml_sources(plasma-phonebook
    SOURCES
    qml/Main.qml
    qml/ContactsPage.qml
    qml/ContactListItem.qml
    qml/RoundImage.qml
    qml/DetailPage.qml
    qml/Header.qml
    qml/AddContactPage.qml
    qml/components/DoubleActionButton.qml
    qml/components/BottomDrawer.qml
    qml/components/ActionButton.qml
)

target_include_directories(plasma-phonebook PRIVATE ${CMAKE_BINARY_DIR})

target_link_libraries(plasma-phonebook PRIVATE
        Qt::Core Qt::Qml Qt::Quick Qt::Svg Qt::Widgets
        KF6::Contacts KF6::People KF6::I18n KF6::CoreAddons
        KF6::ConfigCore KF6::ConfigGui
)

if(ANDROID)
    target_link_libraries(plasma-phonebook PRIVATE KF6::Kirigami Qt::Svg)

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
