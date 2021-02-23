/*
 * SPDX-FileCopyrightText: 2019 Jonah Brüchert <jbb@kaidan.im>
 *
 * SPDX-License-Identifier: GPL-2.0-only OR GPL-3.0-only OR LicenseRef-KDE-Accepted-GPL
 */

#ifndef CONTACTIMPORTER_H
#define CONTACTIMPORTER_H

#include <KContacts/VCardConverter>
#include <QObject>
#include <QFileDialog>

class ContactImporter : public QObject
{
    Q_OBJECT
public:
    explicit ContactImporter(QObject *parent = nullptr);
    Q_INVOKABLE void startImport();

private:
    Q_SLOT void importVCards(const QUrl &path);

    std::unique_ptr<QFileDialog> m_dialog;
    KContacts::VCardConverter m_converter;
};

#endif // CONTACTIMPORTER_H
