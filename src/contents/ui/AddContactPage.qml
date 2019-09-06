/*
 *   Copyright 2019 Nicolas Fella <nicolas.fella@gmx.de>
 *
 *   This program is free software; you can redistribute it and/or modify
 *   it under the terms of the GNU Library General Public License as
 *   published by the Free Software Foundation; either version 2, or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU Library General Public License for more details
 *
 *   You should have received a copy of the GNU Library General Public
 *   License along with this program; if not, write to the
 *   Free Software Foundation, Inc.,
 *   51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
 */

import QtQuick 2.6
import QtQuick.Controls 2.2 as Controls
import QtQuick.Layouts 1.2
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

        Controls.TextField {
            id: name
            Kirigami.FormData.label: i18n("Name:")
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
            Kirigami.FormData.label: i18n("Phone:")
            Repeater {
                id: rep
                model: addressee.phoneNumbers
                delegate: RowLayout {
                    Controls.TextField {
                        id: phoneField
                        text: display
                        onAccepted: {
                            display = text
                        }

                        Connections {
                            target: root;
                            onSave: phoneField.accepted()
                        }
                    }
                    Controls.Button {
                        icon.name: "list-remove"
                        onClicked: {
                            addressee.phoneNumbers.removePhoneNumber(edit)
                        }
                    }
                }
            }
            RowLayout {
                Controls.TextField {
                    id: toAddPhone
                    placeholderText: i18n("+1 555 2368")
                }
                Controls.Button {
                    icon.name: "list-add"
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
                        text: modelData
                    }
                    Controls.Button {
                        icon.name: "list-remove"
                        onClicked: addressee.removeEmail(textField.text)
                    }
                }
            }
            RowLayout {
                Controls.TextField {
                    id: toAddEmail
                    placeholderText: i18n("user@example.org")
                }
                Controls.Button {
                    icon.name: "list-add"
                    enabled: toAddEmail.text.length > 0
                    onClicked: {
                        addressee.insertEmail(toAddEmail.text)
                        toAddEmail.text = ""
                    }
                }
            }
        }
    }
}
