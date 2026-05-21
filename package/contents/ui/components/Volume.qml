import QtQml 2.15
import QtQuick 2.15
import QtQuick.Layouts 1.15

import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.private.volume as Vol

import "../lib" as Lib
import "../js/funcs.js" as Funcs

Item {
    id: volumeControl
    Layout.fillWidth: true
    Layout.fillHeight: true
    visible: sinkAvailable && root.showVolume

    property var sink: Vol.PreferredDevice.sink
    readonly property bool sinkAvailable: sink && !(sink && sink.name == "auto_null")

    onSinkChanged: sliderLoader.active = sink ? true : false

    Loader {
        id: sliderLoader
        active: false
        sourceComponent: sliderComponent
        anchors.fill: parent
    }

    Component {
        id: sliderComponent
        Lib.Slider {
            useIconButton: true
            canTogglePage: true

            value: Math.round(sink.volume / Vol.PulseAudio.NormalVolume * 100)
            secondaryTitle: Math.round(sink.volume / Vol.PulseAudio.NormalVolume * 100) + "%"
            source: Funcs.volIconName(sink.volume, sink.muted)

            onPressedChanged: {
                if (!pressed) volumePage.playFeedback(sink.Index)
            }

            onMoved: sink.volume = value * Vol.PulseAudio.NormalVolume / 100

            onClicked: {
                var pageHeight = volumePage.contentItemHeight + volumePage.headerHeight
                fullRep.togglePage(fullRep.defaultInitialWidth, pageHeight, volumePage)
            }

            property var oldVol: Vol.PulseAudio.NormalVolume
            onActionButtonClicked: {
                if (value != 0) {
                    oldVol = sink.volume
                    sink.volume = 0
                } else {
                    sink.volume = oldVol
                }
            }
        }
    }
}
