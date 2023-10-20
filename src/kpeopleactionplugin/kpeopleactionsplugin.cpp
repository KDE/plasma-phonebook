/*
 * SPDX-FileCopyrightText: 2019 Bhushan Shah <bshah@kde.org>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

#include "kpeopleactionsplugin.h"

#include <KLocalizedString>
#include <QDebug>
#include <QDesktopServices>

#include <KPluginFactory>

#include <KContacts/VCardConverter>
#include <KPeople/Actions>
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

    // Instant messenger actions
    const auto imppList = addressee.imppList();
    for (const auto &impp : imppList) {
        QAction *action = new QAction(
            QIcon::fromTheme(impp.serviceIcon()),
            i18nc("Action to write to instant messenger contact", "%1 %2", KContacts::Impp::serviceLabel(impp.serviceType()), impp.address().toString()));
        action->setProperty("actionType", KPeople::TextChatAction);

        connect(action, &QAction::triggered, [=]() {
            QDesktopServices::openUrl(impp.address());
        });

        actions << action;
    }

    return actions;
}

K_PLUGIN_FACTORY_WITH_JSON(KPeopleActionsPluginFactory, "phonebook_kpeople_plugin.json", registerPlugin<KPeopleActionsPlugin>();)

#include "kpeopleactionsplugin.moc"
