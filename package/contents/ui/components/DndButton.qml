import QtQml 2.15
import QtQuick 2.15
import QtQuick.Layouts 1.15
import "../lib" as Lib
import "../js/funcs.js" as Funcs
import org.kde.notificationmanager as NotificationManager
import org.kde.kirigami as Kirigami

Lib.CardButton {
    visible: root.showDnd
    isLongButton: true

    heading: i18n("Do Not Disturb")
    title: Funcs.checkInhibition() ? i18n("Active") : i18n("Off")

    NotificationManager.Settings {
        id: notificationSettings
    }

    onClicked: Funcs.toggleDnd()

    Lib.Icon {
        anchors.fill: parent
        customIcon: true
        source: Funcs.checkInhibition()
            ? Qt.resolvedUrl("../icons/feather/notifications-off.svg")
            : Qt.resolvedUrl("../icons/feather/notifications-on.svg")
        selected: Funcs.checkInhibition()
    }
}
