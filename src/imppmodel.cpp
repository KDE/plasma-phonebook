/*
 * SPDX-FileCopyrightText: 2019 Aleix Pol Gonzalez <aleixpol@kde.org>
 * SPDX-FileCopyrightText: 2019 Jonah Brüchert <jbb@kaidan.im>
 *
 * SPDX-License-Identifier: GPL-2.0-only OR GPL-3.0-only OR LicenseRef-KDE-Accepted-GPL
 */

#include "imppmodel.h"
#include "declarativeaddressee.h"

ImppModel::ImppModel(Addressee *a)
    : QAbstractListModel(a)
    , m_addressee(a)
{
    connect(a, &Addressee::urlChanged, this, [this] {
        beginResetModel();
        endResetModel();
    });
}

QVariant ImppModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid() || index.row() < 0 || index.row() >= m_addressee->m_addressee.imppList().count()) {
        return {};
    }

    switch (role) {
    case Qt::DisplayRole:
        return m_addressee->m_addressee.imppList().at(index.row()).address();
    }
    return {};
}

bool ImppModel::setData(const QModelIndex &index, const QVariant &value, int role)
{
    if (!index.isValid() || index.row() < 0 || index.row() >= m_addressee->m_addressee.imppList().count()) {
        return false;
    }

    switch (role) {
    case Qt::DisplayRole: {
        auto impps = m_addressee->m_addressee.imppList();
        impps[index.row()].setAddress(value.toString());
        m_addressee->m_addressee.setImppList(impps);
        emit dataChanged(index, index, {Qt::DisplayRole});
    }
        return true;
    }
    return false;
}

int ImppModel::rowCount(const QModelIndex &parent) const
{
    return parent.isValid() ? 0 : m_addressee->m_addressee.imppList().count();
}

void ImppModel::addImpp(const QString &address)
{
    const int c = rowCount();

    // Construct IMPP
    auto impp = KContacts::Impp();
    impp.setAddress(address);

    beginInsertRows({}, c, c);
    m_addressee->m_addressee.insertImpp(impp);
    endInsertRows();
}

void ImppModel::removeImpp(const QString &address)
{
    // Find Impp object belonging to the address and remove it.
    auto imppList = m_addressee->m_addressee.imppList();
    const auto impp = std::find_if(imppList.begin(), imppList.end(), [&](const KContacts::Impp &impp) {
        return impp.address() == address;
    });

    const int index = std::distance(imppList.begin(), impp);
    imppList.remove(index);

    beginRemoveRows({}, index, index);
    m_addressee->m_addressee.setImppList(imppList);
    endRemoveRows();
}
