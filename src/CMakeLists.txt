qt5_add_resources(RESOURCES resources.qrc)
add_executable(plasma-phonebook main.cpp phonesmodel.cpp declarativeaddressee.cpp ${RESOURCES})
target_link_libraries(plasma-phonebook
	Qt5::Core Qt5::Qml Qt5::Quick Qt5::Svg
	KF5::Contacts
)
install(TARGETS plasma-phonebook ${KF5_INSTALL_TARGETS_DEFAULT_ARGS})
