import QtQuick 2.1
import org.kde.kirigami 2.4 as Kirigami
import QtQuick.Controls 2.0 as Controls

Kirigami.ApplicationWindow {
    id: root

    title: "Hello"

    pageStack.initialPage: mainPageComponent

    Component {
        id: mainPageComponent

        Kirigami.Page {
            title: "Hello"

            Rectangle {
                color: "black"
                anchors.fill: parent
                
                Controls.Label {
                    text:  qsTr("Hello Kirigami")
                    color: "white"
                    anchors.centerIn: parent
                }
            }
        }
    }
}
