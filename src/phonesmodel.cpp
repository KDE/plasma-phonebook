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

#include "phonesmodel.h"
#include "declarativeaddressee.h"
#include <QDebug>

PhonesModel::PhonesModel(Addressee* a)
    : QAbstractListModel(a)
    , m_addressee(a)
{
    connect(a, &Addressee::urlChanged, this, [this] {
        beginResetModel();
        endResetModel();
    });
}

QVariant PhonesModel::data(const QModelIndex& index, int role) const
{
    if (!index.isValid() || index.row() < 0 || index.row() >= m_addressee->m_addressee.phoneNumbers().count()) {
        return {};
    }

    switch(role) {
        case Qt::DisplayRole:
            return m_addressee->m_addressee.phoneNumbers()[index.row()].number();
    }
    return {};
}

bool PhonesModel::setData(const QModelIndex& index, const QVariant& value, int role)
{
    if (!index.isValid() || index.row() < 0 || index.row() >= m_addressee->m_addressee.phoneNumbers().count()) {
        return false;
    }

    switch(role) {
        case Qt::DisplayRole: {
            auto numbers = m_addressee->m_addressee.phoneNumbers();
            numbers[index.row()].setNumber(value.toString());
            m_addressee->m_addressee.setPhoneNumbers(numbers);
            dataChanged(index, index, {Qt::DisplayRole});
        } return true;
    }
    return false;
}

int PhonesModel::rowCount(const QModelIndex& parent) const
{
    return parent.isValid() ? 0 : m_addressee->m_addressee.phoneNumbers().count();
}

void PhonesModel::addPhoneNumber(const QString& number)
{
    const int c = rowCount();
    beginInsertRows({}, c, c);
    m_addressee->m_addressee.insertPhoneNumber(number);
    endInsertRows();
}

void PhonesModel::removePhoneNumber(const QString &number)
{
    for (int i = 0; 0 < m_addressee->m_addressee.phoneNumbers().count(); i++) {
        if (m_addressee->m_addressee.phoneNumbers()[i].number() == number) {
            beginRemoveRows({}, i, i);
            break;
        }
    }

    for (const auto &phoneNumber : m_addressee->m_addressee.phoneNumbers()) {
        if (phoneNumber.number() == number) {
            m_addressee->m_addressee.removePhoneNumber(phoneNumber);
            break;
        }
    }

    endRemoveRows();
}
