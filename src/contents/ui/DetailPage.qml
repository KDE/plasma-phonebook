/*
 *   SPDX-FileCopyrightText: 2018 Fabian Riethmayer
 *   SPDX-FileCopyrightText: 2021 Nicolas Fella <nicolas.fella@gmx.de>
 *
 *   SPDX-License-Identifier: LGPL-2.0-or-later
 */

import QtQuick 2.6
import QtQuick.Controls 2.13
import QtQuick.Layouts 1.2
import org.kde.people 1.0 as KPeople
import org.kde.kirigami 2.14 as Kirigami
import org.kde.phonebook 1.0

Kirigami.ScrollablePage {
    property string personUri;
    id: page

    leftPadding: 0
    rightPadding: 0
    topPadding: 0

    title: personData.person.name
    Kirigami.Theme.colorSet: Kirigami.Theme.View

    function callNumber(number) {
        Qt.openUrlExternally("tel:" + number)
    }

    function sendSms(number) {
        Qt.openUrlExternally("sms:" + number)
    }

    KPeople.PersonData {
        id: personData
        personUri: page.personUri
    }

    KPeople.PersonActions {
        id: personActions
        personUri: page.personUri
    }

    property var addressee: ContactController.addresseeFromVCard(personData.person.contactCustomProperty("vcard"))

    Component {
        id: callPopup

        PhoneNumberDialog {}
    }

    Column {
        Header {
            id: header
            width: parent.width
            height: Kirigami.Units.gridUnit * 8

            // There might be edge-cases when photo but not pictureUrl is set.
            // For the background image it's more important to provide something else than the default pixmap though.
            backgroundSource: personData.person.pictureUrl ? personData.person.pictureUrl : "qrc:/fallbackBackground.png"

            RowLayout {
                anchors.fill: parent

                Kirigami.Avatar {
                    id: avatar

                    Layout.fillHeight: true
                    Layout.preferredWidth: height
                    Layout.margins: Kirigami.Units.largeSpacing

                    source: personData.photoImageProviderUri
                    name: personData.person.name
                    imageMode: Kirigami.Avatar.ImageMode.AdaptiveImageOrInitals
                }

                ColumnLayout {
                    Layout.fillHeight: true
                    Layout.margins: Kirigami.Units.largeSpacing

                    Kirigami.Heading {
                        text: personData.person.name
                        color: "#fcfcfc"
                        level: 2
                    }
                    Kirigami.Heading {
                        text: personData.person.contactCustomProperty("phoneNumber") ? personData.person.contactCustomProperty("phoneNumber") : ""
                        color: "#fcfcfc"
                        level: 3
                    }
                }

                Item {
                    Layout.fillWidth: true
                }
            }
        }

        Instantiator {
            model: personActions

            delegate: Kirigami.Action {
                text: model.display
                iconName: model.iconName
            }

            onObjectAdded: toolbar.actions.push(object)
        }

        ToolBar {
            width: parent.width

            Kirigami.ActionToolBar {
                id: toolbar
                width: parent.width

                actions: [
                    Kirigami.Action {
                        text: i18n("Call")
                        iconName: "call-start"
                        visible: addressee.phoneNumbers.length > 0
                        onTriggered: {
                            var model = addressee.phoneNumbers

                            if (addressee.phoneNumbers.length == 1) {
                                page.callNumber(model[0].normalizedNumber)
                            } else {
                                var pop = callPopup.createObject(page, {numbers: addressee.phoneNumbers, title: i18n("Select number to call")})
                                pop.onNumberSelected.connect(number => callNumber(number))
                                pop.open()
                            }
                        }
                    },
                    Kirigami.Action {
                        text: i18n("Send SMS")
                        iconName: "mail-message"
                        visible: addressee.phoneNumbers.length > 0
                        onTriggered: {
                            var model = addressee.phoneNumbers

                            if (addressee.phoneNumbers.length == 1) {
                                page.sendSms(model[0].normalizedNumber)
                            } else {
                                var pop = callPopup.createObject(page, {numbers: addressee.phoneNumbers, title: i18n("Select number to send message to")})
                                pop.onNumberSelected.connect(number => sendSms(number))
                                pop.open()
                            }
                        }
                    },
                    Kirigami.Action {
                        text: i18n("Send email")
                        iconName: "mail-message"
                        visible:personData.person.contactCustomProperty("email").length > 0
                        onTriggered: Qt.openUrlExternally("mailto:" + personData.person.contactCustomProperty("email"))
                    }
                ]
            }
        }

        Kirigami.FormLayout {
            width: parent.width
            Label {
                visible: text != ""
                text: {
                    // We do not always have the year
                    if (addressee.birthday.getFullYear() === 0) {
                        return Qt.formatDate(addressee.birthday, "dd.MM.")
                    } else {
                        return Qt.formatDate(addressee.birthday)
                    }
                }
                Kirigami.FormData.label: i18n("Birthday:")
            }
        }
    }

    actions {
        main: Kirigami.Action {
            iconName: "document-edit"
            text: i18n("Edit")
            onTriggered: {
                pageStack.pushDialogLayer(Qt.resolvedUrl("AddContactPage.qml"), {state: "update", person: personData.person, addressee: page.addressee})
            }
        }
        contextualActions: [
            Kirigami.Action {
                iconName: "delete"
                text: i18n("Delete contact")
                onTriggered: {
                    KPeople.PersonPluginManager.deleteContact(page.personUri)
                    pageStack.pop()
                }
            }
        ]
        left: Kirigami.Action {
            text: i18n("Cancel")
            icon.name: "dialog-cancel"
            visible: Kirigami.Settings.isMobile

            onTriggered: {
                pageStack.pop()
            }
        }
    }
}
