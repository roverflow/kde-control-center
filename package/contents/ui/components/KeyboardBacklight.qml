import QtQuick 2.15
import QtQuick.Layouts 1.15
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.components as PlasmaComponents
import org.kde.kirigami as Kirigami
import org.kde.plasma.private.brightnesscontrolplugin

import "../lib" as Lib

Lib.CardButton {
    id: kbdBtn

    heading: i18n("Kbd Light")
    title: kbdControl.brightness > 0
        ? Math.round(kbdControl.brightness / kbdControl.brightnessMax * 100) + "%"
        : i18n("Off")

    splitAction: true
    isLongButton: true
    visible: root.showKeyboardBacklight && kbdControl.isBrightnessAvailable

    KeyboardBrightnessControl {
        id: kbdControl
        isSilent: true
    }

    Lib.Icon {
        anchors.fill: parent
        source: "input-keyboard-brightness"
        selected: kbdControl.brightness > 0
        sourceColor: "transparent"
    }

    onToggled: {
        if (kbdControl.brightness > 0) {
            kbdBtn._savedBrightness = kbdControl.brightness
            kbdControl.brightness = 0
        } else {
            kbdControl.brightness = kbdBtn._savedBrightness > 0 ? kbdBtn._savedBrightness : kbdControl.brightnessMax
        }
    }

    property int _savedBrightness: 0

    onArrowClicked: {
        var pageHeight = brightnessControlPage.contentItemHeight + brightnessControlPage.headerHeight;
        fullRep.togglePage(fullRep.defaultInitialWidth, pageHeight, brightnessControlPage);
    }
}
