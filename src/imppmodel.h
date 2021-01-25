/*
 * SPDX-FileCopyrightText: 2019 Aleix Pol Gonzalez <aleixpol@kde.org>
 *
 * SPDX-License-Identifier: GPL-2.0-only OR GPL-3.0-only OR LicenseRef-KDE-Accepted-GPL
 */

#ifndef IMPPMODEL_H
#define IMPPMODEL_H

#include <QAbstractListModel>

class Addressee;

class ImppModel : public QAbstractListModel
{
    Q_OBJECT
public:
    explicit ImppModel(Addressee *a);

    bool setData(const QModelIndex &index, const QVariant &value, int role) override;
    QVariant data(const QModelIndex &index, int role) const override;
    int rowCount(const QModelIndex &parent = {}) const override;

    Q_SCRIPTABLE void addImpp(const QString &address);
    Q_SCRIPTABLE void removeImpp(const QString &address);

private:
    Addressee *m_addressee;
};

#endif
