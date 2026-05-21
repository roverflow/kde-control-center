import QtQuick 2.15
import QtQuick.Layouts 1.15

import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.components as PlasmaComponents
import org.kde.kirigami as Kirigami

Card {
    id: cardButton
    cornerRadius: 8

    default property alias content: iconContainer.data
    property alias title: titleLabel.text
    property alias heading: headingLabel.text
    property bool showTitle: true

    property bool splitAction: false
    property bool isLongButton: false
    property bool shouldStickIconSize: false
    property bool fullSizeIcon: false

    signal toggled()
    signal arrowClicked()

    RowLayout {
        anchors.fill: parent
        spacing: 0

        // Left zone: icon + text (toggle area)
        MouseArea {
            id: leftZone
            Layout.fillWidth: true
            Layout.fillHeight: true
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor

            onEntered: cardButton.hovered = true
            onExited: if (!rightZone.containsMouse) cardButton.hovered = false
            onClicked: {
                if (splitAction) {
                    cardButton.toggled()
                } else {
                    cardButton.clicked()
                }
            }

            RowLayout {
                anchors.fill: parent
                anchors.margins: root.mediumSpacing
                spacing: root.mediumSpacing

                Item {
                    id: iconContainer
                    Layout.preferredWidth: 20 * root.scale
                    Layout.preferredHeight: 20 * root.scale
                    Layout.alignment: Qt.AlignVCenter
                }

                ColumnLayout {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Layout.alignment: Qt.AlignVCenter
                    spacing: 1

                    PlasmaComponents.Label {
                        id: headingLabel
                        Layout.fillWidth: true
                        font.pixelSize: root.mediumFontSize
                        font.weight: Font.DemiBold
                        elide: Text.ElideRight
                        visible: text !== ""
                        color: root.textPrimary
                    }

                    PlasmaComponents.Label {
                        id: titleLabel
                        Layout.fillWidth: true
                        font.pixelSize: root.smallFontSize
                        font.weight: Font.Normal
                        elide: Text.ElideRight
                        visible: text !== "" && showTitle
                        color: root.textSecondary
                    }
                }
            }
        }

        // Divider line
        Rectangle {
            visible: splitAction
            Layout.preferredWidth: 1
            Layout.fillHeight: true
            Layout.topMargin: root.mediumSpacing
            Layout.bottomMargin: root.mediumSpacing
            color: root.borderColor
        }

        // Right zone: arrow button (detail page)
        MouseArea {
            id: rightZone
            visible: splitAction
            Layout.preferredWidth: 32 * root.scale
            Layout.fillHeight: true
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor

            property bool containsMouse: false
            onEntered: { containsMouse = true; cardButton.hovered = true }
            onExited: { containsMouse = false; if (!leftZone.containsMouse) cardButton.hovered = false }
            onClicked: cardButton.arrowClicked()

            Rectangle {
                anchors.fill: parent
                radius: cardButton.cornerRadius
                color: rightZone.pressed ? root.surfaceActive : rightZone.containsMouse ? root.surfaceHover : "transparent"

                Kirigami.Icon {
                    anchors.centerIn: parent
                    width: 14 * root.scale
                    height: width
                    source: "arrow-right"
                    color: root.textSecondary
                }
            }
        }
    }
}
