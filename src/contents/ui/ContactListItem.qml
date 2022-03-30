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

import org.kde.kirigami 2.14 as Kirigami
import org.kde.people 1.0 as KPeople

Kirigami.AbstractListItem {
    id: listItem

    property string name
    property alias imageProviderUri: avatar.source

    contentItem: RowLayout {
        Kirigami.Avatar {
            id: avatar
            height: parent.height
            implicitHeight: parent.height // FIXME Kirigami.Avatar doesn't properly propagate
                                          // its implicitHeight and implicitWidth
            implicitWidth: implicitHeight
            name: listItem.name
            imageMode: Kirigami.Avatar.ImageMode.AdaptiveImageOrInitals
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
