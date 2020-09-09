/*
 * SPDX-FileCopyrightText: 2019 Bhushan Shah <bshah@kde.org>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

#ifndef KPEOPLEACTIONSPLUGIN_H
#define KPEOPLEACTIONSPLUGIN_H

#include <KPeopleBackend/AbstractPersonAction>
#include <QObject>

class KPeopleActionsPlugin : public KPeople::AbstractPersonAction
{
    Q_OBJECT

public:
    KPeopleActionsPlugin(QObject *parent, const QVariantList &args);
    QList<QAction *> actionsForPerson(const KPeople::PersonData &data, QObject *parent) const override;
};

#endif // KPEOPLEACTIONSPLUGIN_H
