kcoreaddons_add_plugin (phonebook_kpeople_plugin SOURCES kpeopleactionsplugin.cpp JSON "phonebook_kpeople_plugin.json" INSTALL_NAMESPACE "kpeople/actions")

target_link_libraries(phonebook_kpeople_plugin
    KF5::CoreAddons
    KF5::I18n
    KF5::People
    KF5::PeopleBackend
)
