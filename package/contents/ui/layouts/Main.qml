import QtQml 2.15
import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.0
import "../components" as Components

ColumnLayout {
    id: wrapper

    anchors.fill: parent
    anchors.margins: root.largeSpacing
    spacing: root.largeSpacing

    // -- Toggle Grid
    GridLayout {
        id: toggleGrid
        columns: 4
        columnSpacing: root.mediumSpacing
        rowSpacing: root.mediumSpacing
        Layout.fillWidth: true

        Components.NetworkBtn {
            Layout.fillWidth: true
            Layout.preferredHeight: 64 * root.scale
        }
        Components.BluetoothBtn {
            Layout.fillWidth: true
            Layout.preferredHeight: 64 * root.scale
        }
        Components.DndButton {
            Layout.fillWidth: true
            Layout.preferredHeight: 64 * root.scale
        }
        Components.KDEConnect {
            Layout.fillWidth: true
            Layout.preferredHeight: 64 * root.scale
        }

        Components.NightLight {
            Layout.fillWidth: true
            Layout.preferredHeight: 64 * root.scale
        }
        Components.ColorSchemeSwitcher {
            Layout.fillWidth: true
            Layout.preferredHeight: 64 * root.scale
        }
        Components.ScreenshotBtn {
            Layout.fillWidth: true
            Layout.preferredHeight: 64 * root.scale
            visible: root.showScreenshot
        }
        Components.CommandRun {
            Layout.fillWidth: true
            Layout.preferredHeight: 64 * root.scale
            visible: root.showCmd1
            icon: root.cmdIcon1
            command: root.cmdRun1
            title: root.cmdTitle1
        }
    }

    // -- Sliders
    ColumnLayout {
        spacing: root.mediumSpacing
        Layout.fillWidth: true

        Components.BrightnessSlider {
            Layout.fillWidth: true
            Layout.preferredHeight: 32 * root.scale
        }
        Components.Volume {
            Layout.fillWidth: true
            Layout.preferredHeight: 32 * root.scale
        }
    }

    // -- Media Player
    Components.MediaPlayer {
        Layout.fillWidth: true
        Layout.preferredHeight: 64 * root.scale
        visible: root.showMediaPlayer
    }

    // -- Footer
    RowLayout {
        id: footer
        spacing: root.mediumSpacing
        Layout.fillWidth: true

        Components.Battery {
            Layout.fillWidth: true
            Layout.preferredHeight: 44 * root.scale
        }
        Components.UserAvatar {
            Layout.fillWidth: true
            Layout.preferredHeight: 44 * root.scale
        }
        Components.SystemActions {
            Layout.preferredWidth: 44 * root.scale
            Layout.preferredHeight: 44 * root.scale
        }
    }
}
