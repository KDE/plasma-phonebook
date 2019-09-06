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
import org.kde.people 1.0 as KPeople

import "lib" as HIG


Flickable  {
    id: root
    property string personUri;
    signal editClicked()


    KPeople.PersonData {
        id: personData
        personUri: root.personUri
    }

    HIG.Header {
        id: header
        content.anchors.leftMargin: root.width > 400 ? 100 : Kirigami.Units.largeSpacing
        content.anchors.topMargin: Kirigami.Units.largeSpacing
        content.anchors.bottomMargin: Kirigami.Units.largeSpacing
        //status: root.contentY == 0 ? 1 : Math.min(1, Math.max(2 / 11, 1 - root.contentY / Kirigami.Units.gridUnit))

        source: personData.person.photo

        // There might be edge-cases when photo but not pictureUrl is set.
        // For the background image it's more important to provide something else than the default pixmap though.
        backgroundSource: personData.person.pictureUrl ? personData.person.pictureUrl : "qrc:/fallbackBackground.png"

        /*stripContent: Row {
            anchors.fill: parent
            spacing: (header.width - 3 * Kirigami.Units.iconSizes.medium) / 4
            anchors.leftMargin: spacing

            Kirigami.Icon {
                source: "favorite"
                width: Kirigami.Units.iconSizes.smallMedium
                height: width
                anchors.verticalCenter: parent.verticalCenter
            }
            Kirigami.Icon {
                source: "document-share"
                width: Kirigami.Units.iconSizes.smallMedium
                height: width
                anchors.verticalCenter: parent.verticalCenter
            }
            Kirigami.Icon {
                source: "document-edit"
                width: Kirigami.Units.iconSizes.smallMedium
                height: width
                anchors.verticalCenter: parent.verticalCenter
                MouseArea {
                    onClicked: root.editClicked()
                    anchors.fill: parent
                }
            }
        }*/

        ColumnLayout {
            Kirigami.Heading {
                text: personData.person.name
                color: "#fcfcfc"
                level: 2
            }
            Kirigami.Heading {
                text: personData.person.contactCustomProperty("phoneNumber") ? personData.person.contactCustomProperty("phoneNumber") : ""
                color: "#fcfcfc"
                level: 3
            }
        }
    }

    KPeople.PersonActions {
        id: personActions
        personUri: root.personUri
    }

    ListView {
        id: actionsListView
        anchors.top: header.bottom
        width: parent.width
        model: personActions
        delegate: Kirigami.BasicListItem {
            text: model.display
            icon: model.iconName
            onClicked: personActions.triggerAction(model.action)
        }
    }
}
