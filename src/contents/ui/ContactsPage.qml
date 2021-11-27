/*
 * SPDX-FileCopyrightText: 2015 Martin Klapetek <mklapetek@kde.org>
 * SPDX-FileCopyrightText: 2019 Linus Jahn <lnj@kaidan.im>
 * SPDX-FileCopyrightText: 2019 Jonah Brüchert <jbb@kaidan.im>
 *
 * SPDX-License-Identifier: GPL-2.0-only OR GPL-3.0-only OR LicenseRef-KDE-Accepted-GPL
 */

import QtQuick 2.15
import QtQuick.Controls 2.0 as Controls
import QtQuick.Layouts 1.7

import org.kde.kirigami 2.12 as Kirigami
import org.kde.people 1.0 as KPeople

import org.kde.phonebook 1.0


Kirigami.ScrollablePage {
    title: i18n("Phonebook")

    actions.main: Kirigami.Action {
        icon.name: "contact-new-symbolic"
        text: i18n("Create New")
        onTriggered: {
            pageStack.pushDialogLayer(Qt.resolvedUrl("AddContactPage.qml"), {state: "create"})
        }
    }

    actions.contextualActions: [
        Kirigami.Action {
            icon.name: "document-import"
            text: i18n("Import contacts")
            onTriggered: {
                importer.startImport()
            }
        }
    ]

    header: Controls.Control {
        padding: Kirigami.Units.largeSpacing

        contentItem: Kirigami.SearchField {
            id: searchField
            onTextChanged: filterModel.setFilterFixedString(text)
        }
    }

    ListView {
        id: contactsList

        property bool delegateSelected: false
        property string numberToCall

        reuseItems: true

        currentIndex: -1

        section.property: "display"
        section.criteria: ViewSection.FirstCharacter
        section.delegate: Kirigami.ListSectionHeader {text: section}
        clip: true
        model: KPeople.PersonsSortFilterProxyModel {
            id: filterModel
            filterRole: Qt.DisplayRole
            sortRole: Qt.DisplayRole
            filterCaseSensitivity: Qt.CaseInsensitive

            sourceModel: KPeople.PersonsModel {
                id: contactsModel
            }
            Component.onCompleted: sort(0)
        }

        Kirigami.PlaceholderMessage {
            anchors.centerIn: parent
            text: i18n("No contacts")
            visible: contactsList.count === 0
        }

        delegate: ContactListItem {
            height: Kirigami.Units.gridUnit * 3
            name: model && model.display
            avatarIcon: model && model.decoration

            onClicked: {
                pageStack.push("qrc:/DetailPage.qml", {
                    personUri: model.personUri
                })
                ContactController.lastPersonUri = model.personUri;
            }
        }
    }
}
