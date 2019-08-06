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

void Addressee::setRaw(const QByteArray& raw)
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
