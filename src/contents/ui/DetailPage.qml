/*
 *   SPDX-FileCopyrightText: 2018 Fabian Riethmayer
 *   SPDX-FileCopyrightText: 2021 Nicolas Fella <nicolas.fella@gmx.de>
 *
 *   SPDX-License-Identifier: LGPL-2.0-or-later
 */

import QtQuick 2.6
import QtQuick.Controls 2.13
import QtQuick.Layouts 1.2
import QtGraphicalEffects 1.0
import org.kde.people 1.0 as KPeople
import org.kde.kirigami 2.19 as Kirigami
import org.kde.phonebook 1.0
import org.kde.kirigamiaddons.labs.mobileform 0.1 as MobileForm

import "components"

Kirigami.ScrollablePage {
    property string personUri;
    id: page

    leftPadding: 0
    rightPadding: 0
    topPadding: 0

    title: personData.person.name
    Kirigami.Theme.colorSet: Kirigami.Theme.Window

    function callNumber(number) {
        Qt.openUrlExternally("tel:" + number)
    }

    function sendSms(number) {
        Qt.openUrlExternally("sms:" + number)
    }

    KPeople.PersonData {
        id: personData
        personUri: page.personUri
    }

    KPeople.PersonActions {
        id: personActions
        personUri: page.personUri
    }

    property var addressee: ContactController.addresseeFromVCard(personData.person.contactCustomProperty("vcard"))
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
                KPeople.PersonPluginManager.deleteContact(page.personUri)
                pageStack.pop()
            }
        }
    }

    Component {
        id: callPopup

        PhoneNumberDialog {}
    }

    ColumnLayout {
        spacing:0
        Item {
            id:header
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
                gradient: Gradient{
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

                    Kirigami.Avatar {
                        id: avatar

                        height: parent.height
                        width: height

                        source: personData.photoImageProviderUri
                        name: personData.person.name
                        imageMode: Kirigami.Avatar.ImageMode.AdaptiveImageOrInitals
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
                        elide: Qt.ElideRight

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
        MobileForm.FormCard {
            visible: phoneNumberRepeater.count !==0
            Layout.topMargin: Kirigami.Units.largeSpacing
            Layout.fillWidth: true

            contentItem: ColumnLayout {
                spacing: 0
                Repeater{
                    id: phoneNumberRepeater
                    model: addressee.phoneNumbers
                    delegate:MobileForm.FormTextDelegate{
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
        }
        MobileForm.FormCard {
            visible: emailRepeater.count !==0
            Layout.topMargin: Kirigami.Units.largeSpacing
            Layout.fillWidth: true

            contentItem: ColumnLayout {
                spacing: 0
                Repeater{
                    id: emailRepeater
                    model: addressee.emails
                    delegate:MobileForm.FormTextDelegate{
                        trailing:Row{
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
        }
        MobileForm.FormCard {
            visible: imppRepeater.count !==0
            Layout.topMargin: Kirigami.Units.largeSpacing
            Layout.fillWidth: true

            contentItem: ColumnLayout {
                spacing: 0
                Repeater{
                    id: imppRepeater
                    model: addressee.impps
                    delegate:MobileForm.FormTextDelegate{
                        trailing:Row{
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
        }
        MobileForm.FormCard {
            visible: birthday.description !== ""
            Layout.topMargin: Kirigami.Units.largeSpacing
            Layout.fillWidth: true

            contentItem: ColumnLayout {
                spacing: 0

                MobileForm.FormTextDelegate{
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
        }
        MobileForm.FormCard {
            visible: addressee.note
            Layout.topMargin: Kirigami.Units.largeSpacing
            Layout.fillWidth: true

            contentItem: ColumnLayout {
                spacing: 0

                MobileForm.FormTextDelegate{
                    text: i18n("Note:")
                    description: {
                        return addressee.note
                    }
                }
            }
        }
        //makes sure the last item isnt behind the actions

        Item {
            height: 60
        }
    }
}
