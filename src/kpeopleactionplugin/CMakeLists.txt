kcoreaddons_add_plugin (phonebook_kpeople_plugin SOURCES kpeopleactionsplugin.cpp INSTALL_NAMESPACE "kpeople/actions")

target_link_libraries(phonebook_kpeople_plugin
    KF6::CoreAddons
    KF6::I18n
    KF6::People
    KF6::PeopleBackend
    KF6::Contacts
)
