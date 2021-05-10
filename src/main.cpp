/*
 * SPDX-FileCopyrightText: 2019 Linus Jahn <lnj@kaidan.im>
 *
 * SPDX-License-Identifier: GPL-2.0-only OR GPL-3.0-only OR LicenseRef-KDE-Accepted-GPL
 */

#include <QApplication>
#include <QQmlApplicationEngine>
#include <QUrl>
#include <QtQml>
#include <QCommandLineParser>
#include <QCommandLineOption>

#include <KAboutData>
#include <KLocalizedContext>
#include <KLocalizedString>

#include "contactimporter.h"
#include "declarativeaddressee.h"
#include "imppmodel.h"
#include "phonesmodel.h"
#include "version.h"

#ifdef Q_OS_ANDROID
#include <QtAndroid>
#endif

Q_DECL_EXPORT int main(int argc, char *argv[])
{
    QCommandLineParser parser;
    QGuiApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QApplication app(argc, argv);
    QCoreApplication::setOrganizationName(QStringLiteral("KDE"));
    QCoreApplication::setOrganizationDomain(QStringLiteral("kde.org"));
    QCoreApplication::setApplicationName(QStringLiteral("plasma-phonebook"));
    QCoreApplication::setApplicationVersion(QStringLiteral(PLASMAPHONEBOOK_VERSION_STRING));

    KLocalizedString::setApplicationDomain("plasma-phonebook");
    parser.addVersionOption();
    parser.process(app);

    // back-end
    QQmlApplicationEngine engine;
    engine.rootContext()->setContextObject(new KLocalizedContext(&engine));

    KAboutData aboutData(QStringLiteral("plasma-phonebook"), i18n("Phone Book"), {}, i18n("View and edit contacts"), KAboutLicense::GPL);
    aboutData.setDesktopFileName(QStringLiteral("org.kde.phone.dialer"));

    qmlRegisterType<Addressee>("org.kde.kcontacts", 1, 0, "Addressee");
    qmlRegisterUncreatableType<PhonesModel>("org.kde.kcontacts", 1, 0, "PhonesModel", QStringLiteral("Get it from the Addressee"));
    qmlRegisterUncreatableType<ImppModel>("org.kde.kcontacts", 1, 0, "ImppModel", QStringLiteral("Get it from the Addressee"));
    qmlRegisterType<ContactImporter>("org.kde.phonebook", 1, 0, "ContactImporter");
#if (QT_VERSION >= QT_VERSION_CHECK(5, 14, 0))
    qmlRegisterAnonymousType<QAbstractItemModel>("org.kde.phonebook", 1);
#else
    qmlRegisterType<QAbstractItemModel>();
#endif

#ifdef Q_OS_ANDROID
    QtAndroid::requestPermissionsSync({"android.permission.WRITE_EXTERNAL_STORAGE"});
#endif

    engine.load(QUrl(QStringLiteral("qrc:///main.qml")));

    if (engine.rootObjects().isEmpty()) {
        return -1;
    }

    return app.exec();
}
