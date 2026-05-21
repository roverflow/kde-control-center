import QtQuick 2.15
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.15

import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.components as PlasmaComponents

Card {
    id: button

    Layout.fillWidth: true
    Layout.fillHeight: true

    property alias title: titleLabel.text
    property alias subtitle: subtitleLabel.text
    property alias source: icon.source
    property alias sourceColor: icon.sourceColor

    GridLayout {
        rows: 2; columns: 2
        anchors.fill: parent
        anchors.margins: root.mediumSpacing
        rowSpacing: 2
        columnSpacing: root.mediumSpacing
        clip: true

        Icon {
            id: icon
            Layout.rowSpan: 2
            Layout.preferredHeight: parent.height - root.mediumSpacing
            Layout.preferredWidth: Layout.preferredHeight
        }

        PlasmaComponents.Label {
            id: titleLabel
            Layout.fillWidth: true
            font.pixelSize: root.largeFontSize
            font.weight: Font.DemiBold
            elide: Text.ElideRight
            color: root.textPrimary
        }
        PlasmaComponents.Label {
            id: subtitleLabel
            Layout.fillWidth: true
            font.pixelSize: root.mediumFontSize
            elide: Text.ElideRight
            color: root.textSecondary
        }
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onClicked: button.clicked()
    }
}
