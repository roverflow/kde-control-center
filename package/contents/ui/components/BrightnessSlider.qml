import QtQml 2.15
import QtQuick 2.15
import QtQuick.Layouts 1.15
import org.kde.plasma.components as PlasmaComponents
import org.kde.plasma.plasma5support as Plasma5Support
import "../lib" as Lib
import org.kde.kitemmodels as KItemModels

import org.kde.plasma.private.brightnesscontrolplugin

Item {
    id: brightnessControl

    Layout.fillHeight: true
    Layout.fillWidth: true

    property var mainScreen
    property bool disableBrightnessUpdate: true
    property int selectedDisplay: 0

    property bool canTogglePage: false
    property bool flat: false
    property bool showTitle: false

    ScreenBrightnessControl {
        id: sbControl
        isSilent: false
    }

    Connections {
        id: displayModelConnections
        target: sbControl.displays
        property var screenBrightnessInfo: []

        function update() {
            const [labelRole, brightnessRole, maxBrightnessRole, displayNameRole] = ["label", "brightness", "maxBrightness", "displayName"].map(
                (roleName) => target.KItemModels.KRoleNames.role(roleName));

            screenBrightnessInfo = [...Array(target.rowCount()).keys()].map((i) => {
                const modelIndex = target.index(i, 0);
                return {
                    displayName: target.data(modelIndex, displayNameRole),
                    label: target.data(modelIndex, labelRole),
                    brightness: target.data(modelIndex, brightnessRole),
                    maxBrightness: target.data(modelIndex, maxBrightnessRole),
                };
            });
            if (selectedDisplay < screenBrightnessInfo.length) {
                brightnessControl.mainScreen = screenBrightnessInfo[selectedDisplay];
            } else {
                brightnessControl.mainScreen = screenBrightnessInfo[0];
            }
            sliderLoader.active = true;
        }
        function onDataChanged() { update(); }
        function onModelReset() { update(); }
        function onRowsInserted() { update(); }
        function onRowsMoved() { update(); }
        function onRowsRemoved() { update(); }
    }

    visible: sbControl.isBrightnessAvailable && root.showBrightness && mainScreen !== null && mainScreen !== undefined

    ColumnLayout {
        anchors.fill: parent
        spacing: 2

        PlasmaComponents.ComboBox {
            id: displayPicker
            Layout.fillWidth: true
            Layout.preferredHeight: 24 * root.scale
            visible: displayModelConnections.screenBrightnessInfo.length > 1
            model: displayModelConnections.screenBrightnessInfo.map(d => d.label)
            currentIndex: brightnessControl.selectedDisplay
            font.pixelSize: root.smallFontSize
            onActivated: index => {
                brightnessControl.selectedDisplay = index;
                brightnessControl.mainScreen = displayModelConnections.screenBrightnessInfo[index];
            }
        }

        Loader {
            id: sliderLoader
            active: false
            sourceComponent: sliderComponent
            Layout.fillWidth: true
            Layout.fillHeight: true
        }
    }

    Component {
        id: sliderComponent
        Lib.Slider {
            readonly property int brightnessMin: (mainScreen.maxBrightness > 100 ? 1 : 0)

            title: mainScreen.label
            source: "brightness-high-symbolic"
            secondaryTitle: Math.round((mainScreen.brightness / mainScreen.maxBrightness)*100) + "%"

            canTogglePage: brightnessControl.canTogglePage
            showTitle: root.brightness_widget_title
            thinSlider: root.brightness_widget_thin
            flat: root.brightness_widget_flat || brightnessControl.flat

            from: brightnessMin
            to: mainScreen.maxBrightness
            value: mainScreen.brightness
            stepSize: mainScreen.maxBrightness / 100

            onMoved: {
                sbControl.setBrightness(mainScreen.displayName, value);
            }

            onClicked: {
                var pageHeight = brightnessControlPage.contentItemHeight + brightnessControlPage.headerHeight;
                fullRep.togglePage(fullRep.defaultInitialWidth, pageHeight, brightnessControlPage);
            }
        }
    }
}
