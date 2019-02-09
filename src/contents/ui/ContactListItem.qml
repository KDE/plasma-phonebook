/*
 *  Kaidan - A user-friendly XMPP client for every device!
 *
 *  Copyright (C) 2016-2019 Kaidan developers and contributors
 *  (see the LICENSE file for a full list of copyright authors)
 *
 *  Kaidan is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.
 *
 *  In addition, as a special exception, the author of Kaidan gives
 *  permission to link the code of its release with the OpenSSL
 *  project's "OpenSSL" library (or with modified versions of it that
 *  use the same license as the "OpenSSL" library), and distribute the
 *  linked executables. You must obey the GNU General Public License in
 *  all respects for all of the code used other than "OpenSSL". If you
 *  modify this file, you may extend this exception to your version of
 *  the file, but you are not obligated to do so.  If you do not wish to
 *  do so, delete this exception statement from your version.
 *
 *  Kaidan is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with Kaidan.  If not, see <http://www.gnu.org/licenses/>.
 */

import QtQuick 2.3
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.0 as Controls
import QtGraphicalEffects 1.0
import org.kde.kirigami 2.0 as Kirigami

Kirigami.SwipeListItem {
	id: listItem

	property string name
    property var icon

    actions: [
        Kirigami.Action {
            iconName: "entry-edit"
        },
        Kirigami.Action {
            iconName: "call-start"
            onTriggered: {
                console.log("Calling " + model.phoneNumber)
                Qt.openUrlExternally("call://" + model.phoneNumber)
            }
        }
    ]

	RowLayout {
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
