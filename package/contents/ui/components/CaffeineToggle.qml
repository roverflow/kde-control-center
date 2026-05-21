import QtQuick 2.15
import QtQuick.Layouts 1.15
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.components as PlasmaComponents
import org.kde.kirigami as Kirigami
import org.kde.plasma.private.batterymonitor

import "../lib" as Lib

Lib.CardButton {
    id: caffeineBtn

    heading: i18n("Caffeine")
    title: inhibitionControl.isManuallyInhibited ? i18n("Active") : i18n("Off")
    isLongButton: true
    active: inhibitionControl.isManuallyInhibited
    visible: root.showCaffeine

    property var possibleControls: [
        `
            import org.kde.plasma.private.batterymonitor
            PowerManagementControl {
                id: inhibitionCtrl
            }
        `,
        `
            import org.kde.plasma.private.batterymonitor
            InhibitionControl {
                id: inhibitionCtrl
            }
        `
    ]

    property var inhibitionControl: Qt.createQmlObject(
        root.plasmaVersion < 3 ? possibleControls[0] : possibleControls[1],
        caffeineBtn,
        "caffeineInhibitionControl"
    )

    Lib.Icon {
        anchors.fill: parent
        source: "preferences-desktop-screensaver"
        selected: inhibitionControl.isManuallyInhibited
        sourceColor: "transparent"
    }

    onClicked: {
        inhibitionControl.isSilent = root.expanded
        if (inhibitionControl.isManuallyInhibited) {
            inhibitionControl.uninhibit()
        } else {
            inhibitionControl.inhibit(i18n("Manually inhibited by Qt Control Center"))
        }
    }
}
