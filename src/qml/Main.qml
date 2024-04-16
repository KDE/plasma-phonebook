/*
 * SPDX-FileCopyrightText: 2019 Linus Jahn <lnj@kaidan.im>
 * SPDX-FileCopyrightText: 2019 Jonah Brüchert <jbb@kaidan.im>
 *
 * SPDX-License-Identifier: GPL-2.0-only OR GPL-3.0-only OR LicenseRef-KDE-Accepted-GPL
 */

import QtQuick 2.1
import org.kde.kirigami 2.4 as Kirigami
import QtQuick.Controls 2.0 as Controls

import org.kde.phonebook

Kirigami.ApplicationWindow {
    id: root

    title: i18n("Phonebook")

    width: Kirigami.Units.gridUnit * 65
    minimumWidth: Kirigami.Units.gridUnit * 15
    minimumHeight: Kirigami.Units.gridUnit * 20
    onClosing: ContactController.saveWindowGeometry(root)
    Component.onCompleted: if (!Kirigami.Settings.isMobile && ContactController.lastPersonUri) {
        pageStack.push(Qt.resolvedUrl("DetailPage.qml"), {
            personUri: ContactController.lastPersonUri
        });
    }

    pageStack.initialPage: ContactsPage {}

    pageStack.globalToolBar.style: Kirigami.ApplicationHeaderStyle.Titles
    pageStack.globalToolBar.showNavigationButtons: Kirigami.ApplicationHeaderStyle.ShowBackButton

    ContactImporter {
        id: importer
    }
}
