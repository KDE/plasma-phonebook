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

    KPeople.PersonActions {
        id: personActions
        personUri: page.personUri
    }

    title: personData.person.name
    Kirigami.Theme.colorSet: Kirigami.Theme.View

    background: Rectangle {
        color: Kirigami.Theme.backgroundColor
    }

    Detail {
        anchors.fill: parent
        personUri: page.personUri
    }

    actions {
        main: Kirigami.Action {
                iconName: "document-edit"
                text: i18n("Edit")
                onTriggered: {
                    pageStack.push(Qt.resolvedUrl("AddContactPage.qml"), {state: "update", person: personData.person})
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
    }
}
