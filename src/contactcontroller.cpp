/*
 *   SPDX-FileCopyrightText: 2021 Nicolas Fella <nicolas.fella@gmx.de>
 *
 *   SPDX-License-Identifier: LGPL-2.0-or-later
 */

#include "contactcontroller.h"

#include <KContacts/VCardConverter>

#include <QDebug>
#include <QFileDialog>
#include <QGuiApplication>

const static KContacts::VCardConverter converter;

KContacts::Addressee ContactController::addresseeFromVCard(const QByteArray &vcard)
{
    return converter.parseVCard(vcard);
}

QByteArray ContactController::addresseeToVCard(const KContacts::Addressee &addressee)
{
    return converter.createVCard(addressee);
}

KContacts::Addressee ContactController::emptyAddressee()
{
    return {};
}

KContacts::Picture ContactController::preparePhoto(const QUrl &path)
{
#ifdef Q_OS_ANDROID
    const QImage image(path.toString());
#else
    const QImage image(path.toLocalFile());
#endif
    // Scale the photo down to make sure contacts are not taking too
    // long time to load their photos
    constexpr int unscaledWidth = 200;
    const qreal scaleFactor = dynamic_cast<QGuiApplication *>(QCoreApplication::instance())->devicePixelRatio();
    const int avatarSize = int(unscaledWidth * scaleFactor);
    const QSize size(avatarSize, avatarSize);

    return KContacts::Picture(image.scaled(size, Qt::KeepAspectRatio, Qt::SmoothTransformation));
}

KContacts::Email ContactController::createEmail(const QString &email)
{
    return KContacts::Email(email);
}

KContacts::PhoneNumber ContactController::createPhoneNumber(const QString &number)
{
    return KContacts::PhoneNumber(number);
}

KContacts::Impp ContactController::createImpp(const QString &address)
{
    return KContacts::Impp(address);
}
