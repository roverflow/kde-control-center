import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.components as PlasmaComponents
import org.kde.kirigami as Kirigami

Item {
    id: sliderComp

    signal moved
    signal clicked
    signal actionButtonClicked

    property bool pressed: sliderItem.pressed
    property string title: ""
    property string secondaryTitle: ""
    property var value: 0
    property bool useIconButton: false
    property string source
    property bool canTogglePage: false

    property int from: 0
    property int to: 100
    property real stepSize: 2

    property color highlightColor: root.accentColor

    // Legacy compat (ignored)
    property bool flat: true
    property bool showTitle: false
    property bool thinSlider: true
    property bool mediumSizeSlider: false
    property bool glassEffect: false
    property int cornerRadius: 4
    property bool roundedWidget: false
    property bool noMargins: false

    property alias actionButton: actionToolButton

    Binding {
        target: sliderItem
        property: "value"
        value: sliderComp.value
        restoreMode: Binding.RestoreBindingOrValue
    }

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: root.smallSpacing
        anchors.rightMargin: root.mediumSpacing
        spacing: root.mediumSpacing

        // Icon or mute button — fixed 28px box
        Item {
            Layout.preferredWidth: 28 * root.scale
            Layout.minimumWidth: 28 * root.scale
            Layout.maximumWidth: 28 * root.scale
            Layout.preferredHeight: 28 * root.scale
            Layout.alignment: Qt.AlignVCenter

            Kirigami.Icon {
                anchors.centerIn: parent
                width: 20 * root.scale
                height: width
                source: sliderComp.source
                visible: !sliderComp.useIconButton
                color: root.textSecondary
            }

            PlasmaComponents.ToolButton {
                id: actionToolButton
                anchors.fill: parent
                visible: sliderComp.useIconButton
                icon.name: sliderComp.source
                icon.width: 20 * root.scale
                icon.height: 20 * root.scale
                onClicked: sliderComp.actionButtonClicked()
            }
        }

        // Slider track — fills all remaining width
        Slider {
            id: sliderItem
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignVCenter
            from: sliderComp.from
            to: sliderComp.to
            stepSize: sliderComp.stepSize
            snapMode: Slider.SnapAlways

            onMoved: {
                sliderComp.value = sliderItem.value
                sliderComp.moved()
            }

            background: Rectangle {
                x: sliderItem.leftPadding
                y: sliderItem.topPadding + sliderItem.availableHeight / 2 - height / 2
                implicitWidth: 200
                implicitHeight: 6
                width: sliderItem.availableWidth
                height: implicitHeight
                radius: 3
                color: root.surfaceActive

                Rectangle {
                    width: {
                        var range = sliderItem.to - sliderItem.from
                        if (range <= 0) return 0
                        return (sliderItem.value - sliderItem.from) / range * parent.width
                    }
                    height: parent.height
                    color: sliderComp.highlightColor
                    radius: 3
                }
            }

            handle: Rectangle {
                x: sliderItem.leftPadding + sliderItem.visualPosition * (sliderItem.availableWidth - width)
                y: sliderItem.topPadding + sliderItem.availableHeight / 2 - height / 2
                implicitWidth: 16
                implicitHeight: 16
                radius: 8
                color: sliderItem.pressed ? "#E0E0E0" : "#FFFFFF"
                border.color: root.textMuted
                border.width: 1
            }

            WheelHandler {
                orientation: Qt.Vertical | Qt.Horizontal
                property int wheelDelta: 0
                acceptedButtons: Qt.NoButton
                acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
                onWheel: wheel => {
                    const lastValue = sliderItem.value
                    const delta = (wheel.angleDelta.y || -wheel.angleDelta.x) * (wheel.inverted ? -1 : 1)
                    wheelDelta += delta
                    while (wheelDelta >= 120) { wheelDelta -= 120; sliderItem.increase() }
                    while (wheelDelta <= -120) { wheelDelta += 120; sliderItem.decrease() }
                    if (lastValue !== sliderItem.value) sliderItem.moved()
                }
            }
        }

        // Percentage label — fixed 48px right
        PlasmaComponents.Label {
            visible: root.showPercentage && sliderComp.secondaryTitle !== ""
            text: sliderComp.secondaryTitle
            Layout.preferredWidth: 48 * root.scale
            Layout.minimumWidth: 48 * root.scale
            Layout.maximumWidth: 48 * root.scale
            Layout.alignment: Qt.AlignVCenter
            horizontalAlignment: Text.AlignRight
            font.pixelSize: root.smallFontSize
            font.weight: Font.Medium
            color: root.textSecondary
        }

        // Arrow button — fixed 24px
        PlasmaComponents.ToolButton {
            visible: sliderComp.canTogglePage
            icon.name: "arrow-right"
            icon.width: 16 * root.scale
            icon.height: 16 * root.scale
            Layout.preferredWidth: 24 * root.scale
            Layout.minimumWidth: 24 * root.scale
            Layout.preferredHeight: 24 * root.scale
            Layout.alignment: Qt.AlignVCenter
            onClicked: sliderComp.clicked()
        }
    }
}
