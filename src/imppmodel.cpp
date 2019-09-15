/*
 * Copyright 2019  Aleix Pol Gonzalez <aleixpol@kde.org>
 * Copyright 2019  Jonah Brüchert <jbb@kaidan.im>
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

#include "imppmodel.h"
#include "declarativeaddressee.h"
#include <QDebug>

ImppModel::ImppModel(Addressee* a)
    : QAbstractListModel(a)
    , m_addressee(a)
{
    connect(a, &Addressee::urlChanged, this, [this] {
        beginResetModel();
        endResetModel();
    });
}

QVariant ImppModel::data(const QModelIndex& index, int role) const
{
    if (!index.isValid() || index.row() < 0 || index.row() >= m_addressee->m_addressee.imppList().count()) {
        return {};
    }

    switch(role) {
        case Qt::DisplayRole:
            return m_addressee->m_addressee.imppList()[index.row()].address();
    }
    return {};
}

bool ImppModel::setData(const QModelIndex& index, const QVariant& value, int role)
{
    if (!index.isValid() || index.row() < 0 || index.row() >= m_addressee->m_addressee.imppList().count()) {
        return false;
    }

    switch(role) {
        case Qt::DisplayRole: {
            auto impps = m_addressee->m_addressee.imppList();
            impps[index.row()].setAddress(value.toString());
            m_addressee->m_addressee.setImppList(impps);
            dataChanged(index, index, {Qt::DisplayRole});
        } return true;
    }
    return false;
}

int ImppModel::rowCount(const QModelIndex& parent) const
{
    return parent.isValid() ? 0 : m_addressee->m_addressee.imppList().count();
}

void ImppModel::addImpp(const QString& address)
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
    for (int i = 0; 0 < m_addressee->m_addressee.imppList().count(); i++) {
        if (m_addressee->m_addressee.imppList()[i].address() == address) {
            beginRemoveRows({}, i, i);
            m_addressee->m_addressee.imppList().remove(i);
            break;
        }
    }

    endRemoveRows();
}
