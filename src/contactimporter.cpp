/*
 * SPDX-FileCopyrightText: 2019 Jonah Brüchert <jbb@kaidan.im>
 *
 * SPDX-License-Identifier: GPL-2.0-only OR GPL-3.0-only OR LicenseRef-KDE-Accepted-GPL
 */

#include "contactimporter.h"

#include <QDebug>
#include <QFile>

#include <KContacts/VCardConverter>
#include <KPeople/PersonPluginManager>

ContactImporter::ContactImporter(QObject *parent)
    : QObject(parent)
{
}

void ContactImporter::importVCards(const QUrl &path)
{
#ifdef Q_OS_ANDROID
    QFile inputFile(path.toString());
#else
    QFile inputFile(path.toLocalFile());
#endif

    if (!inputFile.open(QIODevice::ReadOnly)) {
        qWarning() << "Couldn't read vCard to import: Couldn't open file for reading";
        return;
    }

    auto const importedVCards = m_converter.parseVCards(inputFile.readAll());
    for (const auto &adr : importedVCards) {
        QVariantMap properties;
        properties[QStringLiteral("vcard")] = m_converter.exportVCard(adr, KContacts::VCardConverter::v3_0);
        KPeople::PersonPluginManager::addContact(properties);
    }
}
