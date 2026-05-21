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

    property var audioSource: Vol.PreferredDevice.source
    readonly property bool sourceAvailable: audioSource && !(audioSource && audioSource.name == "auto_null")

    onAudioSourceChanged: sliderLoader.active = audioSource ? true : false

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
            canTogglePage: true
            thinSlider: true

            value: micControl.audioSource ? Math.round(micControl.audioSource.volume / Vol.PulseAudio.NormalVolume * 100) : 0
            secondaryTitle: value + "%"

            source: (micControl.audioSource && micControl.audioSource.muted) ? "audio-input-microphone-muted-symbolic" : "audio-input-microphone-symbolic"

            onMoved: {
                if (micControl.audioSource) {
                    micControl.audioSource.volume = value * Vol.PulseAudio.NormalVolume / 100
                }
            }

            onClicked: {
                var pageHeight = volumePage.contentItemHeight + volumePage.headerHeight;
                fullRep.togglePage(fullRep.defaultInitialWidth, pageHeight, volumePage);
            }

            property var oldVol: Vol.PulseAudio.NormalVolume
            onActionButtonClicked: {
                if (!micControl.audioSource) return
                if (value != 0) {
                    oldVol = micControl.audioSource.volume
                    micControl.audioSource.volume = 0
                } else {
                    micControl.audioSource.volume = oldVol
                }
            }
        }
    }
}
