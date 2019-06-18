/*
 * Copyright 2017-2019 Kaidan Developers and Contributors
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

import QtQuick 2.3
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.0 as Controls
import QtGraphicalEffects 1.0

import org.kde.kirigami 2.0 as Kirigami
import org.kde.people 1.0 as KPeople

Kirigami.SwipeListItem {
    id: listItem

    property string name
    property var icon
    property string personUri

    RowLayout {
        KPeople.PersonData {
            id: personData
            personUri: listItem.personUri
        }

        KPeople.PersonActions {
            id: personActions
            personUri: listItem.personUri
        }

        height: Kirigami.Units.gridUnit * 5
        spacing: Kirigami.Units.gridUnit * 0.5

        // left side: Avatar
        Item {
            id: avatarSpace
            Layout.preferredHeight: parent.height
            Layout.preferredWidth: parent.height

            RoundImage {
                id: avatar
                anchors.fill: parent
                source: icon
                isRound: true
            }
        }

        // contact name
        Kirigami.Heading {
            text: name
            textFormat: Text.PlainText
            elide: Text.ElideRight
            maximumLineCount: 1
            level: 3
            Layout.fillWidth: true
        }
    }
}
