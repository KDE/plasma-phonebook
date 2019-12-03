/*
 * Copyright 2019  Aleix Pol Gonzalez <aleixpol@kde.org>
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

#ifndef DECLARATIVE_ADDRESSEE_H
#define DECLARATIVE_ADDRESSEE_H

#include <KContacts/VCardConverter>
#include <QImage>
#include <QObject>

#define PROPERTY(type, name, setName)                                                                                                                                                                                                          \
    type name() const                                                                                                                                                                                                                          \
    {                                                                                                                                                                                                                                          \
        return m_addressee.name();                                                                                                                                                                                                             \
    }                                                                                                                                                                                                                                          \
    void setName(const type &(name))                                                                                                                                                                                                           \
    {                                                                                                                                                                                                                                          \
        if (m_addressee.name() == (name))                                                                                                                                                                                                      \
            return;                                                                                                                                                                                                                            \
        m_addressee.setName(name);                                                                                                                                                                                                             \
        name##Changed(name);                                                                                                                                                                                                                   \
        m_addressee.setChanged(true);                                                                                                                                                                                                          \
    }                                                                                                                                                                                                                                          \
    Q_SIGNAL void name##Changed(const type &(name));

class PhonesModel;
class ImppModel;

class Addressee : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QByteArray raw READ raw WRITE setRaw)
public:
    Addressee(QObject *parent = nullptr);

    Q_PROPERTY(QString realName READ realName NOTIFY anyNameChanged)
    QString realName() const
    {
        return m_addressee.realName();
    }

    Q_PROPERTY(QString name READ name WRITE setName NOTIFY nameChanged)
    PROPERTY(QString, name, setName)

    Q_PROPERTY(QString office READ office WRITE setOffice NOTIFY officeChanged)
    PROPERTY(QString, office, setOffice)

    Q_PROPERTY(PhonesModel *phoneNumbers READ phoneNumbers CONSTANT)
    PhonesModel *phoneNumbers() const;

    Q_PROPERTY(ImppModel *impps READ impps CONSTANT)
    ImppModel *impps() const;

    Q_PROPERTY(QImage photo READ photo WRITE setPhoto NOTIFY photoChanged)
    void setPhoto(QImage &data);
    QImage photo();

    Q_PROPERTY(QStringList emails READ emails WRITE setEmails NOTIFY emailsChanged)
    PROPERTY(QStringList, emails, setEmails)

    Q_SCRIPTABLE void insertEmail(const QString &email)
    {
        m_addressee.insertEmail(email);
        Q_EMIT emailsChanged(emails());
    }

    Q_SCRIPTABLE void removeEmail(const QString &email)
    {
        m_addressee.removeEmail(email);
        Q_EMIT emailsChanged(emails());
    }

    Q_SCRIPTABLE void addPhotoFromFile(const QString &path);

    QByteArray raw() const;
    void setRaw(const QByteArray &raw);

Q_SIGNALS:
    void urlChanged(const QUrl &url);
    void anyNameChanged();
    void phoneNumbersChanged();
    void photoChanged();

private:
    friend class PhonesModel;
    friend class ImppModel;
    KContacts::Addressee m_addressee;
    PhonesModel *m_phonesModel = nullptr;
    ImppModel *m_imppModel = nullptr;
};

#endif
