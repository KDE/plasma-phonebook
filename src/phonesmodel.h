/*
 * SPDX-FileCopyrightText: 2019 Aleix Pol Gonzalez <aleixpol@kde.org>
 *
 * SPDX-License-Identifier: GPL-2.0-only OR GPL-3.0-only OR LicenseRef-KDE-Accepted-GPL
 */

#ifndef PHONESMODEL_H
#define PHONESMODEL_H

#include <QAbstractListModel>

class Addressee;

class PhonesModel : public QAbstractListModel
{
    Q_OBJECT
public:
    explicit PhonesModel(Addressee *a);

    bool setData(const QModelIndex &index, const QVariant &value, int role) override;
    QVariant data(const QModelIndex &index, int role) const override;
    int rowCount(const QModelIndex &parent = {}) const override;

    Q_SCRIPTABLE void addPhoneNumber(const QString &number);
    Q_SCRIPTABLE void removePhoneNumber(const QString &number);

private:
    Addressee *m_addressee;
};

#endif
