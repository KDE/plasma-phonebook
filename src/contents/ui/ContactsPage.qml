/*
 * Copyright 2015  Martin Klapetek <mklapetek@kde.org>
 * Copyright 2019  Linus Jahn <lnj@kaidan.im>
 * Copyright 2019  Jonah Brüchert <jbb@kaidan.im>
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License as
 * published by the Free Software Foundation; either version 2 of
 * the License or (at your option) version 3 or any later version
 * accepted by the membership of KDE e.V. (or its successor approved
 * by the membership of KDE e.V.), which shall act as a proxy
 * defined in Section 14 of version 3 of the license.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import QtQuick 2.7
import QtQuick.Controls 2.0 as Controls
import QtQuick.Layouts 1.7

import org.kde.kirigami 2.10 as Kirigami
import org.kde.people 1.0 as KPeople

import org.kde.phonebook 1.0


Kirigami.ScrollablePage {
    title: i18n("Address book")

    actions.main: Kirigami.Action {
        icon.name: "contact-new-symbolic"
        text: i18n("Create new")
        onTriggered: {
            pageStack.push(Qt.resolvedUrl("AddContactPage.qml"), {state: "create"})
        }
    }

    Controls.Label {
        anchors.centerIn: parent
        text: i18n("No contacts")
        visible: contactsList.count === 0
    }

    header: Kirigami.SearchField {
        id: searchField
        onTextChanged: filterModel.setFilterFixedString(text)
    }

    ListView {
        id: contactsList

        property bool delegateSelected: false
        property string numberToCall

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

        Component {
            id: contactListDelegate
            ContactListItem {
                height: Kirigami.Units.gridUnit * 3
                name: model && model.display
                avatarIcon: model && model.decoration
                personUri: model && model.personUri

                actions: [
                    Kirigami.Action {
                        icon.name: "call-start"
                        onTriggered: Qt.openUrlExternally("tel:" + model.phoneNumber);
                    }
                ]

                onClicked: {
                    pageStack.push(detailPage, {
                        personUri: model.personUri
                    })
                }
            }
        }

        delegate: Kirigami.DelegateRecycler {
            width: parent ? parent.width : 0
            sourceComponent: contactListDelegate
        }
    }
}
