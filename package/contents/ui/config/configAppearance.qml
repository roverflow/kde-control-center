import QtQml 2.15
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Dialogs

import org.kde.kirigami as Kirigami
import org.kde.iconthemes as KIconThemes
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.extras 2.0 as PlasmaExtras
import org.kde.kcmutils as KCM

import org.kde.draganddrop 2.0 as DragDrop
import org.kde.ksvg 1.0 as KSvg

import "components" as ConfigComponents


KCM.SimpleKCM {
    id: configAppearance

    property alias cfg_scale: scale.value
    property alias cfg_transparency: transparency.checked
    property alias cfg_showKDEConnect: showKDEConnect.checked
    property alias cfg_showNightLight: showNightLight.checked
    property alias cfg_showColorSwitcher: showColorSwitcher.checked
    property alias cfg_showVolume: showVolume.checked
    property alias cfg_showBrightness: showBrightness.checked
    property alias cfg_showMediaPlayer: showMediaPlayer.checked
    property alias cfg_showAvatar: showAvatar.checked
    property alias cfg_showBattery: showBattery.checked
    property alias cfg_showSessionActions: showSessionActions.checked
    property alias cfg_showScreenshot: showScreenshot.checked
    property alias cfg_showCmd1: showCmd1.checked
    property alias cfg_showCmd2: showCmd2.checked
    property alias cfg_showPercentage: showPercentage.checked
    property string cfg_icon: Plasmoid.configuration.icon
    property bool cfg_useCustomButtonImage: Plasmoid.configuration.useCustomButtonImage
    property string cfg_customButtonImage: Plasmoid.configuration.customButtonImage
    property alias cfg_cmdIcon1: cmdIcon1.icon.name
    property alias cfg_cmdRun1: cmdRun1.text
    property alias cfg_cmdTitle1: cmdTitle1.text
    property alias cfg_cmdIcon2: cmdIcon2.icon.name
    property alias cfg_cmdRun2: cmdRun2.text
    property alias cfg_cmdTitle2: cmdTitle2.text

    property alias cfg_transparencyLevel: transparencyLevel.value
    property alias cfg_showBorders: showBorders.checked
    property alias cfg_animations: animations.checked
    property alias cfg_usePlasmaSliders: usePlasmaSliders.checked

    Kirigami.FormLayout {
        Button {
            id: iconButton

            Kirigami.FormData.label: i18n("Icon:")

            implicitWidth: previewFrame.width + Kirigami.Units.smallSpacing * 2
            implicitHeight: previewFrame.height + Kirigami.Units.smallSpacing * 2

            checkable: true
            checked: dropArea.containsAcceptableDrag

            onPressed: iconMenu.opened ? iconMenu.close() : iconMenu.open()

            DragDrop.DropArea {
                id: dropArea

                property bool containsAcceptableDrag: false

                anchors.fill: parent

                onDragEnter: {
                    var urlString = event.mimeData.url.toString();
                    var extensions = [".png", ".xpm", ".svg", ".svgz"];
                    containsAcceptableDrag = urlString.indexOf("file:///") === 0 && extensions.some(function (extension) {
                        return urlString.indexOf(extension) === urlString.length - extension.length;
                    });

                    if (!containsAcceptableDrag) {
                        event.ignore();
                    }
                }
                onDragLeave: containsAcceptableDrag = false

                onDrop: {
                    if (containsAcceptableDrag) {
                        iconDialog.setCustomButtonImage(event.mimeData.url.toString().substr("file://".length));
                    }
                    containsAcceptableDrag = false;
                }
            }

            KIconThemes.IconDialog {
                id: iconDialog

                property var target: null

                function setCustomButtonImage(image) {
                    if (target) {
                        target.icon.name = image;
                        target = null;
                    } else {
                        configAppearance.cfg_customButtonImage = image || configAppearance.cfg_icon || "start-here-kde-symbolic"
                        configAppearance.cfg_useCustomButtonImage = true;
                    }
                }

                onIconNameChanged: iconName => setCustomButtonImage(iconName);
            }

            KSvg.FrameSvgItem {
                id: previewFrame
                anchors.centerIn: parent
                imagePath: Plasmoid.location === PlasmaCore.Types.Vertical || Plasmoid.location === PlasmaCore.Types.Horizontal
                        ? "widgets/panel-background" : "widgets/background"
                width: Kirigami.Units.iconSizes.medium + fixedMargins.left + fixedMargins.right
                height: Kirigami.Units.iconSizes.medium + fixedMargins.top + fixedMargins.bottom

                Kirigami.Icon {
                    anchors.centerIn: parent
                    width: Kirigami.Units.iconSizes.medium
                    height: width
                    source: configAppearance.cfg_useCustomButtonImage ? configAppearance.cfg_customButtonImage : configAppearance.cfg_icon
                }
            }

            Menu {
                id: iconMenu
                y: +parent.height
                onClosed: iconButton.checked = false;

                MenuItem {
                    text: i18nc("@item:inmenu Open icon chooser dialog", "Choose…")
                    icon.name: "document-open-folder"
                    onClicked: iconDialog.open()
                }
                MenuItem {
                    text: i18nc("@item:inmenu Reset icon to default", "Clear Icon")
                    icon.name: "edit-clear"
                    onClicked: {
                        configAppearance.cfg_icon = "configure"
                        configAppearance.cfg_useCustomButtonImage = false
                    }
                }
            }
        }

        SpinBox {
            id: scale
            Kirigami.FormData.label: i18n("Scale:")
            from: 0; to: 1000
        }

        Item {
            Kirigami.FormData.isSection: true
        }

        CheckBox {
            id: showPercentage
            Kirigami.FormData.label: i18n("General:")
            text: i18n("Show volume/brightness percentage")
        }
        CheckBox {
            id: animations
            text: i18n("Enable animations")
        }
        CheckBox {
            id: transparency
            text: i18n("Enable transparency")
        }
        Slider {
            id: transparencyLevel
            visible: transparency.checked
            Kirigami.FormData.label: i18n("Transparency level (%1%):", 100-value)
            from: 100
            value: 40
            to: 0
            stepSize: 1
            Layout.fillWidth: true
        }
        CheckBox {
            id: showBorders
            text: i18n("Show borders")
        }
        CheckBox {
            id: usePlasmaSliders
            text: i18n("Use Plasma theme sliders")
        }

        Kirigami.Separator {
            Kirigami.FormData.isSection: true
            Kirigami.FormData.label: i18n("Components")
        }

        CheckBox {
            id: showKDEConnect
            Kirigami.FormData.label: i18n("Toggle buttons:")
            text: i18n("KDE Connect")
        }
        CheckBox {
            id: showNightLight
            text: i18n("Night Light")
        }
        CheckBox {
            id: showColorSwitcher
            text: i18n("Color Scheme Switcher")
        }
        CheckBox {
            id: showScreenshot
            text: i18n("Screenshot")
        }
        CheckBox {
            id: showCmd1
            text: i18n("Custom Command 1")
        }
        Kirigami.FormLayout {
            visible: showCmd1.checked
            TextField {
                id: cmdTitle1
                Kirigami.FormData.label: i18n("Name:")
            }
            TextField {
                id: cmdRun1
                Kirigami.FormData.label: i18n("Command:")
            }
            Button {
                id: cmdIcon1
                Kirigami.FormData.label: i18n("Icon:")
                icon.width: Kirigami.Units.iconSizes.medium
                icon.height: icon.width
                onClicked: {
                    iconDialog.open()
                    iconDialog.target = cmdIcon1
                }
            }
        }
        CheckBox {
            id: showCmd2
            text: i18n("Custom Command 2")
        }
        Kirigami.FormLayout {
            visible: showCmd2.checked
            TextField {
                id: cmdTitle2
                Kirigami.FormData.label: i18n("Name:")
            }
            TextField {
                id: cmdRun2
                Kirigami.FormData.label: i18n("Command:")
            }
            Button {
                id: cmdIcon2
                Kirigami.FormData.label: i18n("Icon:")
                icon.width: Kirigami.Units.iconSizes.medium
                icon.height: icon.width
                onClicked: {
                    iconDialog.open()
                    iconDialog.target = cmdIcon2
                }
            }
        }

        Item {
            Kirigami.FormData.isSection: true
        }

        CheckBox {
            id: showVolume
            Kirigami.FormData.label: i18n("Other components:")
            text: i18n("Volume Control")
        }
        CheckBox {
            id: showBrightness
            text: i18n("Brightness Control")
        }
        CheckBox {
            id: showMediaPlayer
            text: i18n("Media Player")
        }
        CheckBox {
            id: showAvatar
            text: i18n("User Avatar")
        }
        CheckBox {
            id: showBattery
            text: i18n("Battery")
        }
        CheckBox {
            id: showSessionActions
            text: i18n("Session Actions")
        }
    }

    Item {
        Layout.fillHeight: true
    }
}
