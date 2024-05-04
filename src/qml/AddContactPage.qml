/*
 *   SPDX-FileCopyrightText: 2019 Nicolas Fella <nicolas.fella@gmx.de>
 *
 *   SPDX-License-Identifier: LGPL-2.0-or-later
 */

import QtQuick
import QtQuick.Controls as Controls
import QtQuick.Layouts
import QtQuick.Templates as T

import Qt.labs.platform
import Qt5Compat.GraphicalEffects

import org.kde.people as KPeople
import org.kde.kirigami as Kirigami
import org.kde.kirigamiaddons.formcard as FormCard

import org.kde.phonebook

FormCard.FormCardPage {
    id: root

    property QtObject person
    property var addressee: ContactController.emptyAddressee()

    property var pendingPhoneNumbers: addressee.phoneNumbers
    property var pendingEmails: addressee.emails
    property var pendingImpps: addressee.impps
    property var pendingPhoto: addressee.photo

    signal save()

    states: [
        State {
            name: "create"
            PropertyChanges { target: root; title: i18n("Adding contact") }
        },
        State {
            name: "update"
            PropertyChanges { target: root; title: i18n("Editing contact") }
        }
    ]

    enabled: !person || person.isEditable

    Controls.RoundButton {
        Layout.alignment: Qt.AlignHCenter
        Layout.topMargin: Kirigami.Units.gridUnit

        Kirigami.FormData.label: i18n("Photo")

        // Square button
        implicitWidth: Kirigami.Units.gridUnit * 5
        implicitHeight: implicitWidth

        contentItem: Item {
            id: icon

            Kirigami.Icon {
                id:image
                source: {
                    if (root.pendingPhoto.isEmpty) {
                        return "edit-image-face-add"
                    } else if (root.pendingPhoto.isIntern) {
                        return root.pendingPhoto.data
                    } else {
                        return root.pendingPhoto.url
                    }
                }
                anchors.fill: parent
                layer.enabled: true
                layer.effect: OpacityMask {
                    maskSource: mask
                }

                Connections {
                    target: root
                    function onSave() {
                        addressee.photo = root.pendingPhoto
                    }
                }
            }

            Rectangle {
                id: mask
                anchors.fill: parent
                visible: false
                radius: parent.height/2
            }
        }

        onClicked: fileDialog.open()

        FileDialog {
            id: fileDialog

            onAccepted: {
                root.pendingPhoto = ContactController.preparePhoto(currentFile)
            }
        }
    }

    Controls.Label{
        visible: root.pendingPhoto.isEmpty
        color: Kirigami.Theme.disabledTextColor
        text: i18n("Add profile picture")
        Layout.alignment: Qt.AlignHCenter
    }

    FormCard.FormCard {
        Layout.topMargin: Kirigami.Units.largeSpacing
        Layout.fillWidth: true

        FormCard.FormTextFieldDelegate{
            id: name
            label: i18n("Name")

            text: addressee.formattedName
            onAccepted: {
                addressee.formattedName = text
            }
            Connections {
                target: root
                function onSave() {
                    name.accepted()
                }
            }
        }
    }

    FormCard.FormCard {
        Layout.topMargin: Kirigami.Units.largeSpacing

        Repeater{
            model: pendingPhoneNumbers
            delegate:FormCard.FormTextFieldDelegate{
                id: phoneField

                required property var modelData
                required property int index

                label: i18n("Phone")
                text: modelData.number
                inputMethodHints: Qt.ImhDialableCharactersOnly
                onAccepted: {
                    root.pendingPhoneNumbers[index].number = text
                }
                onTextChanged: if (text == "") {
                    var newList = root.pendingPhoneNumbers.filter((value, index) => index != phoneField.index)
                    root.pendingPhoneNumbers = newList
                }

                Connections {
                    target: root
                    function onSave() {
                        phoneField.accepted()
                        addressee.phoneNumbers = root.pendingPhoneNumbers
                    }
                }
            }
        }
        FormCard.FormTextFieldDelegate{
            id: toAddPhone
            label: i18n("Phone")

            placeholderText: i18n("+1 555 2368")
            inputMethodHints: Qt.ImhDialableCharactersOnly
            onAccepted: {
                addressee.formattedName = text
            }
        }
        FormCard.FormDelegateSeparator { above: addPhone}
        FormCard.FormButtonDelegate {
            id: addPhone
            enabled: toAddPhone.text.length > 0
            text: i18n("Add phone number")
            leading: Kirigami.Icon{
                source: "list-add"
                implicitHeight: Kirigami.Units.gridUnit
            }
            onClicked: {
                var numbers = pendingPhoneNumbers
                numbers.push(ContactController.createPhoneNumber(toAddPhone.text))
                pendingPhoneNumbers = numbers
                toAddPhone.text = ""
            }
        }
    }

    FormCard.FormCard {
        Layout.topMargin: Kirigami.Units.largeSpacing

        data: Connections {
            target: root;
            function onSave() {
                if (toAddEmail.text !== "") {
                    var emails = root.pendingEmails
                    emails.push(ContactController.createEmail(toAddEmail.text))
                    root.pendingEmails = emails
                }

                addressee.emails = root.pendingEmails
            }
        }

        Repeater {
            model: root.pendingEmails
            delegate:FormCard.FormTextFieldDelegate{
                id: emailField

                required property var modelData
                required property int index


                label: i18n("Email")
                text: modelData.email
                inputMethodHints: Qt.ImhEmailCharactersOnly

                onAccepted: {
                    root.pendingEmails[index].email = text
                }
                onTextChanged: if(text == "") {
                    root.pendingEmails = root.pendingEmails.filter((value, index) => index != emailField.index)
                }

                Connections {
                    target: root
                    function onSave() {
                        textField.accepted()
                        addressee.emails = root.pendingEmails
                    }
                }
            }
        }
        FormCard.FormTextFieldDelegate{
            id: toAddEmail
            label: i18n("Email")

            placeholderText: i18n("user@example.org")
            inputMethodHints: Qt.ImhEmailCharactersOnly
            onAccepted: {
                addressee.formattedName = text
            }

        }
        FormCard.FormDelegateSeparator { above: addEmail}
        FormCard.FormButtonDelegate {
            id: addEmail
            enabled: toAddEmail.text.length > 0
            text: i18n("Add email address")
            leading: Kirigami.Icon{
                source: "list-add"
                implicitHeight: Kirigami.Units.gridUnit
            }
            onClicked: {
                var emails = root.pendingEmails
                emails.push(ContactController.createEmail(toAddEmail.text))
                root.pendingEmails = emails
                toAddEmail.text = ""
            }
        }
    }

    FormCard.FormCard {
        Layout.topMargin: Kirigami.Units.largeSpacing

        data: Connections {
            target: root;
            function onSave() {
                if (toAddImpp.text !== "") {
                    var impps = root.pendingImpps
                    impps.push(ContactController.createImpp(toAddImpp.text))
                    root.pendingImpps = impps
                }

                addressee.impps = root.pendingImpps
            }
        }

        Repeater{
            model: root.pendingImpps
            delegate:FormCard.FormTextFieldDelegate{
                id: imppField

                required property var modelData
                required property int index

                label: i18n("Instant Messenger")
                text: modelData.address
                inputMethodHints: Qt.ImhEmailCharactersOnly

                onAccepted: {
                    root.pendingImpps[index].address = text
                }
                onTextChanged: if (text === "") {
                    root.pendingImpps = root.pendingImpps.filter((value, index) => index !== imppField.index)
                }
            }
        }
        FormCard.FormTextFieldDelegate {
            id: toAddImpp
            label: i18n("Instant Messenger")

            placeholderText: i18n("protocol:person@example.com")
            inputMethodHints: Qt.ImhEmailCharactersOnly

            Connections {
                target: root
                function onSave() {
                    if (toAddImpp.text !== "") {
                        var impps = pendingImpps
                        impps.push(ContactController.createImpp(toAddImpp.text))
                        root.pendingImpps = impps
                    }

                    addressee.impps = root.pendingImpps
                }
            }
        }
        FormCard.FormDelegateSeparator { above: addImpp}
        FormCard.FormButtonDelegate {
            id: addImpp
            text: i18n("Add instant messenger address")
            enabled: toAddImpp.text.length > 0
            leading: Kirigami.Icon{
                source: "list-add"
                implicitHeight: Kirigami.Units.gridUnit
            }
            onClicked: {
                var impps = root.pendingImpps
                impps.push(ContactController.createImpp(toAddImpp.text))
                pendingImpps = impps
                toAddImpp.text = ""
            }
        }
    }

    FormCard.FormCard {
        Layout.topMargin: Kirigami.Units.largeSpacing

        FormCard.FormDateTimeDelegate {
            text: i18n("Birthday")
            value: addressee.birthday
            dateTimeDisplay: FormCard.FormDateTimeDelegate.DateTimeDisplay.Date

            Connections {
                target: root
                function onSave() {
                    addressee.birthday = birthday.value // TODO birthday is not writable
                }
            }
        }
    }

    FormCard.FormCard {
        Layout.topMargin: Kirigami.Units.largeSpacing

        FormCard.AbstractFormDelegate {
            contentItem: ColumnLayout {
                Controls.Label {
                    text: i18n("Note:")
                    Layout.fillWidth: true
                }

                Controls.TextArea {
                    id: note
                    text: addressee.note
                    Layout.fillWidth: true

                    Connections {
                        target: root
                        function onSave() {
                            addressee.note = note.text
                        }
                    }
                }
            }
        }
    }

    footer: T.Control {
        id: footerToolBar

        implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                                implicitContentWidth + leftPadding + rightPadding)
        implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                                implicitContentHeight + topPadding + bottomPadding)

        leftPadding: Kirigami.Units.smallSpacing
        rightPadding: Kirigami.Units.smallSpacing
        bottomPadding: Kirigami.Units.smallSpacing
        topPadding: Kirigami.Units.smallSpacing + footerSeparator.implicitHeight

        contentItem: RowLayout {
            spacing: parent.spacing

            // footer buttons
            Controls.DialogButtonBox {
                // we don't explicitly set padding, to let the style choose the padding
                id: dialogButtonBox
                standardButtons: Controls.DialogButtonBox.Close | Controls.DialogButtonBox.Save

                Layout.fillWidth: true
                Layout.alignment: dialogButtonBox.alignment

                position: Controls.DialogButtonBox.Footer

                onAccepted: {
                    root.save();
                    switch(root.state) {
                        case "create":
                            if (!KPeople.PersonPluginManager.addContact({ "vcard": ContactController.addresseeToVCard(addressee) }))
                                console.warn("could not create contact")
                            break;
                        case "update":
                            if (!root.person.setContactCustomProperty("vcard", ContactController.addresseeToVCard(addressee)))
                                console.warn("Could not save", addressee.url)
                            break;
                    }
                    root.closeDialog()
                }
                onRejected: root.closeDialog()
            }
        }

        background: Item {
            // separator above footer
            Kirigami.Separator {
                id: footerSeparator
                visible: root.contentItem.height < root.contentItem.flickableItem.contentHeight
                width: parent.width
                anchors.top: parent.top
            }
        }
    }
}
