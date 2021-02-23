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

void ContactImporter::startImport()
{
    m_dialog = std::make_unique<QFileDialog>();
    m_dialog->setFileMode(QFileDialog::ExistingFile);
    connect(m_dialog.get(), &QFileDialog::finished, this, [=] {
        const auto selectedFiles = m_dialog->selectedFiles();
        if (!selectedFiles.empty()) {
            importVCards(QUrl::fromLocalFile(m_dialog->selectedFiles().first()));
        }
    });
    m_dialog->open();
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

    const auto importedVCards = m_converter.parseVCards(inputFile.readAll());
    for (const auto &adr : importedVCards) {
        QVariantMap properties;
        properties[QStringLiteral("vcard")] = m_converter.exportVCard(adr, KContacts::VCardConverter::v3_0);
        KPeople::PersonPluginManager::addContact(properties);
    }
}
