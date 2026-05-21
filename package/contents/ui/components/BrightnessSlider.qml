import QtQml 2.15
import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
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
    property int selectedDisplay: 0

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
        }
        function onDataChanged() { update(); }
        function onModelReset() { update(); }
        function onRowsInserted() { update(); }
        function onRowsMoved() { update(); }
        function onRowsRemoved() { update(); }
    }

    visible: sbControl.isBrightnessAvailable && root.showBrightness && mainScreen !== null && mainScreen !== undefined

    Lib.Slider {
        id: brightnessSlider
        anchors.fill: parent

        useIconButton: true
        canTogglePage: true
        source: "brightness-high-symbolic"
        secondaryTitle: mainScreen ? Math.round((mainScreen.brightness / mainScreen.maxBrightness) * 100) + "%" : "0%"

        from: mainScreen ? (mainScreen.maxBrightness > 100 ? 1 : 0) : 0
        to: mainScreen ? mainScreen.maxBrightness : 100
        value: mainScreen ? mainScreen.brightness : 0
        stepSize: mainScreen ? mainScreen.maxBrightness / 100 : 1

        onMoved: {
            if (mainScreen) sbControl.setBrightness(mainScreen.displayName, value)
        }

        onClicked: {
            var pageHeight = brightnessControlPage.contentItemHeight + brightnessControlPage.headerHeight
            fullRep.togglePage(fullRep.defaultInitialWidth, pageHeight, brightnessControlPage)
        }

        onActionButtonClicked: {
            if (displayModelConnections.screenBrightnessInfo.length > 1)
                displayMenu.open()
        }
    }

    Menu {
        id: displayMenu
        y: brightnessSlider.actionButton
           ? brightnessSlider.actionButton.mapToItem(brightnessControl, 0, brightnessSlider.actionButton.height).y
           : 0
        x: brightnessSlider.actionButton
           ? brightnessSlider.actionButton.mapToItem(brightnessControl, 0, 0).x
           : 0

        Repeater {
            model: displayModelConnections.screenBrightnessInfo

            MenuItem {
                text: modelData.label
                checkable: true
                checked: index === brightnessControl.selectedDisplay
                onTriggered: {
                    brightnessControl.selectedDisplay = index
                    displayModelConnections.update()
                }
            }
        }
    }
}
