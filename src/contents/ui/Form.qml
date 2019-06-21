/*
 *   Copyright 2018 Fabian Riethmayer
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
import QtQuick 2.2
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.2
import org.kde.kirigami 2.4 as Kirigami
import QtGraphicalEffects 1.0

ColumnLayout  {
    id: root
    spacing: 2 * Kirigami.Units.largeSpacing

    property string personUri

    states: [
        State {
            name: "create"
        },
        State {
            name: "update"
        }
    ]

    Label {
        id: header
        text: i18n("Edit details")
        font.pointSize: 16
    }

    Kirigami.FormLayout {
        id: form
        Layout.fillWidth: true

        TextField {
            Kirigami.FormData.label: i18n("Firstname:")
            id: firstname
        }
        TextField {
            Kirigami.FormData.label: i18n("Lastname:")
            id: lastname
        }
        TextField {
            id: phoneNumber
            Kirigami.FormData.label: i18n("Phone")
        }
        TextField {
            id: email
            Kirigami.FormData.label: i18n("Email")
        }
        Kirigami.Separator {
            Kirigami.FormData.isSection: true
        }
    }

    Button {
        text: "Save"
        Layout.alignment: Qt.AlignRight
        anchors.rightMargin: Kirigami.Units.largeSpacing
        onClicked: {
            if (root.state === "create") {
                phonebook.addContact(firstname.text + " " + lastname.text, phoneNumber.text, email.text)
            }
            else if (root.state === "update") {
                phonebook.updateContact(root.personUri, firstname.text + " " + lastname.text, phoneNumber.text, email.text)
            }

            firstname.text = ""
            lastname.text = ""
            phoneNumber.text = ""
            email.text = ""

            formSheet.close()
        }
    }

}
