import QtQuick 2.6
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.4 as Controls

import org.kde.kirigami 2.5 as Kirigami

Kirigami.BasicListItem {
    property string icon
    property string communication
    property string description

    id: delegate
    contentItem: RowLayout {
        spacing: Kirigami.Units.largeSpacing * 2
        anchors.verticalCenter: parent.verticalCenter

        Kirigami.Icon {
            id: icon
            width: Kirigami.Units.iconSizes.smallMedium
            height: width
            source: delegate.icon
            color: "#232627"
            Layout.alignment: Qt.AlignVCenter
        }
        Column {
            Layout.alignment: Qt.AlignVCenter
            Controls.Label {
                text: delegate.communication
                color: model.default ? "#2980b9" : "#232627"
            }
            Controls.Label {
                text: delegate.description
                font.pointSize: 8
                color: "#7f8c8d"
            }
        }
    }
}
