#include "contactimporter.h"

#include <QDebug>
#include <QFile>

#include <KContacts/VCardConverter>
#include <KPeople/PersonPluginManager>

ContactImporter::ContactImporter(QObject *parent) : QObject(parent)
{
}

void ContactImporter::importVCards(const QUrl &path)
{
    QFile inputFile(path.toLocalFile());

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
