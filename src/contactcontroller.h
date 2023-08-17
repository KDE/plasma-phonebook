/*
 *   SPDX-FileCopyrightText: 2021 Nicolas Fella <nicolas.fella@gmx.de>
 *
 *   SPDX-License-Identifier: LGPL-2.0-or-later
 */

#pragma once

#include <QImage>
#include <QObject>
#include <QQmlEngine>
#include <QQuickWindow>

#include <KContacts/Addressee>
#include <KContacts/Email>
#include <KContacts/Impp>
#include <KContacts/PhoneNumber>
#include <KContacts/Picture>

#include <KSharedConfig>
#include <memory>

class QFileDialog;

class ContactController : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    QML_SINGLETON

    Q_PROPERTY(QString lastPersonUri READ lastPersonUri WRITE setLastPersonUri NOTIFY lastPersonUriChanged)

public:
    ContactController();

    QString lastPersonUri() const;
    void setLastPersonUri(const QString &lastPersonUri);

    Q_INVOKABLE void saveWindowGeometry(QQuickWindow *window);
    Q_INVOKABLE KContacts::Addressee addresseeFromVCard(const QByteArray &vcard);
    Q_INVOKABLE QByteArray addresseeToVCard(const KContacts::Addressee &addressee);
    Q_INVOKABLE KContacts::Addressee emptyAddressee();
    Q_INVOKABLE KContacts::Picture preparePhoto(const QUrl &url);
    Q_INVOKABLE KContacts::Email createEmail(const QString &email);
    Q_INVOKABLE KContacts::PhoneNumber createPhoneNumber(const QString &number);
    Q_INVOKABLE KContacts::Impp createImpp(const QString &address);

Q_SIGNALS:
    void lastPersonUriChanged();

private:
    KConfig m_dataResource;
};
