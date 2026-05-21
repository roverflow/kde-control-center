import QtQml 2.15
import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.0

import org.kde.plasma.plasmoid
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.extras as PlasmaExtras
import org.kde.plasma.components as PlasmaComponents

import "lib" as Lib
import "components" as Components
import "pages" as Pages
import "js/funcs.js" as Funcs


Rectangle {
    id: fullRep

    color: root.themeBgColor
    border.width: 1
    border.color: Qt.rgba(1, 1, 1, 0.12)
    radius: 8

    Layout.preferredWidth: root.fullRepWidth
    Layout.preferredHeight: wrapper.implicitHeight
    Layout.minimumWidth: Layout.preferredWidth
    Layout.maximumWidth: Layout.preferredWidth
    Layout.minimumHeight: Layout.preferredHeight
    Layout.maximumHeight: Layout.preferredHeight
    clip: true

    property int defaultInitialWidth: root.fullRepWidth
    property int defaultInitialHeight: wrapper.implicitHeight

    property int newWidth: 0
    property int newHeight: 0

    property var activePage: wrapper

    property bool expanded: root.expanded

    // Detail pages
    Pages.SystemSessionActionsPage { id: systemSessionActionsPage }
    Pages.NightLightPage { id: nightLightPage }
    Pages.VolumePage { id: volumePage }
    Pages.BatteryPage { id: batteryPage }
    Pages.MediaPlayerPage { id: mediaPlayerPage }
    Pages.BrightnessControlPage { id: brightnessControlPage }
    Pages.BluetoothPage { id: bluetoothPage }
    Pages.NetworkPage { id: networkPage }

    Loader {
        id: wrapper
        source: "layouts/Main.qml"
        active: true
        asynchronous: true
        anchors.fill: parent
        visible: true
        property bool shown: true
        states: [
            State {
                name: "show"; when: wrapper.shown
                PropertyChanges { target: wrapper; opacity: 1 }
                PropertyChanges { target: wrapper; visible: true }
            },
            State {
                name: "hide"; when: !wrapper.shown
                PropertyChanges { target: wrapper; opacity: 0 }
                PropertyChanges { target: wrapper; visible: false }
            }
        ]

        transitions: Transition {
            PropertyAnimation { target: wrapper; property: "opacity"; easing.type: Easing.InOutQuad; duration: 150 }
        }
    }

    SequentialAnimation {
        id: animation
        running: false

        property var hide: wrapper
        property var show: activePage

        PropertyAnimation { target: animation.hide; property: "shown"; from: animation.hide.shown; to: !animation.hide.shown; duration: 20 }
        ParallelAnimation {
            PropertyAnimation { target: fullRep; property: "Layout.preferredWidth"; to: newWidth; duration: 50 }
            PropertyAnimation { target: fullRep; property: "Layout.preferredHeight"; to: newHeight; duration: 50 }
        }
        PropertyAnimation { target: animation.show; property: "shown"; from: animation.show.shown; to: !animation.show.shown; duration: 20 }
    }

    function togglePage(width = defaultInitialWidth, height = defaultInitialHeight, page = activePage) {
        if (root.animations) {
            newHeight = height;
            newWidth = width;
        } else {
            newHeight = defaultInitialHeight;
            newWidth = defaultInitialWidth;
        }

        activePage = page;

        animation.hide = wrapper.shown ? wrapper : activePage;
        animation.show = wrapper.shown ? activePage : wrapper;
        animation.running = true;
    }

    onExpandedChanged: {
        if (!wrapper.shown) {
            togglePage();
        }
    }
}
