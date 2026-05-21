import QtQuick 2.15
import QtQml 2.15
import QtQuick.Layouts 1.15
import org.kde.plasma.plasmoid
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.components as PlasmaComponents
import org.kde.kirigami as Kirigami

Rectangle {
    id: rectangle
    color: "transparent"

    property alias customBgColor: cardBg.color
    property bool flat: false
    property bool noMargins: false
    property int cornerRadius: 4

    property var margins: cardBg.anchors
    default property alias content: dataContainer.data

    property bool hovered: false
    property bool showContentOverflowIndicator: false

    // Legacy compat — ignored in new design
    property bool smallTopMargins: false
    property bool smallBottomMargins: false
    property bool smallLeftMargins: false
    property bool smallRightMargins: false
    property bool glassEffect: false
    property bool roundedWidget: false
    property bool shadow: false
    property bool filled: !flat
    property bool bordr: !flat

    signal clicked

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onEntered: rectangle.hovered = true
        onExited: rectangle.hovered = false
        onClicked: rectangle.clicked()
    }

    Rectangle {
        id: cardBg
        anchors.fill: parent
        radius: cornerRadius
        color: flat ? "transparent" : root.surfaceColor
        border.width: flat ? 0 : (root.showBorders ? 1 : 0)
        border.color: rectangle.hovered ? root.borderStrong : root.borderColor
        z: -1

        Behavior on border.color {
            ColorAnimation { duration: 150 }
        }
    }

    Item {
        id: dataContainer
        anchors.fill: parent
        anchors.margins: noMargins ? 0 : root.mediumSpacing
    }

    Rectangle {
        id: contentOverflowIndicator
        anchors.fill: parent
        color: "transparent"
        radius: cornerRadius
        visible: showContentOverflowIndicator
        opacity: rectangle.hovered ? 1 : 0

        Kirigami.Icon {
            source: "arrow-right"
            width: 14
            height: width
            anchors.right: parent.right
            anchors.rightMargin: root.mediumSpacing
            anchors.verticalCenter: parent.verticalCenter
            color: root.textSecondary
        }

        Behavior on opacity { PropertyAnimation { duration: 150 } }
    }
}
