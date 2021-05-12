/*
 * SPDX-FileCopyrightText: 2019 Fabian Riethmayer <fabian@web2.0-apps.de>
 *
 * SPDX-License-Identifier: GPL-2.0-only OR GPL-3.0-only OR LicenseRef-KDE-Accepted-GPL
 */

import QtQuick 2.6
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.2
import org.kde.kirigami 2.4 as Kirigami
import QtGraphicalEffects 1.0


Rectangle {
    id: root
    clip: true
    default property alias contents: content.data
    property alias content: contentContainer
    property alias stripContent: strip.data

    property var source
    property var backgroundSource

    // Background image
    Image {
        anchors.fill: parent
        id: bg
        source: root.backgroundSource
    }

    FastBlur {
        anchors.fill: bg
        source: bg
        radius: 48

        ColorOverlay {
            anchors.fill: parent
            source: parent
            color: "#66808080"
        }
    }


    // Container for the content of the header
    Item {
        anchors.fill: parent
        anchors.bottomMargin: strip.children.length > 0 ? strip.height : 0

        Item {
            id: contentContainer
            anchors.fill: parent
            anchors.margins: Kirigami.Units.gridUnit
            anchors.leftMargin: 200

            Kirigami.Icon {
                id: img
                source: root.source
                height: contentContainer.height
                width: contentContainer.height
            }
            Item {
                id: content
                height: childrenRect.height
                anchors.left: img.right
                anchors.leftMargin: Kirigami.Units.gridUnit
                anchors.bottom: img.bottom
            }
        }
    }

    Rectangle {
        id: strip
        color: "#66F0F0F0"
        anchors.bottom: parent.bottom;
        height: 2 * Kirigami.Units.gridUnit
        width: parent.width
        visible: children.length > 0
    }
}
