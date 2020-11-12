/*
 * SPDX-FileCopyrightText: 2019 Aleix Pol Gonzalez <aleixpol@kde.org>
 *
 * SPDX-License-Identifier: GPL-2.0-only OR GPL-3.0-only OR LicenseRef-KDE-Accepted-GPL
 */

#include "phonesmodel.h"
#include "declarativeaddressee.h"
#include <QDebug>

PhonesModel::PhonesModel(Addressee *a)
    : QAbstractListModel(a)
    , m_addressee(a)
{
    connect(a, &Addressee::urlChanged, this, [this] {
        beginResetModel();
        endResetModel();
    });
}

QVariant PhonesModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid() || index.row() < 0 || index.row() >= m_addressee->m_addressee.phoneNumbers().count()) {
        return {};
    }

    switch (role) {
    case Qt::DisplayRole:
        return m_addressee->m_addressee.phoneNumbers().at(index.row()).number();
    }
    return {};
}

bool PhonesModel::setData(const QModelIndex &index, const QVariant &value, int role)
{
    if (!index.isValid() || index.row() < 0 || index.row() >= m_addressee->m_addressee.phoneNumbers().count()) {
        return false;
    }

    switch (role) {
    case Qt::DisplayRole: {
        auto numbers = m_addressee->m_addressee.phoneNumbers();
        numbers[index.row()].setNumber(value.toString());
        m_addressee->m_addressee.setPhoneNumbers(numbers);
        emit dataChanged(index, index, {Qt::DisplayRole});
    }
        return true;
    }
    return false;
}

int PhonesModel::rowCount(const QModelIndex &parent) const
{
    return parent.isValid() ? 0 : m_addressee->m_addressee.phoneNumbers().count();
}

void PhonesModel::addPhoneNumber(const QString &number)
{
    const int c = rowCount();
    beginInsertRows({}, c, c);
    m_addressee->m_addressee.insertPhoneNumber(number);
    endInsertRows();
}

void PhonesModel::removePhoneNumber(const QString &number)
{
    const auto phoneNumbers = m_addressee->m_addressee.phoneNumbers();

    const auto phoneNumber = std::find_if(phoneNumbers.begin(), phoneNumbers.end(), [&](const KContacts::PhoneNumber &entry) {
        return entry.number() == number;
    });

    const int index = std::distance(phoneNumbers.begin(), phoneNumber);

    beginRemoveRows({}, index, index);
    m_addressee->m_addressee.removePhoneNumber(*phoneNumber);
    endRemoveRows();
}
