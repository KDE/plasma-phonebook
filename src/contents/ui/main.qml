/*
 * SPDX-FileCopyrightText: 2019 Linus Jahn <lnj@kaidan.im>
 * SPDX-FileCopyrightText: 2019 Jonah Brüchert <jbb@kaidan.im>
 *
 * SPDX-License-Identifier: GPL-2.0-only OR GPL-3.0-only OR LicenseRef-KDE-Accepted-GPL
 */

import QtQuick 2.1
import org.kde.kirigami 2.4 as Kirigami
import QtQuick.Controls 2.0 as Controls

import org.kde.phonebook 1.0

Kirigami.ApplicationWindow {
    id: root

    title: i18n("Phonebook")

    pageStack.initialPage: contactsPage
    pageStack.globalToolBar.canContainHandles: true

    contextDrawer: Kirigami.ContextDrawer {
        id: contextDrawer
    }

    Component { id: contactsPage; ContactsPage {}}
    Component { id: detailPage; DetailPage {}}

    ContactImporter {
        id: importer
    }
}
