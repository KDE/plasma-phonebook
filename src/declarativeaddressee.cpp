/*
 * Copyright 2019  Aleix Pol Gonzalez <aleixpol@kde.org>
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License as
 * published by the Free Software Foundation; either version 2 of
 * the License or (at your option) version 3 or any later version
 * accepted by the membership of KDE e.V. (or its successor approved
 * by the membership of KDE e.V.), which shall act as a proxy
 * defined in Section 14 of version 3 of the license.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

#include "declarativeaddressee.h"
#include <QDebug>
#include <QStandardPaths>
#include <QCryptographicHash>
#include <QFile>
#include "phonesmodel.h"

void Addressee::setUrl(const QUrl& url)
{
    if (m_url != url) {
        if (!url.isLocalFile()) {
            qWarning() << "uri of contact to update is not local, cannot update.";
            return;
        }

        QFile file(url.path());
        if (!file.open(QIODevice::ReadOnly)) {
            qWarning() << "Couldn't read vCard: Couldn't open file" << url;
            return;
        }

        m_url = url;

        KContacts::VCardConverter converter;
        const auto contents = file.readAll();
        m_addressee = converter.parseVCard(contents);

        Q_EMIT urlChanged(url);
        Q_EMIT nameChanged(name());
        Q_EMIT anyNameChanged();
        Q_EMIT phoneNumbersChanged();
        Q_EMIT emailsChanged(emails());
    }
}

bool Addressee::write()
{
    // create vcard
    KContacts::VCardConverter converter;
    QByteArray vcard = converter.createVCard(m_addressee);

    // save vcard
    if (m_url.isEmpty()) {
        QCryptographicHash hash(QCryptographicHash::Sha1);
        hash.addData(m_addressee.name().toUtf8());
        QString path = QStandardPaths::writableLocation(QStandardPaths::GenericDataLocation) + QStringLiteral("/kpeoplevcard/") + hash.result().toHex() + ".vcf";

        m_url = QUrl::fromLocalFile(path);
    }
    QFile file(m_url.toLocalFile());
    if (!file.open(QFile::WriteOnly)) {
        qWarning() << "Couldn't save vCard: Couldn't open file for writing.";
        return false;
    }
    file.write(vcard.data(), vcard.length());
    file.close();
    return true;
}

PhonesModel* Addressee::phoneNumbers() const
{
    return m_phonesModel;
}

Addressee::Addressee(QObject* parent)
    : QObject(parent)
    , m_phonesModel(new PhonesModel(this))
{
    connect(this, &Addressee::nameChanged, this, &Addressee::anyNameChanged);
}
