import QtQuick 2.15
import QtQuick.Controls 2.15
import org.kde.plasma.plasmoid
import org.kde.plasma.core as PlasmaCore
import org.kde.kirigami as Kirigami
import org.kde.kitemmodels as KItemModels
import org.kde.plasma.plasma5support as Plasma5Support

PlasmoidItem {
    id: root

    clip: true

    // -- Scale
    property var scale: Plasmoid.configuration.scale * 1 / 100
    property int fullRepWidth: 480 * scale
    property int fullRepHeight: 700 * scale

    // -- Spacing (8px base grid)
    property int largeSpacing: 16 * scale
    property int mediumSpacing: 12 * scale
    property int smallSpacing: 6 * scale
    property int buttonMargin: 4 * scale
    property int buttonHeight: 48 * scale
    property int itemSpacing: 8

    // -- Typography (Geist scale)
    property int largeFontSize: 16 * scale
    property int mediumFontSize: 14 * scale
    property int smallFontSize: 12 * scale

    // -- Surfaces (Vercel Geist dark)
    property color surfaceColor: "#111111"
    property color surfaceHover: "#222222"
    property color surfaceActive: "#333333"
    property color borderColor: Qt.rgba(1, 1, 1, 0.08)
    property color borderStrong: Qt.rgba(1, 1, 1, 0.15)

    // -- Text
    property color textPrimary: "#FFFFFF"
    property color textSecondary: "#A3A3A3"
    property color textMuted: "#737373"

    // -- Accent
    property color accentColor: "#0070F3"
    property color accentHover: "#3291FF"

    // -- Semantic
    property color redColor: "#EE0000"
    property color warningColor: "#F5A623"
    property color successColor: "#0070F3"

    // -- Legacy compat (used by existing components)
    property color themeBgColor: "#000000"
    property color themeHighlightColor: accentColor
    property bool isDarkTheme: true
    property color disabledBgColor: surfaceActive

    // -- Feature flags
    property bool animations: plasmoid.configuration.animations
    property bool enableTransparency: Plasmoid.configuration.transparency
    property int transparencyLevel: Plasmoid.configuration.transparencyLevel
    property bool showBorders: Plasmoid.configuration.showBorders

    // -- Theme switching
    property bool preferChangeGlobalTheme: Plasmoid.configuration.preferChangeGlobalTheme
    property string generalLightTheme: preferChangeGlobalTheme ? Plasmoid.configuration.lightGlobalTheme : Plasmoid.configuration.lightTheme
    property string generalDarkTheme: preferChangeGlobalTheme ? Plasmoid.configuration.darkGlobalTheme : Plasmoid.configuration.darkTheme

    // -- Component visibility
    property bool showKDEConnect: Plasmoid.configuration.showKDEConnect
    property bool showNightLight: Plasmoid.configuration.showNightLight
    property bool showColorSwitcher: Plasmoid.configuration.showColorSwitcher
    property bool showDnd: Plasmoid.configuration.showDnd
    property bool showVolume: Plasmoid.configuration.showVolume
    property bool showBrightness: Plasmoid.configuration.showBrightness
    property bool showMediaPlayer: Plasmoid.configuration.showMediaPlayer
    property bool showAvatar: Plasmoid.configuration.showAvatar
    property bool showBattery: Plasmoid.configuration.showBattery
    property bool showSessionActions: Plasmoid.configuration.showSessionActions
    property bool showScreenshot: Plasmoid.configuration.showScreenshot
    property bool showCmd1: Plasmoid.configuration.showCmd1
    property bool showCmd2: Plasmoid.configuration.showCmd2
    property bool showPercentage: true
    property bool showMicVolume: true
    property bool showPowerProfile: true
    property bool showCaffeine: true
    property bool showKeyboardBacklight: true

    // -- Custom commands
    property string cmdRun1: Plasmoid.configuration.cmdRun1
    property string cmdTitle1: Plasmoid.configuration.cmdTitle1
    property string cmdIcon1: Plasmoid.configuration.cmdIcon1
    property string cmdRun2: Plasmoid.configuration.cmdRun2
    property string cmdTitle2: Plasmoid.configuration.cmdTitle2
    property string cmdIcon2: Plasmoid.configuration.cmdIcon2

    // -- Widget style options
    property bool volume_widget_flat: true
    property bool volume_widget_title: false
    property bool volume_widget_thin: true
    property bool brightness_widget_flat: true
    property bool brightness_widget_title: false
    property bool brightness_widget_thin: true

    property bool useSystemColorsOnToggles: false
    property bool useSystemColorsOnSliders: false
    property color toggleButtonsColor: accentColor
    property color toggleButtonsIconColor: "#FFFFFF"
    property color slidersColor: accentColor
    property bool usePlasmaSliders: false

    // -- Screenshot
    property bool hideWidgetBeforeScreenshot: Plasmoid.configuration.hideWidgetOnScreenshot
    property string screenshotCommand: Plasmoid.configuration.screenshotCommand

    // -- Quick actions
    property bool enableQuickActions: Plasmoid.configuration.enableQuickActions

    // -- Panel detection
    readonly property bool inPanel: (Plasmoid.location === PlasmaCore.Types.TopEdge
        || Plasmoid.location === PlasmaCore.Types.RightEdge
        || Plasmoid.location === PlasmaCore.Types.BottomEdge
        || Plasmoid.location === PlasmaCore.Types.LeftEdge)

    // -- Main icon
    Plasmoid.icon: Plasmoid.configuration.useCustomButtonImage ? Plasmoid.configuration.customButtonImage : Plasmoid.configuration.icon

    property int plasmaVersion

    Plasma5Support.DataSource {
        id: executable
        engine: "executable"
        connectedSources: ["plasmashell -v"]
        onNewData: {
            if(data["exit code"] == 0){
                plasmaVersion = data.stdout.split(" ")[1].split(".")[1];
            }
            disconnectSource(connectedSources)
        }
    }

    switchHeight: fullRepWidth
    switchWidth: fullRepWidth
    preferredRepresentation: inPanel ? Plasmoid.compactRepresentation : Plasmoid.fullRepresentation
    fullRepresentation: FullRepresentation { }
    compactRepresentation: CompactRepresentation {}
}
