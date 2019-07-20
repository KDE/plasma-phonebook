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

Kirigami.Page {

    id: root

    title: state === "create" ? i18n("Add contact") : i18n("Edit contact")

    property url personUri

    states: [
        State {
            name: "create"
        },
        State {
            name: "update"
        }
    ]

    KPeople.PersonData {
        id: personData
        personUri: root.personUri
    }

    actions {
        main: Kirigami.Action {
            icon.name: "dialog-ok-apply"
            text: i18n("Save")
            enabled: firstname.text !== ""

            onTriggered: {
                var emailList = []
                for (var index in email.children)
                    emailList.push(email.children[index].text)

                var phoneNumberList = []
                for (var index in phoneNumber.children)
                    phoneNumberList.push(phoneNumber.children[index].text)

                if (root.state === "create") {
                    phonebook.addContact(firstname.text + " " + lastname.text, phoneNumberList, emailList)
                }
                else if (root.state === "update") {
                    phonebook.updateContact(root.personUri, firstname.text + " " + lastname.text, phoneNumberList, emailList)
                }
                pageStack.pop()
            }
        }
    }

    // TextField for dynamic creation
    Component {
        id: textFieldComponent

        Controls.TextField {
        }
    }

    Kirigami.FormLayout {
        id: form
        anchors.fill: parent

        Controls.TextField {
            Kirigami.FormData.label: i18n("First name:")
            // FIXME PersonData doesn't have separate first/last name
            text: personUri ? personData.person.name.split(" ")[0] : ""
            id: firstname
        }
        Controls.TextField {
            Kirigami.FormData.label: i18n("Last name:")
            // FIXME KPeople doesn't have separate first/last name
            text: personUri ? personData.person.name.split(" ")[1] : ""
            id: lastname
        }

        ColumnLayout {
            id: phoneNumber
            Kirigami.FormData.label: i18n("Phone:")
            Controls.TextField {
                // FIXME PersonData doesn't have phonenumber property
            }
        }
        Controls.Button {
            text: "Add more"
            onClicked: textFieldComponent.createObject(phoneNumber)
        }

        ColumnLayout {
            id: email
            Kirigami.FormData.label: i18n("Email:")

            Controls.TextField {
                placeholderText: i18n("user@example.org")
                // FIXME PersonData doesn't have email property
            }
        }
        Controls.Button {
            text: "Add more"
            onClicked: textFieldComponent.createObject(email, { placeholderText: i18n("user@example.org") })
        }
    }
}
