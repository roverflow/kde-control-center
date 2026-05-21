import QtQml 2.15
import QtQuick 2.15
import QtQuick.Layouts 1.15

import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.private.volume as Vol

import "../lib" as Lib

Item {
    id: micControl
    Layout.fillWidth: true
    Layout.fillHeight: true
    visible: sourceAvailable && root.showMicVolume

    property var source: Vol.PreferredDevice.source
    readonly property bool sourceAvailable: source && !(source && source.name == "auto_null")

    onSourceChanged: sliderLoader.active = source ? true : false

    Loader {
        id: sliderLoader
        active: false
        sourceComponent: sliderComponent
        anchors.fill: parent
    }

    Component {
        id: sliderComponent
        Lib.Slider {
            id: slider
            flat: true
            useIconButton: true
            thinSlider: true

            value: Math.round(source.volume / Vol.PulseAudio.NormalVolume * 100)
            secondaryTitle: Math.round(source.volume / Vol.PulseAudio.NormalVolume * 100) + "%"

            source: source.muted ? "audio-input-microphone-muted-symbolic" : "audio-input-microphone-symbolic"

            onMoved: micControl.source.volume = value * Vol.PulseAudio.NormalVolume / 100

            onClicked: {
                var pageHeight = volumePage.contentItemHeight + volumePage.headerHeight;
                fullRep.togglePage(fullRep.defaultInitialWidth, pageHeight, volumePage);
            }

            property var oldVol: 100 * Vol.PulseAudio.NormalVolume / 100
            onActionButtonClicked: {
                if (value != 0) {
                    oldVol = micControl.source.volume
                    micControl.source.volume = 0
                } else {
                    micControl.source.volume = oldVol
                }
            }
        }
    }
}
