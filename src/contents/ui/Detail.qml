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
import org.kde.kirigami 2.10 as Kirigami
import QtGraphicalEffects 1.0
import org.kde.people 1.0 as KPeople

import "lib" as HIG

ListView {
    property string personUri;

    anchors.fill: parent
    id: actionsListView
    model: personActions

    KPeople.PersonData {
        id: personData
        personUri: actionsListView.personUri
    }

    KPeople.PersonActions {
        id: personActions
        personUri: actionsListView.personUri
    }

    header: HIG.Header {
        id: header
        content.anchors.leftMargin: actionsListView.width > 400 ? 100 : Kirigami.Units.largeSpacing
        content.anchors.topMargin: Kirigami.Units.largeSpacing
        content.anchors.bottomMargin: Kirigami.Units.largeSpacing

        source: personData.person.photo

        // There might be edge-cases when photo but not pictureUrl is set.
        // For the background image it's more important to provide something else than the default pixmap though.
        backgroundSource: personData.person.pictureUrl ? personData.person.pictureUrl : "qrc:/fallbackBackground.png"

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

    section.property: "actionType"
    section.delegate: Kirigami.ListSectionHeader {
        text: {
            switch(parseInt(section)) {
            case KPeople.ActionType.TextChatAction:
                return i18n("Chat")
            case KPeople.ActionType.AudioCallAction:
                return i18n("Call")
            case KPeople.ActionType.VideoCallAction:
                return i18n("Video Call")
            case KPeople.ActionType.SendEmailAction:
                return i18n("Email")
            case KPeople.ActionType.SendFileAction:
                return i18n("Send file")
            default:
                return i18n("Other")
            }
        }
    }

    delegate: Kirigami.BasicListItem {
        text: model.display
        icon: model.iconName
        onClicked: model.action.trigger()
    }
}
