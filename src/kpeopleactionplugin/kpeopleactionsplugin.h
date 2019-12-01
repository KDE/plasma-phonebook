/*
 * Copyright (C) 2019 Bhushan Shah <bshah@kde.org>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
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
