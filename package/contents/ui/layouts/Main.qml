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

    // -- Header Bar
    Components.HeaderBar {}

    // -- Separator
    Rectangle {
        Layout.fillWidth: true
        Layout.preferredHeight: 1
        color: root.borderColor
    }

    // -- Sliders
    ColumnLayout {
        spacing: root.mediumSpacing
        Layout.fillWidth: true

        Components.Volume {
            Layout.fillWidth: true
            Layout.preferredHeight: 44 * root.scale
        }
        Components.MicVolume {
            Layout.fillWidth: true
            Layout.preferredHeight: 44 * root.scale
        }
        Components.BrightnessSlider {
            Layout.fillWidth: true
            Layout.preferredHeight: 44 * root.scale
        }
    }

    // -- Separator
    Rectangle {
        Layout.fillWidth: true
        Layout.preferredHeight: 1
        color: root.borderColor
    }

    // -- Split-Action Toggle Grid (2 columns)
    GridLayout {
        id: toggleGrid
        columns: 2
        columnSpacing: root.mediumSpacing
        rowSpacing: root.mediumSpacing
        Layout.fillWidth: true

        Components.NetworkBtn {
            Layout.fillWidth: true
            Layout.preferredHeight: 62 * root.scale
        }
        Components.BluetoothBtn {
            Layout.fillWidth: true
            Layout.preferredHeight: 62 * root.scale
        }

        Components.DndButton {
            Layout.fillWidth: true
            Layout.preferredHeight: 62 * root.scale
        }
        Components.NightLight {
            Layout.fillWidth: true
            Layout.preferredHeight: 62 * root.scale
        }

        Components.ColorSchemeSwitcher {
            Layout.fillWidth: true
            Layout.preferredHeight: 62 * root.scale
        }
        Components.PowerProfile {
            Layout.fillWidth: true
            Layout.preferredHeight: 62 * root.scale
        }

        Components.CaffeineToggle {
            Layout.fillWidth: true
            Layout.preferredHeight: 62 * root.scale
        }
        Components.KeyboardBacklight {
            Layout.fillWidth: true
            Layout.preferredHeight: 62 * root.scale
        }
    }
}
