/*
 * Copyright 2019  Linus Jahn <lnj@kaidan.im>
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License as
 * published by the Free Software Foundation; either version 2 of
 * the License or (at your option) version 3 or any later version
 * accepted by the membership of KDE e.V. (or its successor approved
 * by the membership of KDE e.V.), which shall act as a proxy
 * defined in Section 14 of version 3 of the license.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

#include "phonebook.h"
#include <QDebug>
#include <QFile>
#include <QStandardPaths>
#include <QCryptographicHash>
#include <KContacts/Addressee>
#include <KContacts/VCardConverter>

using namespace KContacts;

PhoneBook::PhoneBook(QObject *parent) : QObject(parent)
{

}

void PhoneBook::addContact(QString name, QString tel)
{
    // addresses
    Addressee adr;
    adr.setName(name);
    PhoneNumber::List phoneNums;
    PhoneNumber phoneNum;
    phoneNum.setNumber(tel);
    phoneNum.setType(PhoneNumber::Cell);
    phoneNums.append(phoneNum);
    adr.setPhoneNumbers(phoneNums);

    // create vcard
    VCardConverter converter;
    QByteArray vcard = converter.createVCard(adr);
    qDebug() << vcard;

    // save vcard
    QString path = QStandardPaths::writableLocation(QStandardPaths::GenericDataLocation)
                   + ("/kpeoplevcard");
    QCryptographicHash hash(QCryptographicHash::Sha1);
    hash.addData(name.toUtf8());
    QFile file(path + "/" + hash.result().toHex() + ".vcf");
    if (!file.open(QFile::WriteOnly)) {
        qWarning() << "Couldn't save vCard: Couldn't open file for writing.";
        return;
    }
    file.write(vcard.data(), vcard.length());
    file.close();
}
