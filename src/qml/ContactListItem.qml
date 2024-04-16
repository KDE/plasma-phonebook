/*
 * SPDX-FileCopyrightText: 2017-2019 Kaidan Developers and Contributors 
 * SPDX-FileCopyrightText: 2019 Jonah Brüchert <jbb@kaidan.im>
 *
 * SPDX-License-Identifier: GPL-2.0-only OR GPL-3.0-only OR LicenseRef-KDE-Accepted-GPL
 */

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as Controls

import org.kde.kirigami as Kirigami
import org.kde.kirigamiaddons.components as Components
import org.kde.kirigamiaddons.delegates as Delegates
import org.kde.people as KPeople

Delegates.RoundedItemDelegate {
    id: listItem

    property string name
    property alias imageProviderUri: avatar.source

    contentItem: RowLayout {
        spacing: Kirigami.Units.largeSpacing

        Components.Avatar {
            id: avatar
            Layout.maximumHeight: parent.height
            Layout.maximumWidth: parent.height
            name: listItem.name
            imageMode: Components.Avatar.ImageMode.AdaptiveImageOrInitals
        }

        Kirigami.Heading {
            text: name
            textFormat: Text.PlainText
            elide: Text.ElideRight
            maximumLineCount: 1
            level: Kirigami.Settings.isMobile ? 3 : 5
            Layout.fillWidth: true
        }
    }
}
