import QtQml 2.15
import QtQuick 2.15
import QtQuick.Layouts 1.15

import org.kde.plasma.plasmoid
import org.kde.kirigami as Kirigami

import "../lib" as Lib
import org.kde.plasma.private.brightnesscontrolplugin

Lib.CardButton {
    id: nightLight

    visible: root.showNightLight

    splitAction: true
    isLongButton: true
    active: control.enabled && control.running

    heading: i18n("Night Light")
    title: control.enabled && control.running ? i18n("On") : i18n("Off")

    property var control: nightLightPage.control

    Lib.Icon {
        anchors.fill: parent
        source: {
            if (!control.enabled) return "redshift-status-on"
            if (!control.running) return "redshift-status-off"
            if (control.daylight && control.targetTemperature != 6500) return "redshift-status-day"
            return "redshift-status-on"
        }
        selected: control.enabled && control.running
    }

    onToggled: {
        control.enabled = !control.enabled
    }

    onArrowClicked: {
        var pageHeight = nightLightPage.contentItemHeight + nightLightPage.headerHeight;
        fullRep.togglePage(fullRep.defaultInitialWidth, pageHeight, nightLightPage);
    }
}
