kcoreaddons_add_plugin (phonebook_kpeople_plugin SOURCES kpeopleactionsplugin.cpp INSTALL_NAMESPACE "kpeople/actions")

target_link_libraries(phonebook_kpeople_plugin
    KF${QT_MAJOR_VERSION}::CoreAddons
    KF${QT_MAJOR_VERSION}::I18n
    KF${QT_MAJOR_VERSION}::People
    KF${QT_MAJOR_VERSION}::PeopleBackend
    KF${QT_MAJOR_VERSION}::Contacts
)
