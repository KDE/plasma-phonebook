/*
 *   SPDX-FileCopyrightText: 2018 Fabian Riethmayer
 *   SPDX-FileCopyrightText: 2021 Nicolas Fella <nicolas.fella@gmx.de>
 *
 *   SPDX-License-Identifier: LGPL-2.0-or-later
 */

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import org.kde.people as KPeople
import org.kde.kirigami as Kirigami
import org.kde.phonebook
import org.kde.kirigamiaddons.formcard as FormCard
import org.kde.kirigamiaddons.components as Components

import "components"

FormCard.FormCardPage {
    id: page

    property string personUri
    property var addressee: ContactController.addresseeFromVCard(personData.person.contactCustomProperty("vcard"))

    title: personData.person.name

    function callNumber(number) {
        Qt.openUrlExternally("tel:" + number)
    }

    function sendSms(number) {
        Qt.openUrlExternally("sms:" + number)
    }

    data: [
        KPeople.PersonData {
            id: personData
            personUri: page.personUri
        },

        KPeople.PersonActions {
            id: personActions
            personUri: page.personUri
        },

        DoubleActionButton {
            parent: overlay
            x: page.width - width - margin
            y: page.height - height - pageStack.globalToolBar.preferredHeight - margin
            rightAction: Kirigami.Action {
                text: i18n("Edit")
                icon.name: "document-edit"
                onTriggered: pageStack.pushDialogLayer(Qt.resolvedUrl("AddContactPage.qml"), {state: "update", person: personData.person, addressee: page.addressee})
            }
            leftAction: Kirigami.Action {
                text: i18n("Delete contact")
                icon.name: "delete"
                onTriggered: {
                    removeDialog.open()
                }
            }
        },

        Kirigami.Dialog {
            id: removeDialog
            standardButtons: Kirigami.Dialog.Yes | Kirigami.Dialog.Cancel
            title: i18n("Remove Contact")
            RowLayout {
                Kirigami.Icon {
                    source: "dialog-warning"
                    Layout.margins: Kirigami.Units.largeSpacing
                }

                Label {
                    Layout.fillWidth: true
                    Layout.margins: Kirigami.Units.largeSpacing
                    text: i18n("Are you sure you want to delete <b>%1</b> from your Contacts?", personData.person.name)
                    wrapMode: Text.WordWrap
                }
            }
            onRejected: {
                close()
            }
            onAccepted: {
                KPeople.PersonPluginManager.deleteContact(page.personUri)
                pageStack.pop()
            }
        }
    ]


    Item {
        id: header
        height: 170
        Layout.fillWidth: true

        Item {
            anchors.fill: parent

            Rectangle {
                anchors.fill: parent
                color: avatar.color
                opacity: 0.2

            }
            Image {
                visible: personData.photoImageProviderUri
                scale: 1.8
                anchors.fill: parent
                asynchronous: true

                source: personData.photoImageProviderUri
                fillMode: Image.PreserveAspectCrop

                sourceSize.width: 512
                sourceSize.height: 512
            }

            layer.enabled: true
            layer.effect: HueSaturation {
                cached: true

                saturation: 1.9

                layer.enabled: true
                layer.effect: FastBlur {
                    cached: true
                    radius: 100
                }
            }
        }

        Rectangle {
            anchors.fill: parent
            gradient: Gradient {
                GradientStop { position: -1.0; color: "transparent" }
                GradientStop { position: 1.0; color: Kirigami.Theme.backgroundColor }
            }
        }

        RowLayout {
            anchors.fill: parent
            RowLayout {
                Layout.maximumWidth: Kirigami.Units.gridUnit * 30
                Layout.alignment: Qt.AlignHCenter


                Kirigami.ShadowedRectangle {
                    color: Kirigami.Theme.backgroundColor
                    Layout.margins: 30
                    width: 120
                    height: width
                    radius: width/2
                    shadow.size: 15
                    shadow.xOffset: 5
                    shadow.yOffset: 5
                    shadow.color: Qt.rgba(0, 0, 0, 0.2)

                    Components.Avatar {
                        id: avatar

                        height: parent.height
                        width: height

                        source: personData.photoImageProviderUri
                        name: personData.person.name
                        imageMode: Components.Avatar.ImageMode.AdaptiveImageOrInitals
                    }

                }
                ColumnLayout {
                    Layout.leftMargin: 10
                    Layout.rightMargin: 10
                    Layout.fillWidth: true

                    Label {
                        Layout.fillWidth: true
                        text: personData.person.name
                        font.bold: true
                        font.pixelSize: 22
                        maximumLineCount: 2
                        wrapMode: Text.Wrap
                        elide: Text.ElideRight

                    }
                    Label {
                        Layout.fillWidth: true
                        text: personData.person.contactCustomProperty("phoneNumber") ? personData.person.contactCustomProperty("phoneNumber") : ""
                        elide: Qt.ElideRight
                        color: Kirigami.Theme.disabledTextColor

                    }
                }
            }
        }
    }

    FormCard.FormCard {
        visible: phoneNumberRepeater.count !== 0
        Layout.topMargin: Kirigami.Units.largeSpacing

        Repeater {
            id: phoneNumberRepeater
            model: addressee.phoneNumbers
            delegate:FormCard.FormTextDelegate{
                trailing:Row{
                    ToolButton {
                        text: i18n("Call")
                        icon.name: "call-start"
                        onClicked: page.callNumber(modelData.normalizedNumber)
                        display: AbstractButton.IconOnly

                    }
                    ToolButton {
                        text: i18n("Send SMS")
                        icon.name: "mail-message"
                        onClicked: page.sendSms(modelData.normalizedNumber)
                        display: AbstractButton.IconOnly


                    }
                }
                text: modelData.typeLabel
                description: modelData.number
            }
        }
    }

    FormCard.FormCard {
        visible: emailRepeater.count !== 0

        Layout.topMargin: Kirigami.Units.largeSpacing

        Repeater{
            id: emailRepeater
            model: addressee.emails
            delegate: FormCard.FormTextDelegate {
                trailing: Row {
                    ToolButton {
                        text: i18n("Send E-Mail")
                        icon.name: "mail-message"
                        onClicked: Qt.openUrlExternally("mailto:" + modelData.email)
                        display: AbstractButton.IconOnly
                    }
                }
                text: i18n("E-Mail")
                description: modelData.email
            }
        }
    }

    FormCard.FormCard {
        visible: imppRepeater.count !== 0
        Layout.topMargin: Kirigami.Units.largeSpacing

        Repeater {
            id: imppRepeater
            model: addressee.impps
            delegate: FormCard.FormTextDelegate {
                trailing:Row {
                    ToolButton {
                        text: i18n("Send Message")
                        icon.name: modelData.serviceIcon
                        onClicked: Qt.openUrlExternally(modelData.address)
                        display: AbstractButton.IconOnly

                    }
                }
                text: modelData.serviceLabel
                description: modelData.address
            }
        }
    }

    FormCard.FormCard {
        visible: birthday.description !== ""

        FormCard.FormTextDelegate{
            id: birthday
            text: i18n("Birthday")
            description: {
                // We do not always have the year
                if (addressee.birthday.getFullYear() === 0) {
                    return Qt.formatDate(addressee.birthday, "dd.MM.")
                } else {
                    return Qt.formatDate(addressee.birthday)
                }
            }
        }
    }

    FormCard.FormCard {
        visible: addressee.note
        FormCard.FormTextDelegate{
            text: i18n("Note:")
            description: {
                return addressee.note
            }
        }
    }

    //makes sure the last item isnt behind the actions

    Item {
        Layout.preferredHeight: 60
    }
}
