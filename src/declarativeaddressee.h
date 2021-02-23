/*
 * SPDX-FileCopyrightText: 2019 Aleix Pol Gonzalez <aleixpol@kde.org>
 *
 * SPDX-License-Identifier: GPL-2.0-only OR GPL-3.0-only OR LicenseRef-KDE-Accepted-GPL
 */

#ifndef DECLARATIVE_ADDRESSEE_H
#define DECLARATIVE_ADDRESSEE_H

#include <KContacts/VCardConverter>
#include <QImage>
#include <QObject>

#include <memory>

class QFileDialog;

#define PROPERTY(type, name, setName)                                                                                                                          \
    type name() const                                                                                                                                          \
    {                                                                                                                                                          \
        return m_addressee.name();                                                                                                                             \
    }                                                                                                                                                          \
    void setName(const type &(name))                                                                                                                           \
    {                                                                                                                                                          \
        if (m_addressee.name() == (name))                                                                                                                      \
            return;                                                                                                                                            \
        m_addressee.setName(name);                                                                                                                             \
        name##Changed(name);                                                                                                                                   \
        m_addressee.setChanged(true);                                                                                                                          \
    }                                                                                                                                                          \
    Q_SIGNAL void name##Changed(const type &(name));

class PhonesModel;
class ImppModel;

class Addressee : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QByteArray raw READ raw WRITE setRaw NOTIFY rawChanged)
public:
    explicit Addressee(QObject *parent = nullptr);

    Q_PROPERTY(QString realName READ realName NOTIFY anyNameChanged)
    QString realName() const
    {
        return m_addressee.realName();
    }
    
    Q_PROPERTY(QDateTime birthday READ birthday WRITE setBirthday NOTIFY birthdayChanged)
    PROPERTY(QDateTime, birthday, setBirthday)

    Q_PROPERTY(QString name READ name WRITE setName NOTIFY nameChanged)
    PROPERTY(QString, name, setName)

    Q_PROPERTY(QString office READ office WRITE setOffice NOTIFY officeChanged)
    PROPERTY(QString, office, setOffice)

    Q_PROPERTY(PhonesModel *phoneNumbers READ phoneNumbers CONSTANT)
    PhonesModel *phoneNumbers() const;

    Q_PROPERTY(ImppModel *impps READ impps CONSTANT)
    ImppModel *impps() const;

    Q_PROPERTY(QImage photo READ photo WRITE setPhoto NOTIFY photoChanged)
    void setPhoto(const QImage &data);
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

    void addPhotoFromFile(const QUrl &path);
    Q_INVOKABLE void addPhoto();

    QByteArray raw() const;
    void setRaw(const QByteArray &raw);

Q_SIGNALS:
    void rawChanged();
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

    std::unique_ptr<QFileDialog> m_fileDialog;
};

#endif
