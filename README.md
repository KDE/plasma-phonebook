# Plasma Mobile phonebook

Contacts application which allows adding, modifying and removing contacts.

# Backend

The application uses kpeople models to find, add, remove and update contacts.
The actual vcard editing is done using KContacts, allowing to use the full range of fields vcards support.
Plasma Phonebook ships its own KPeople plugin for displaying actions.

# Building

plasma-phonebook depends on Qt 5 and a few KDE Frameworks:
  - KCoreAddons
  - Kirigami
  - KPeople
  - KContacts
  - KPeopleVCard

If your distribution does not provide a recent enough version you can use [kdesrc-build](https://community.kde.org/Get_Involved/development#Set_up_kdesrc-build) to build plasma-phonebook and with all dependencies.

To build plasma-phonebook do:
  - git clone git@invent.kde.org:kde/plasma-phonebook.git
  - cd plasma-phonebook
  - mkdir build
  - cd build
  - cmake -DCMAKE_INSTALL_PREFIX=~/kde
  - make
  - make install

To run the built version do:
  - source prefix.sh
  - plasma-phonebook

If you have questions please contact us in one of the [Plasma Mobile channels](https://www.plasma-mobile.org/join/).
