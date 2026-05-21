import QtQuick 2.15
import QtQuick.Layouts 1.15
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.components as PlasmaComponents
import org.kde.plasma.workspace.components 2.0
import org.kde.kirigami as Kirigami
import org.kde.plasma.plasma5support as Plasma5Support

import "../lib" as Lib

Item {
    id: headerBar

    Layout.fillWidth: true
    Layout.preferredHeight: 32 * root.scale

    Plasma5Support.DataSource {
        id: headerExecutable
        engine: "executable"
        function exec(cmd) {
            connectSource(cmd)
        }
        onNewData: disconnectSource(sourceName)
    }

    RowLayout {
        anchors.fill: parent
        spacing: root.smallSpacing

        // Battery indicator
        MouseArea {
            Layout.preferredHeight: parent.height
            Layout.preferredWidth: batteryRow.implicitWidth + root.mediumSpacing * 2
            cursorShape: Qt.PointingHandCursor
            visible: batteryPage.batteryControl.hasBatteries

            onClicked: {
                var pageHeight = batteryPage.contentItemHeight + batteryPage.headerHeight;
                fullRep.togglePage(fullRep.defaultInitialWidth, pageHeight, batteryPage);
            }

            RowLayout {
                id: batteryRow
                anchors.centerIn: parent
                spacing: root.smallSpacing

                BatteryIcon {
                    Layout.preferredWidth: 16 * root.scale
                    Layout.preferredHeight: 16 * root.scale
                    percent: batteryPage.batteryControl.percent
                    hasBattery: batteryPage.batteryControl.hasBatteries
                    pluggedIn: batteryPage.batteryControl.pluggedIn
                }

                PlasmaComponents.Label {
                    text: batteryPage.batteryControl.percent + "%"
                    font.pixelSize: root.smallFontSize
                    font.weight: Font.Medium
                    color: root.textPrimary
                }
            }
        }

        Item { Layout.fillWidth: true }

        // Screenshot
        PlasmaComponents.ToolButton {
            visible: root.showScreenshot
            icon.name: "camera-photo-symbolic"
            icon.width: 16 * root.scale
            icon.height: 16 * root.scale
            Layout.preferredWidth: 28 * root.scale
            Layout.preferredHeight: 28 * root.scale
            onClicked: {
                if (root.hideWidgetBeforeScreenshot) root.expanded = false
                headerExecutable.exec(root.screenshotCommand)
            }
            PlasmaComponents.ToolTip { text: i18n("Screenshot") }
        }

        // Settings
        PlasmaComponents.ToolButton {
            icon.name: "configure"
            icon.width: 16 * root.scale
            icon.height: 16 * root.scale
            Layout.preferredWidth: 28 * root.scale
            Layout.preferredHeight: 28 * root.scale
            onClicked: headerExecutable.exec("systemsettings")
            PlasmaComponents.ToolTip { text: i18n("System Settings") }
        }

        // Lock
        PlasmaComponents.ToolButton {
            icon.name: "system-lock-screen"
            icon.width: 16 * root.scale
            icon.height: 16 * root.scale
            Layout.preferredWidth: 28 * root.scale
            Layout.preferredHeight: 28 * root.scale
            onClicked: headerExecutable.exec("loginctl lock-session")
            PlasmaComponents.ToolTip { text: i18n("Lock Screen") }
        }

        // Power
        PlasmaComponents.ToolButton {
            icon.name: "system-shutdown"
            icon.width: 16 * root.scale
            icon.height: 16 * root.scale
            Layout.preferredWidth: 28 * root.scale
            Layout.preferredHeight: 28 * root.scale
            onClicked: fullRep.togglePage(300, 400, systemSessionActionsPage)
            PlasmaComponents.ToolTip { text: i18n("Power / Session") }
        }
    }
}
