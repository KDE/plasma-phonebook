// SPDX-FileCopyrightText: 2023 Mathis Brüchert <mbb@kaidan.im>
//
// SPDX-License-Identifier: GPL-2.0-only OR GPL-3.0-only OR LicenseRef-KDE-Accepted-GPL

import QtQuick 2.15
import QtQuick.Controls 2.15 as QQC2
import org.kde.kirigami 2.19 as Kirigami
import QtQuick.Layouts 1.15
import org.kde.phonebook

QQC2.Drawer {
    id: root

    property alias drawerContentItem: contents.children

    edge: Qt.BottomEdge
    x: 0
    width: applicationWindow().width
    height: contentItem.implicitHeight

    interactive: false
    background: Kirigami.ShadowedRectangle{
        corners.topRightRadius: 10
        corners.topLeftRadius: 10
        shadow.size: 20
        shadow.color: Qt.rgba(0, 0, 0, 0.5)
        color: Kirigami.Theme.backgroundColor

    }
    onAboutToShow: root.interactive = true
    onClosed: root.interactive = false

    contentItem: ColumnLayout {
        id: contents
        spacing: 0

        QQC2.Control {
            Layout.fillWidth: true
            Layout.fillHeight: true

            background: Kirigami.ShadowedRectangle{
                visible: headerContentItem
                color: Kirigami.Theme.backgroundColor
                corners {
                    topRightRadius: 10
                    topLeftRadius: 10
                }
                Layout.fillWidth: true
                Kirigami.Theme.colorSet: Kirigami.Theme.Header
            }

            contentItem: ColumnLayout {
                id: header
                spacing:0
                clip: true
                Rectangle {
                    Layout.margins: 5
                    radius:50
                    Layout.alignment: Qt.AlignHCenter
                    color: Kirigami.Theme.textColor
                    opacity: 0.5
                    width: 40
                    height: 4

                }
            }
        }

        Kirigami.Separator{
            anchors.bottom: parent.bottom
            width: parent.width
            Layout.bottomMargin: 2
        }
    }
}
