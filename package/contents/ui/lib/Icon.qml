import QtQuick 2.15
import QtQuick.Layouts 1.15
import org.kde.plasma.core as PlasmaCore
import org.kde.kirigami as Kirigami

Item {
    property color sourceColor
    property alias source: icon.source
    property alias selected: icon.selected
    property bool fullSizeIcon: false
    property bool customIcon: false
    property bool enableQuickAction: false

    signal quickActionTriggered

    property color highlightColor: root.useSystemColorsOnToggles ? root.themeHighlightColor : root.toggleButtonsColor
    property color iconColor: root.toggleButtonsIconColor

    Rectangle {
        id: rect
        radius: 6
        color: "transparent"
        anchors.fill: parent

        Kirigami.Icon {
            id: icon
            visible: true
            anchors.fill: parent
            anchors.margins: 2
            anchors.centerIn: parent
            selected: false
            isMask: customIcon
            color: selected ? iconColor : root.textPrimary
        }
    }

    MouseArea {
        enabled: enableQuickAction
        hoverEnabled: true
        anchors.fill: parent
        onClicked: quickActionTriggered()
    }
}
