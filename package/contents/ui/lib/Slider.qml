import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.components as PlasmaComponents
import org.kde.kirigami as Kirigami

Card {
    id: sliderComp
    flat: true
    signal moved
    signal actionButtonClicked

    property bool pressed: false
    property alias title: titleLabel.text
    property alias secondaryTitle: secondaryTitleLabel.text
    property var value: 0
    property bool useIconButton: false
    property string source

    property bool canTogglePage: false
    property bool showTitle: false
    property bool thinSlider: true
    property bool mediumSizeSlider: false

    property int from: 0
    property int to: 100
    property real stepSize: 2

    property color highlightColor: root.accentColor

    Binding { sliderComp.pressed: sliderLoader.item.pressed }

    Binding {
        target: sliderLoader.item
        property: "value"
        value: sliderComp.value
        restoreMode: Binding.RestoreBindingOrValue
    }

    Connections {
        target: sliderLoader.item
        function onMoved() {
            sliderComp.value = sliderLoader.item.value;
            sliderComp.moved();
        }
    }

    PlasmaComponents.Label {
        id: titleLabel
        visible: false
    }

    RowLayout {
        anchors.fill: parent
        anchors.margins: root.mediumSpacing
        spacing: root.mediumSpacing

        // -- Icon (fixed 28px bounding box)
        Item {
            Layout.preferredWidth: 28 * root.scale
            Layout.minimumWidth: 28 * root.scale
            Layout.preferredHeight: 28 * root.scale
            Layout.alignment: Qt.AlignVCenter

            Kirigami.Icon {
                id: icon
                anchors.centerIn: parent
                width: 22 * root.scale
                height: width
                source: sliderComp.source
                visible: !sliderComp.useIconButton
                color: root.textSecondary
            }

            PlasmaComponents.ToolButton {
                id: iconButton
                anchors.centerIn: parent
                width: 28 * root.scale
                height: width
                visible: sliderComp.useIconButton
                icon.name: sliderComp.source
                icon.width: 22 * root.scale
                icon.height: 22 * root.scale
                onClicked: sliderComp.actionButtonClicked()
            }
        }

        // -- Slider track (fills remaining space)
        Loader {
            id: sliderLoader
            sourceComponent: root.usePlasmaSliders ? plasmaSlider : customSlider
            Layout.fillWidth: true
            Layout.minimumWidth: 100 * root.scale
            Layout.alignment: Qt.AlignVCenter
            onLoaded: { sliderLoader.item.value = sliderComp.value; }
        }

        // -- Percentage label (fixed 44px right-anchored)
        PlasmaComponents.Label {
            id: secondaryTitleLabel
            visible: root.showPercentage
            Layout.preferredWidth: 44 * root.scale
            Layout.minimumWidth: 44 * root.scale
            Layout.alignment: Qt.AlignVCenter | Qt.AlignRight
            horizontalAlignment: Text.AlignRight
            font.pixelSize: root.smallFontSize
            font.weight: Font.Medium
            color: root.textSecondary
        }

        // -- Arrow button (optional, fixed width)
        PlasmaComponents.ToolButton {
            visible: sliderComp.canTogglePage
            icon.name: "arrow-right"
            icon.width: 16 * root.scale
            icon.height: 16 * root.scale
            Layout.preferredWidth: 22 * root.scale
            Layout.preferredHeight: 22 * root.scale
            Layout.minimumWidth: 22 * root.scale
            Layout.alignment: Qt.AlignVCenter
            onClicked: sliderComp.clicked()
        }
    }

    Component {
        id: customSlider

        Slider {
            id: slider
            from: sliderComp.from
            to: sliderComp.to
            stepSize: sliderComp.stepSize
            snapMode: Slider.SnapAlways

            background: Rectangle {
                x: slider.leftPadding
                y: slider.topPadding + slider.availableHeight / 2 - height / 2
                implicitWidth: 200
                implicitHeight: 6
                width: slider.availableWidth
                height: implicitHeight
                radius: 3
                color: root.surfaceActive

                Rectangle {
                    width: (value - from) / (to - from) * (slider.width - handle.width) + handle.width
                    height: parent.height
                    color: highlightColor
                    radius: 3
                }
            }

            handle: Rectangle {
                id: handle
                x: slider.leftPadding + slider.visualPosition * (slider.availableWidth - width)
                y: slider.topPadding + slider.availableHeight / 2 - height / 2
                implicitWidth: 16
                implicitHeight: 16
                radius: 8
                color: slider.pressed ? "#E0E0E0" : "#FFFFFF"
                border.color: root.textMuted
                border.width: 1

                Behavior on color { ColorAnimation { duration: 100 } }
            }

            WheelHandler {
                orientation: Qt.Vertical | Qt.Horizontal
                property int wheelDelta: 0
                acceptedButtons: Qt.NoButton
                acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
                onWheel: wheel => {
                    const lastValue = slider.value
                    const delta = (wheel.angleDelta.y || -wheel.angleDelta.x) * (wheel.inverted ? -1 : 1)
                    wheelDelta += delta;
                    while (wheelDelta >= 120) {
                        wheelDelta -= 120;
                        slider.increase();
                    }
                    while (wheelDelta <= -120) {
                        wheelDelta += 120;
                        slider.decrease();
                    }
                    if (lastValue !== slider.value) {
                        slider.moved();
                    }
                }
            }
        }
    }

    Component {
        id: plasmaSlider
        PlasmaComponents.Slider {
            from: sliderComp.from
            to: sliderComp.to
            stepSize: sliderComp.stepSize
            snapMode: Slider.SnapAlways
        }
    }
}
