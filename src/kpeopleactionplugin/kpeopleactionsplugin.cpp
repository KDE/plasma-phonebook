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
#include <QDesktopServices>
#include <KLocalizedString>

#include <KPluginFactory>

#include <KPeopleBackend/AbstractContact>
#include <KPeople/Widgets/Actions>
#include <KContacts/VCardConverter>

KPeopleActionsPlugin::KPeopleActionsPlugin(QObject* parent, const QVariantList& args)
    : AbstractPersonAction(parent)
{
    Q_UNUSED(args)
}

QList<QAction *> KPeopleActionsPlugin::actionsForPerson(const KPeople::PersonData& data, QObject* parent) const
{
    Q_UNUSED(parent)
    QList<QAction *> actions;

    // Fetch contact vcard
    QByteArray vcard = data.contactCustomProperty(KPeople::AbstractContact::VCardProperty).toByteArray();
    KContacts::VCardConverter converter;
    auto addressee = converter.parseVCard(vcard);

    // Phone Number actions
    // TODO: Avoid looping through numbers multiple times by using a SortFilterProxyModel in phonebook.
    for (auto &number : addressee.phoneNumbers()) {
        if (!number.number().isEmpty()) {
            QAction *action = new QAction(QIcon::fromTheme(QStringLiteral("call-start")),
                                          i18nc("Action to tell user to call person using phone number", "Call on %1", number.number()));
            action->setProperty("actionType", KPeople::AudioCallAction);

            connect(action, &QAction::triggered, [=]() {
                QDesktopServices::openUrl(QStringLiteral("tel:") + number.number());
            });

            actions << action;
        }
    }

    for (auto &number : addressee.phoneNumbers()) {
        if (!number.number().isEmpty()) {

            QAction *action = new QAction(QIcon::fromTheme(QStringLiteral("mail-message")),
                                          i18nc("Action to tell user to write a message to phone number", "Write SMS on %1", number.number()));
            action->setProperty("actionType", KPeople::TextChatAction);

            connect(action, &QAction::triggered, [=]() {
                QDesktopServices::openUrl(QStringLiteral("sms:") + number.number());
            });

            actions << action;
        }
    }

    // Instant messenger actions
    for (auto &impp : addressee.imppList()) {
        QAction *action = new QAction(QIcon::fromTheme(impp.serviceIcon()),
                                      i18nc("Action to write xmpp message", "%1 %2", impp.serviceType(), impp.address().toString()));
        action->setProperty("actionType", KPeople::TextChatAction);

        connect(action, &QAction::triggered, [=]() {
            QDesktopServices::openUrl(impp.address().toString());
        });

        actions << action;
    }

    // email actions
    for (auto &email : addressee.emails()) {
        QAction *action = new QAction(QIcon::fromTheme(QStringLiteral("mail-message")), i18nc("Action to send an email", "email %1", email));
        action->setProperty("actionType", KPeople::SendEmailAction);

        connect(action, &QAction::triggered, [=]() {
            QDesktopServices::openUrl(QStringLiteral("mailto:") + email);
        });

        actions << action;
    }

    return actions;
}

K_PLUGIN_FACTORY_WITH_JSON( KPeopleActionsPluginFactory, "phonebook_kpeople_plugin.json", registerPlugin<KPeopleActionsPlugin>(); )

#include "kpeopleactionsplugin.moc"