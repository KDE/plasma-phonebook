/*
 *   SPDX-FileCopyrightText: 2018 Fabian Riethmayer 
 *
 *   SPDX-License-Identifier: LGPL-2.0-or-later
 */

import QtQuick 2.6
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.2
import QtQuick.Dialogs 1.1
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
        left: Kirigami.Action {
            text: i18n("Cancel")
            icon.name: "dialog-cancel"

            onTriggered: {
                pageStack.pop()
            }
        }
        
    }
}
