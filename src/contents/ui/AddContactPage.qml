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

    property alias personUri: personData.personUri

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

    KPeople.PersonData {
        id: personData
    }

    //we can only edit vcards
    enabled: personUri.indexOf("vcard:") === 0

    KContacts.Addressee {
        id: addressee
        url: personData.person.contactCustomProperty("VCardLocation")
    }

    actions {
        main: Kirigami.Action {
            icon.name: "dialog-ok-apply"
            text: i18n("Save")
            enabled: name.text.length > 0

            onTriggered: {
                if (!addressee.write())
                    console.warn("Could not save", addressee.url)
                pageStack.pop()
            }
        }
        left: Kirigami.Action {
            text: i18n("Cancel")
            icon.name : "dialog-cancel"

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
                delegate: Controls.TextField {
                    text: display
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
                    onClicked: addressee.phoneNumbers.addPhoneNumber(toAddPhone.text)
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
                Binding {
                    target: parent
                    property: "model"
                    value: addressee.emails
                    when: addressee.dataChanged
                }
                delegate: Row {
                    Controls.TextField {
                        id: textField
                        text: modelData
                    }
                    Controls.Button {
                        icon.name: "list-remove"
                        onClicked: parent.destroy()
                    }
                }
            }

            Controls.TextField {
                id: toAdd
                placeholderText: i18n("user@example.org")
            }
        }
        Controls.Button {
            icon.name: "list-add"
            onClicked: addressee.insertEmail(toAdd.text)
        }
    }
}
