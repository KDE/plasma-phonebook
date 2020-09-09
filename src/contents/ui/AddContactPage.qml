/*
 *   SPDX-FileCopyrightText: 2019 Nicolas Fella <nicolas.fella@gmx.de>
 *
 *   SPDX-License-Identifier: LGPL-2.0-or-later
 */

import QtQuick 2.6
import QtQuick.Controls 2.2 as Controls
import QtQuick.Layouts 1.2
import QtQuick.Dialogs 1.1
import org.kde.kirigami 2.4 as Kirigami
import org.kde.people 1.0 as KPeople
import org.kde.kcontacts 1.0 as KContacts

Kirigami.ScrollablePage {
    id: root

    property QtObject person
    signal save()

    states: [
        State {
            name: "create"
            PropertyChanges { target: root; title: i18n("Adding contact") }
        },
        State {
            name: "update"
            PropertyChanges { target: root; title: i18n("Editing contact") }
        }
    ]

    enabled: !person || person.isEditable

    KContacts.Addressee {
        id: addressee
        raw: root.person ? root.person.contactCustomProperty("vcard") : ""
    }

    actions {
        main: Kirigami.Action {
            icon.name: "dialog-ok-apply"
            text: i18n("Save")
            enabled: name.text.length > 0

            onTriggered: {
                root.save();
                switch(root.state) {
                    case "create":
                        if (!KPeople.PersonPluginManager.addContact({ "vcard": addressee.raw }))
                            console.warn("could not create contact")
                        break;
                    case "update":
                        if (!root.person.setContactCustomProperty("vcard", addressee.raw))
                            console.warn("Could not save", addressee.url)
                        break;
                }
                pageStack.pop()
            }
        }
        left: Kirigami.Action {
            text: i18n("Cancel")
            icon.name: "dialog-cancel"

            onTriggered: {
                pageStack.pop()
            }
        }
    }

    Kirigami.FormLayout {
        id: form
        Layout.fillWidth: true

        Controls.Button {
            Kirigami.FormData.label: i18n("Photo")

            // Square button
            implicitWidth: Kirigami.Units.gridUnit * 5
            implicitHeight: implicitWidth

            contentItem: Item {
                // Doesn't like to be scaled when being the direct contentItem
                Kirigami.Icon {
                    anchors.fill: parent
                    anchors.margins: Kirigami.Units.smallSpacing
                    source: fileDialog.fileUrl != "" ? fileDialog.fileUrl : root.person ? root.person.photo : "user-identity"
                }
            }
            FileDialog {
                id: fileDialog
                selectExisting: true
                selectMultiple: false
                onAccepted: addressee.addPhotoFromFile(fileUrl)
            }

            onClicked: {
                fileDialog.open()
            }
        }

        Controls.TextField {
            id: name
            Kirigami.FormData.label: i18n("Name:")
            Layout.fillWidth: true
            text: addressee.realName
            onAccepted: {
                addressee.name = text
            }

            Connections {
                target: root;
                onSave: name.accepted()
            }
        }

        Kirigami.Separator {
            Layout.fillWidth: true
        }

        ColumnLayout {
            id: phoneNumber
            Layout.fillWidth: true
            Kirigami.FormData.label: i18n("Phone:")
            Repeater {
                model: addressee.phoneNumbers

                delegate: RowLayout {
                    Controls.TextField {
                        id: phoneField
                        text: model.display
                        Layout.fillWidth: true
                        onAccepted: {
                            model.display = text
                        }

                        Connections {
                            target: root;
                            onSave: phoneField.accepted()
                        }
                    }
                    Controls.Button {
                        icon.name: "list-remove"
                        implicitWidth: implicitHeight
                        onClicked: {
                            addressee.phoneNumbers.removePhoneNumber(model.display)
                        }
                    }
                }
            }
            RowLayout {
                Controls.TextField {
                    id: toAddPhone
                    Layout.fillWidth: true
                    placeholderText: i18n("+1 555 2368")
                }

                // add last text field on save()
                Connections {
                    target: root;
                    onSave: {
                        if (toAddPhone.text !== "")
                            addressee.phoneNumbers.addPhoneNumber(toAddPhone.text)
                    }
                }

                // button to add additional text field
                Controls.Button {
                    icon.name: "list-add"
                    implicitWidth: implicitHeight
                    enabled: toAddPhone.text.length > 0
                    onClicked: {
                        addressee.phoneNumbers.addPhoneNumber(toAddPhone.text)
                        toAddPhone.text = ""
                    }
                }
            }
        }

        Kirigami.Separator {
            Layout.fillWidth: true
        }

        ColumnLayout {
            id: email
            Layout.fillWidth: true
            Kirigami.FormData.label: i18n("E-mail:")

            Repeater {
                model: addressee.emails

                Binding {
                    target: parent
                    property: "model"
                    value: addressee.emails
                    when: addressee.dataChanged
                }
                delegate: RowLayout {
                    Controls.TextField {
                        id: textField
                        Layout.fillWidth: true
                        text: modelData
                    }
                    Controls.Button {
                        icon.name: "list-remove"
                        implicitWidth: implicitHeight
                        onClicked: addressee.removeEmail(modelData)
                    }
                }
            }
            RowLayout {
                Controls.TextField {
                    id: toAddEmail
                    Layout.fillWidth: true
                    placeholderText: i18n("user@example.org")
                }

                // add last text field on save()
                Connections {
                    target: root;
                    onSave: {
                        if (toAddEmail.text !== "")
                            addressee.insertEmail(toAddEmail.text)
                    }
                }

                // button to add additional text field
                Controls.Button {
                    icon.name: "list-add"
                    implicitWidth: implicitHeight
                    enabled: toAddEmail.text.length > 0
                    onClicked: {
                        addressee.insertEmail(toAddEmail.text)
                        toAddEmail.text = ""
                    }
                }
            }
        }

        Kirigami.Separator {
            Layout.fillWidth: true
        }

        ColumnLayout {
            id: impp
            Layout.fillWidth: true
            Kirigami.FormData.label: i18n("Instant Messenger:")

            Repeater {
                model: addressee.impps

                delegate: RowLayout {
                    Controls.TextField {
                        id: imppField
                        text: model.display
                        Layout.fillWidth: true
                        onAccepted: {
                            model.display = text
                        }

                        Connections {
                            target: root;
                            onSave: imppField.accepted()
                        }
                    }
                    Controls.Button {
                        icon.name: "list-remove"
                        implicitWidth: implicitHeight
                        onClicked: {
                            print("remove", model.display)
                            addressee.impps.removeImpp(model.display)
                        }
                    }
                }
            }
            RowLayout {
                Controls.TextField {
                    id: toAddImpp
                    Layout.fillWidth: true
                    placeholderText: i18n("protocol:person@example.com")
                }

                // add last text field on save()
                Connections {
                    target: root;
                    onSave: {
                        if (toAddImpp.text !== "")
                            addressee.impps.addImpp(toAddImpp.text)
                    }
                }

                // button to add additional text field
                Controls.Button {
                    icon.name: "list-add"
                    implicitWidth: implicitHeight
                    enabled: toAddImpp.text.length > 0
                    onClicked: {
                        addressee.impps.addImpp(toAddImpp.text)
                        toAddImpp.text = ""
                    }
                }
            }
        }
    }
}
