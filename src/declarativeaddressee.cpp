/*
 * SPDX-FileCopyrightText: 2019 Aleix Pol Gonzalez <aleixpol@kde.org>
 *
 * SPDX-License-Identifier: GPL-2.0-only OR GPL-3.0-only OR LicenseRef-KDE-Accepted-GPL
 */

#include "declarativeaddressee.h"
#include <KContacts/Picture>
#include <QFile>
#include <QGuiApplication>

#include "imppmodel.h"
#include "phonesmodel.h"

void Addressee::setRaw(const QByteArray &raw)
{
    KContacts::VCardConverter converter;
    m_addressee = converter.parseVCard(raw);

    Q_EMIT nameChanged(name());
    Q_EMIT anyNameChanged();
    Q_EMIT phoneNumbersChanged();
    Q_EMIT emailsChanged(emails());
}

QByteArray Addressee::raw() const
{
    KContacts::VCardConverter converter;
    return converter.createVCard(m_addressee);
}

PhonesModel *Addressee::phoneNumbers() const
{
    return m_phonesModel;
}

ImppModel *Addressee::impps() const
{
    return m_imppModel;
}

void Addressee::setPhoto(QImage &data)
{
    auto photo = m_addressee.photo();

    // Scale the photo down to make sure contacts are not taking too
    // long time to load their photos
    constexpr int unscaledWidth = 200;
    qreal scaleFactor = dynamic_cast<QGuiApplication *>(QCoreApplication::instance())->devicePixelRatio();
    auto avatarSize = int(unscaledWidth * scaleFactor);
    QSize size(avatarSize, avatarSize);

    photo.setData(data.scaled(size, Qt::KeepAspectRatio, Qt::SmoothTransformation));
    m_addressee.setPhoto(photo);
}

QImage Addressee::photo()
{
    return m_addressee.photo().data();
}

Q_SCRIPTABLE void Addressee::addPhotoFromFile(const QString &path)
{
#ifdef Q_OS_ANDROID
    QImage image(path);
#else
    QImage image(QUrl(path).toLocalFile());
#endif
    setPhoto(image);
}

Addressee::Addressee(QObject *parent)
    : QObject(parent)
    , m_phonesModel(new PhonesModel(this))
    , m_imppModel(new ImppModel(this))
{
    connect(this, &Addressee::nameChanged, this, &Addressee::anyNameChanged);
}
