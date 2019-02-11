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

import QtQuick 2.6
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.2

import org.kde.people 1.0 as KPeople
import org.kde.kirigami 2.4 as Kirigami

Kirigami.ScrollablePage {
    property string personUri;
    visible: false
    id: page

    KPeople.PersonData {
        id: personData
        personUri: page.personUri
    }

    title: personData.person.name
    Kirigami.Theme.colorSet: Kirigami.Theme.View

    background: Rectangle {
        color: Kirigami.Theme.backgroundColor
    }

    Detail {
        personUri: page.personUri
        onEditClicked: form.open();
    }

    FormPage {
        id: form
        model: page.model
    }

    actions {
        left: Kirigami.Action {
            iconName: "mail-message"
            text: "Write mail"
            onTriggered: Qt.openUrlExternally("mailto:" + personData.email)
        }
        main: Kirigami.Action {
            iconName: "call-start"
            text: "Make call"
            onTriggered: Qt.openUrlExternally("call://" + personData.person.contactCustomProperty("phoneNumber"))
        }
        right: Kirigami.Action {
            iconName: "kmouth-phrase-new"
            text: "Write SMS"
            onTriggered: Qt.openUrlExternally("sms://" + personData.person.contactCustomProperty("phoneNumber"))
        }
    }

    contextualActions: [
        Kirigami.Action {
            iconName: "favorite"
            text: "Select as favorite"
        },
        Kirigami.Action {
            iconName: "document-share"
            text: "Share"
        },
        Kirigami.Action {
            iconName: "document-edit"
            text: "Edit"
        },
        Kirigami.Action {
            iconName: "edit-image-face-add"
            text: "Choose photo"
        },
        Kirigami.Action {
            iconName: "delete"
            text: "Delete contact"
        }
    ]
}
