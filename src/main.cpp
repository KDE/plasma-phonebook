/*
 * SPDX-FileCopyrightText: 2019 Linus Jahn <lnj@kaidan.im>
 *
 * SPDX-License-Identifier: GPL-2.0-only OR GPL-3.0-only OR LicenseRef-KDE-Accepted-GPL
 */

#include <KSharedConfig>
#include <KWindowConfig>
#include <QApplication>
#include <QCommandLineOption>
#include <QCommandLineParser>
#include <QQmlApplicationEngine>
#include <QQuickWindow>
#include <QUrl>
#include <QtQml>

#include <KAboutData>
#include <KContacts/Addressee>
#include <KLocalizedContext>
#include <KLocalizedString>

#include "version.h"

#ifdef Q_OS_ANDROID
#include <QtAndroid>
#endif

Q_DECL_EXPORT int main(int argc, char *argv[])
{
    QApplication app(argc, argv);

    KLocalizedString::setApplicationDomain("plasma-phonebook");
    KAboutData aboutData(QStringLiteral("plasma-phonebook"),
                         i18n("Phonebook"),
                         QStringLiteral(PLASMAPHONEBOOK_VERSION_STRING),
                         i18n("View and edit contacts"),
                         KAboutLicense::GPL);
    aboutData.setDesktopFileName(QStringLiteral("org.kde.phonebook"));
    KAboutData::setApplicationData(aboutData);

    QCommandLineParser parser;
    parser.addVersionOption();
    parser.process(app);

    // back-end
    QQmlApplicationEngine engine;
    engine.rootContext()->setContextObject(new KLocalizedContext(&engine));

#ifdef Q_OS_ANDROID
    QtAndroid::requestPermissionsSync({QStringLiteral("android.permission.WRITE_EXTERNAL_STORAGE")});
#endif

    qRegisterMetaType<KContacts::Addressee>();
    qRegisterMetaType<KContacts::Picture>();
    qRegisterMetaType<KContacts::Email>();
    qRegisterMetaType<KContacts::Impp>();
    qRegisterMetaType<KContacts::PhoneNumber>();

    engine.loadFromModule("org.kde.phonebook", "Main");

    if (engine.rootObjects().isEmpty()) {
        return -1;
    }

    const auto rootObjects = engine.rootObjects();
    for (auto obj : rootObjects) {
        auto view = qobject_cast<QQuickWindow *>(obj);
        if (view) {
            KConfig dataResource(QStringLiteral("data"), KConfig::SimpleConfig, QStandardPaths::AppDataLocation);
            KConfigGroup windowGroup(&dataResource, QStringLiteral("Window"));
            KWindowConfig::restoreWindowSize(view, windowGroup);
            KWindowConfig::restoreWindowPosition(view, windowGroup);
            break;
        }
    }
    
    // required for X11
    app.setWindowIcon(QIcon::fromTheme(QStringLiteral("org.kde.krecorder")));

    return app.exec();
}
