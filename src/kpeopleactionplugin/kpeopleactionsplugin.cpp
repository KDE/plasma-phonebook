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

#include <KLocalizedString>
#include <QDebug>
#include <QDesktopServices>

#include <KPluginFactory>

#include <KContacts/VCardConverter>
#include <KPeople/Widgets/Actions>
#include <KPeopleBackend/AbstractContact>

KPeopleActionsPlugin::KPeopleActionsPlugin(QObject *parent, const QVariantList &args)
    : AbstractPersonAction(parent)
{
    Q_UNUSED(args)
}

QList<QAction *> KPeopleActionsPlugin::actionsForPerson(const KPeople::PersonData &data, QObject *parent) const
{
    Q_UNUSED(parent)
    QList<QAction *> actions;

    // Fetch contact vcard
    QByteArray vcard = data.contactCustomProperty(KPeople::AbstractContact::VCardProperty).toByteArray();
    KContacts::VCardConverter converter;
    const auto addressee = converter.parseVCard(vcard);

    // Phone Number actions
    // TODO: Avoid looping through numbers multiple times by using a SortFilterProxyModel in phonebook.
    const auto phoneNumbers = addressee.phoneNumbers();
    for (const auto &number : phoneNumbers) {
        if (!number.number().isEmpty()) {
            QAction *action = new QAction(QIcon::fromTheme(QStringLiteral("call-start")), i18nc("Action to tell user to call person using phone number", "Call on %1", number.number()));
            action->setProperty("actionType", KPeople::AudioCallAction);

            connect(action, &QAction::triggered, [=]() { QDesktopServices::openUrl(QStringLiteral("tel:") + number.number()); });

            actions << action;
        }
    }

    for (const auto &number : phoneNumbers) {
        if (!number.number().isEmpty()) {
            QAction *action = new QAction(QIcon::fromTheme(QStringLiteral("mail-message")), i18nc("Action to tell user to write a message to phone number", "Write SMS on %1", number.number()));
            action->setProperty("actionType", KPeople::TextChatAction);

            connect(action, &QAction::triggered, [=]() { QDesktopServices::openUrl(QStringLiteral("sms:") + number.number()); });

            actions << action;
        }
    }

    // Instant messenger actions
    const auto imppList = addressee.imppList();
    for (const auto &impp : imppList) {
        QAction *action = new QAction(QIcon::fromTheme(impp.serviceIcon()), i18nc("Action to write to instant messanger contact", "%1 %2", KContacts::Impp::serviceLabel(impp.serviceType()), impp.address().toString()));
        action->setProperty("actionType", KPeople::TextChatAction);

        connect(action, &QAction::triggered, [=]() { QDesktopServices::openUrl(impp.address().toString()); });

        actions << action;
    }

    // email actions
    const auto emails = addressee.emails();
    for (const auto &email : emails) {
        QAction *action = new QAction(QIcon::fromTheme(QStringLiteral("mail-message")), i18nc("Action to send an email", "email %1", email));
        action->setProperty("actionType", KPeople::SendEmailAction);

        connect(action, &QAction::triggered, [=]() { QDesktopServices::openUrl(QStringLiteral("mailto:") + email); });

        actions << action;
    }

    return actions;
}

K_PLUGIN_FACTORY_WITH_JSON(KPeopleActionsPluginFactory, "phonebook_kpeople_plugin.json", registerPlugin<KPeopleActionsPlugin>();)

#include "kpeopleactionsplugin.moc"
