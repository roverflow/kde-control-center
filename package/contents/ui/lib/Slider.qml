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

    RowLayout {
        anchors.fill: parent
        anchors.margins: root.smallSpacing
        spacing: root.mediumSpacing

        Kirigami.Icon {
            id: icon
            source: sliderComp.source
            visible: !sliderComp.useIconButton
            Layout.preferredHeight: 16 * root.scale
            Layout.preferredWidth: Layout.preferredHeight
            color: root.textSecondary
        }

        PlasmaComponents.ToolButton {
            id: iconButton
            visible: sliderComp.useIconButton
            icon.name: sliderComp.source
            Layout.preferredHeight: 20 * root.scale
            Layout.preferredWidth: Layout.preferredHeight
            onClicked: sliderComp.actionButtonClicked()
        }

        Loader {
            id: sliderLoader
            sourceComponent: root.usePlasmaSliders ? plasmaSlider : customSlider
            Layout.fillWidth: true
            onLoaded: { sliderLoader.item.value = sliderComp.value; }
        }

        PlasmaComponents.Label {
            id: secondaryTitleLabel
            visible: root.showPercentage
            font.pixelSize: root.smallFontSize
            font.weight: Font.Normal
            color: root.textMuted
            Layout.alignment: Qt.AlignRight
        }

        PlasmaComponents.Label {
            id: titleLabel
            visible: false
        }

        Component {
            id: customSlider

            Slider {
                id: slider
                Layout.fillWidth: true
                from: sliderComp.from
                to: sliderComp.to
                stepSize: sliderComp.stepSize
                snapMode: Slider.SnapAlways

                background: Rectangle {
                    x: slider.leftPadding
                    y: slider.topPadding + slider.availableHeight / 2 - height / 2
                    implicitWidth: 200
                    implicitHeight: 4
                    width: slider.availableWidth
                    height: implicitHeight
                    radius: 2
                    color: root.surfaceActive

                    Rectangle {
                        width: (value - from) / (to - from) * (slider.width - handle.width) + handle.width
                        height: parent.height
                        color: highlightColor
                        radius: 2
                    }
                }

                handle: Rectangle {
                    id: handle
                    x: slider.leftPadding + slider.visualPosition * (slider.availableWidth - width)
                    y: slider.topPadding + slider.availableHeight / 2 - height / 2
                    implicitWidth: 14
                    implicitHeight: 14
                    radius: 7
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
                Layout.fillWidth: true
                from: sliderComp.from
                to: sliderComp.to
                stepSize: sliderComp.stepSize
                snapMode: Slider.SnapAlways
            }
        }

        PlasmaComponents.ToolButton {
            visible: sliderComp.canTogglePage
            icon.name: "arrow-right"
            Layout.preferredHeight: 16 * root.scale
            Layout.preferredWidth: Layout.preferredHeight
            onClicked: sliderComp.clicked()
        }
    }
}
