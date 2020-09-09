/*
 * SPDX-FileCopyrightText: 2019 Jonah Brüchert <jbb@kaidan.im>
 *
 * SPDX-License-Identifier: GPL-2.0-only OR GPL-3.0-only OR LicenseRef-KDE-Accepted-GPL
 */

#ifndef CONTACTIMPORTER_H
#define CONTACTIMPORTER_H

#include <KContacts/VCardConverter>
#include <QObject>

class ContactImporter : public QObject
{
    Q_OBJECT
public:
    explicit ContactImporter(QObject *parent = nullptr);
    Q_INVOKABLE void importVCards(const QUrl &path);

private:
    KContacts::VCardConverter m_converter;
};

#endif // CONTACTIMPORTER_H
