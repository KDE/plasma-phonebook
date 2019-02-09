/*
 * Copyright 2015  Martin Klapetek <mklapetek@kde.org>
 * Copyright 2019  Linus Jahn <lnj@kaidan.im>
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

import org.kde.people 1.0 as KPeople
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.private.kpeoplehelper 1.0
import org.kde.kirigami 2.6 as Kirigami

Kirigami.ScrollablePage {
    title: i18n("Address book")

    // Brighter background color
    Kirigami.Theme.colorSet: Kirigami.Theme.View
    background: Rectangle {
        color: Kirigami.Theme.backgroundColor
    }

    FormPage {
        id: form
        model: page.model // TODO
    }

    actions {
        main: Kirigami.Action {
            icon.name: "contact-new-symbolic"
            onTriggered: {
                form.open()
            }
        }
    }

    Controls.Label {
        anchors.centerIn: parent
        text: i18n("No contacts")
        visible: contactsModel.count === 0
    }

    header: Rectangle {
        clip: true
        id: header
        height: searchField.implicitHeight + 2 * Kirigami.Units.largeSpacing
        width: root.width

        Controls.TextField {
            id: searchField
            placeholderText: i18n("Search")
            anchors.centerIn: parent
            anchors.margins: Kirigami.Units.largeSpacing
            width: parent.width - 2 * Kirigami.Units.largeSpacing
        }
    }

    ListView {
        id: contactsList

        property bool delegateSelected: false
        property string numberToCall

        section.property: "display"
        section.criteria: ViewSection.FirstCharacter
        clip: true
        model: PlasmaCore.SortFilterModel {
            sourceModel: KPeople.PersonsSortFilterProxyModel {
                sourceModel: KPeopleHelper {
                    id: contactsModel
                }
                requiredProperties: "phoneNumber"
            }
            sortRole: "display"
            filterRole: "display"
            filterRegExp: ".*" + searchField.text + ".*"
            sortOrder: Qt.AscendingOrder
        }

        // model.display, model.decoration, model.phoneNumber
        delegate: ContactListItem {
            height: Kirigami.Units.gridUnit * 3
            name: model.display
            icon: model.decoration

            onClicked: pageStack.push(detailPage)
        }

        function toggleOverlayButtons(show) {
            if (show) {
                settingsRect.parent = contactsList.currentItem
                settingsRect.visible = true

                callRect.parent = contactsList.currentItem
                callRect.visible = true
            } else {
                settingsRect.visible = false
                callRect.visible = false
            }
        }

        CustomSectionScroller {
            listView: contactsList
        }
    }
}
