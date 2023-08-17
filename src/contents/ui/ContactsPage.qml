/*
 * SPDX-FileCopyrightText: 2015 Martin Klapetek <mklapetek@kde.org>
 * SPDX-FileCopyrightText: 2019 Linus Jahn <lnj@kaidan.im>
 * SPDX-FileCopyrightText: 2019 Jonah Brüchert <jbb@kaidan.im>
 *
 * SPDX-License-Identifier: GPL-2.0-only OR GPL-3.0-only OR LicenseRef-KDE-Accepted-GPL
 */

import QtQuick 2.15
import QtQuick.Controls 2.15 as Controls
import QtQuick.Layouts 1.7

import org.kde.kirigami 2.12 as Kirigami
import org.kde.people 1.0 as KPeople

import org.kde.phonebook 1.0

import "components"

Kirigami.ScrollablePage {
    id: root
    title: i18n("Phonebook")
    globalToolBarStyle: Kirigami.ApplicationHeaderStyle.None

    titleDelegate:ColumnLayout{
        Kirigami.AbstractApplicationHeader {
            Layout.margins: 0
            Layout.preferredHeight: pageStack.globalToolBar.preferredHeight
            Layout.maximumHeight: pageStack.globalToolBar.preferredHeight
            Layout.fillWidth: true
            id: applicationHeader
            width: root.width
            RowLayout{
                anchors.fill: parent
                Kirigami.SearchField {
                    Layout.margins: Kirigami.Units.mediumSpacing
                    Layout.rightMargin: 0
                    Layout.fillWidth: true
                    id: searchField
                    onTextChanged: filterModel.setFilterFixedString(text)
                }
                Controls.ToolButton{
                    Layout.margins: Kirigami.Units.mediumSpacing
                    Layout.leftMargin: 0
                    icon.name: "overflow-menu"
                    onClicked: optionsDrawer.open()
                    BottomDrawer{
                        id: optionsDrawer
                        drawerContentItem: ColumnLayout {
                            Repeater {
                                model: root.actions
                                delegate: Kirigami.BasicListItem{
                                    required property var modelData
                                    label: modelData.text
                                    icon: modelData.icon.name
                                    onClicked: {
                                        modelData.triggered()
                                        optionsDrawer.close()
                                        optionsDrawer.interactive = false

                                    }
                                }
                            }
                            Item {
                                Layout.fillHeight: true
                            }

                        }

                    }
                }
            }
        }
    }



    actions: [
        Kirigami.Action {
            icon.name: "document-import"
            text: i18n("Import contacts")
            onTriggered: {
                importer.startImport()
            }
        }
    ]
    ActionButton {
        parent: overlay
        x: root.width - width - margin
        y: root.height - height - pageStack.globalToolBar.preferredHeight - margin
        singleAction: Kirigami.Action {
            text: i18n("add Contact")
            icon.name: "list-add"
            onTriggered: pageStack.pushDialogLayer(Qt.resolvedUrl("AddContactPage.qml"), {state: "create"})
        }
    }

    ListView {
        id: contactsList

        property bool delegateSelected: false
        property string numberToCall

        reuseItems: true

        currentIndex: -1

        section.property: "display"
        section.criteria: ViewSection.FirstCharacter
        section.delegate: Kirigami.ListSectionHeader {text: section}
        clip: true
        model: KPeople.PersonsSortFilterProxyModel {
            id: filterModel
            filterRole: Qt.DisplayRole
            sortRole: Qt.DisplayRole
            filterCaseSensitivity: Qt.CaseInsensitive

            sourceModel: KPeople.PersonsModel {
                id: contactsModel
            }
            Component.onCompleted: sort(0)
        }

        Kirigami.PlaceholderMessage {
            anchors.centerIn: parent
            text: i18n("No contacts")
            icon.name: "contact-new"
            visible: contactsList.count === 0
        }

        delegate: ContactListItem {
            height: Kirigami.Units.gridUnit * 3
            name: model && model.display
            imageProviderUri: model && model.photoImageProviderUri

            onClicked: {
                pageStack.push("qrc:/DetailPage.qml", {
                    personUri: model.personUri
                })
                ContactController.lastPersonUri = model.personUri;
            }
        }
    }
}
