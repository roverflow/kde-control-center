import QtQuick 2.15
import QtQuick.Layouts 1.15
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.components as PlasmaComponents
import org.kde.kirigami as Kirigami
import org.kde.plasma.private.batterymonitor

import "../lib" as Lib

Lib.CardButton {
    id: powerProfileBtn

    heading: i18n("Power Mode")
    title: {
        switch (profilesControl.activeProfile) {
            case "performance": return i18n("Performance")
            case "power-saver": return i18n("Power Saver")
            default: return i18n("Balanced")
        }
    }

    splitAction: true
    isLongButton: true
    active: profilesControl.activeProfile === "performance"
    visible: root.showPowerProfile && profilesControl.profileChoices.length > 0

    property var profiles: ["balanced", "performance", "power-saver"]

    PowerProfilesControl {
        id: profilesControl
    }

    Lib.Icon {
        anchors.fill: parent
        source: {
            switch (profilesControl.activeProfile) {
                case "performance": return "battery-profile-performance"
                case "power-saver": return "battery-profile-powersave"
                default: return "battery-profile-adaptive"
            }
        }
        selected: profilesControl.activeProfile === "performance"
    }

    onToggled: {
        var currentIdx = profiles.indexOf(profilesControl.activeProfile)
        var nextIdx = (currentIdx + 1) % profiles.length
        profilesControl.setProfile(profiles[nextIdx])
    }

    onArrowClicked: {
        var pageHeight = batteryPage.contentItemHeight + batteryPage.headerHeight;
        fullRep.togglePage(fullRep.defaultInitialWidth, pageHeight, batteryPage);
    }
}
