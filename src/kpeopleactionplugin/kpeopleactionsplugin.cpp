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

#include "kpeopleactionsplugin.h"

#include <QDebug>
#include <KLocalizedString>

#include <KPluginFactory>

#include <KPeopleBackend/AbstractContact>

KPeopleActionsPlugin::KPeopleActionsPlugin(QObject* parent, const QVariantList& args)
    : AbstractPersonAction(parent)
{
    Q_UNUSED(args)
}

QList<QAction *> KPeopleActionsPlugin::actionsForPerson(const KPeople::PersonData& data, QObject* parent) const
{
    Q_UNUSED(parent)
    QList<QAction *> actions;
    QVariant number = data.contactCustomProperty(KPeople::AbstractContact::PhoneNumberProperty);
    if(!number.toString().isEmpty()) {
        QAction *action = new QAction(QIcon::fromTheme("call-start"),
                                      i18nc("Action to tell user to call person using phone number", "Call %1 on %2", data.name(), number.toString()));
        actions << action;
    }
    return actions;
}

K_PLUGIN_FACTORY_WITH_JSON( KPeopleActionsPluginFactory, "phonebook_kpeople_plugin.json", registerPlugin<KPeopleActionsPlugin>(); )

#include "kpeopleactionsplugin.moc"
