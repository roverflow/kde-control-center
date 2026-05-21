import QtQml 2.15
import QtQuick 2.15
import QtQuick.Layouts 1.15

import org.kde.plasma.plasmoid
import org.kde.plasma.plasma5support as Plasma5Support
import org.kde.kirigami as Kirigami

import "../lib" as Lib

Lib.CardButton {
    id: colorSchemeSwitcher

    visible: root.showColorSwitcher
    isLongButton: true
    active: root.isDarkTheme

    heading: i18n("Dark Style")
    title: root.isDarkTheme ? i18n("Active") : i18n("Inactive")

    property string command: root.preferChangeGlobalTheme
        ? "plasma-apply-lookandfeel -a "
        : "plasma-apply-colorscheme "

    Lib.Icon {
        anchors.fill: parent
        source: Qt.resolvedUrl("../icons/feather/dark-mode.svg")
        selected: root.isDarkTheme
        customIcon: true
    }

    onClicked: {
        var colorSchemeName = root.isDarkTheme ? root.generalLightTheme : root.generalDarkTheme
        executable.swapColorScheme(`${command}"${colorSchemeName}"`)
        root.isDarkTheme = !root.isDarkTheme
    }

    Plasma5Support.DataSource {
        id: executable
        engine: "executable"
        connectedSources: []
        onNewData: disconnectSource(sourceName)
        function exec(cmd) { connectSource(cmd) }
        function swapColorScheme(what) { exec(what) }
    }
}
