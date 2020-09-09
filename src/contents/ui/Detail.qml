/*
 *   SPDX-FileCopyrightText: 2018 Fabian Riethmayer 
 *
 *   SPDX-License-Identifier: LGPL-2.0-or-later
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
