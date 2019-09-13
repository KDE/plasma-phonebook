qt5_add_resources(RESOURCES resources.qrc)
add_executable(plasma-phonebook main.cpp phonesmodel.cpp declarativeaddressee.cpp contactimporter.cpp ${RESOURCES})
target_link_libraries(plasma-phonebook
	Qt5::Core Qt5::Qml Qt5::Quick Qt5::Svg
	KF5::Contacts KF5::People
)

if(ANDROID)
    target_link_libraries(plasma-phonebook PRIVATE
        KF5::Kirigami2
        Qt5::Svg
    )
endif()

install(TARGETS plasma-phonebook ${KF5_INSTALL_TARGETS_DEFAULT_ARGS})

add_subdirectory(kpeopleactionplugin)
