/*
 * SPDX-FileCopyrightText: 2017-2019 Kaidan Developers and Contributors 
 * SPDX-FileCopyrightText: 2019 Jonah Brüchert <jbb@kaidan.im>
 *
 * SPDX-License-Identifier: GPL-2.0-only OR GPL-3.0-only OR LicenseRef-KDE-Accepted-GPL
 */

import QtQuick 2.3
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.0 as Controls
import QtGraphicalEffects 1.0

import org.kde.kirigami 2.0 as Kirigami
import org.kde.people 1.0 as KPeople

Kirigami.AbstractListItem {
    id: listItem

    property string name
    property var avatarIcon

    contentItem: RowLayout {

        RoundImage {
            id: avatar
            height: parent.height
            width: height
            source: avatarIcon
            isRound: true
        }

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
