import QtQuick 2.15
import QtQuick.Layouts 1.15

import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.components as PlasmaComponents

Card {
    id: cardButton
    default property alias content: icon.data
    property alias title: titleLabel.text
    property alias heading: headingLabel.text
    property bool showTitle: true

    // Legacy compat
    property bool isLongButton: false
    property bool shouldStickIconSize: false
    property bool fullSizeIcon: false

    ColumnLayout {
        id: grid
        anchors.fill: parent
        anchors.margins: root.smallSpacing
        spacing: 2

        Item {
            id: icon
            Layout.preferredHeight: 20 * root.scale
            Layout.preferredWidth: Layout.preferredHeight
            Layout.alignment: Qt.AlignHCenter
            Layout.fillHeight: true
        }

        PlasmaComponents.Label {
            id: headingLabel
            Layout.fillWidth: true
            font.pixelSize: root.smallFontSize
            font.weight: Font.Medium
            elide: Text.ElideRight
            horizontalAlignment: Qt.AlignHCenter
            visible: text && isLongButton
            color: root.textPrimary
        }

        PlasmaComponents.Label {
            id: titleLabel
            Layout.fillWidth: true
            font.pixelSize: root.smallFontSize
            font.weight: Font.Normal
            horizontalAlignment: Qt.AlignHCenter
            elide: Text.ElideRight
            wrapMode: Text.NoWrap
            visible: text && showTitle
            color: root.textSecondary
        }
    }
}
