import QtQuick 2.1
import Sailfish.Silica 1.0
import "../components"

Page {
    id: page
    property int heightHeader: parent.height / 3
    property int heightNavi: Theme.paddingLarge *3
    property int heightTab: parent.height - heightNavi - heightHeader

    Item {
        id: powerSwitch
        width: parent.width
        height: heightHeader

        SilicaFlickable {
            id: flick
            anchors.fill: parent
            PullDownMenu {
                id: powerSwitchPullDown

                MenuItem {
                    id: about
                    text: qsTr("About")
                    onClicked: {
                        app.openPageAbout()
                    }
                }

                MenuItem {
                    id: start
                    text: qsTr("Start server")
                    visible: notifications.serverState === notifications._SERVER_STATE_INACTIVE
                    onClicked: {
                        app.startServers();
                        verticalFlick.stop()
                        verticalFlick.running = false
                        verticalFlick.loops = 0
                    }
                }
                MenuItem {
                    id: stop
                    text: qsTr("Stop server")
                    visible: notifications.serverState === notifications._SERVER_STATE_ACTIVE
                    onClicked: {
                        app.stopServers();
                    }
                }
            }

            MyActionButton {
                text: "Start server"
                iconSource: "image://theme/harbour-wlan-keyboard"
                //: console.log("pressend")
                width: parent.width
                height: parent.height
                anchors.fill: parent
            }
        }

        TouchInteractionHint {
            id: verticalFlick
            loops: Animation.Infinite
            running: false
            anchors.horizontalCenter: parent.horizontalCenter
            direction:  TouchInteraction.Down
        }

        Component.onCompleted:  {
            if(settings.firstRun) {
                verticalFlick.start()
                settings.firstRun = false
            }
        }
    }

    SilicaListView {
        id: tabs
        anchors.top: powerSwitch.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        height: heightTab
        width: parent.width
        boundsBehavior: Flickable.StopAtBounds
        orientation: ListView.Horizontal
        snapMode: ListView.SnapOneItem
        highlightRangeMode: ListView.StrictlyEnforceRange
        cacheBuffer: width * 2
        highlightMoveDuration: 0
        clip: true
        pressDelay: 300
        keyNavigationWraps: true

        property bool tabRuntimeIsShowing
        property bool tabConfigIsShowing

        //NumberAnimation { target: parent; property: "contentX"; duration: 1000; easing.type: Easing.InOutQuad }

        highlightFollowsCurrentItem: true

        VerticalScrollDecorator{}

        model: VisualItemModel {
            TabRuntime { id: tabRuntime }
            TabConfig { id: tabConfig }

        }

        onCurrentIndexChanged: {
            tabRuntimeIsShowing = tabs.currentIndex == 0
            tabConfigIsShowing = tabs.currentIndex == 1

        }
    }

    Item {
        anchors.left: parent.left
        anchors.right: parent.right

        height: heightNavi
        width: parent.width
        anchors {
            top: tabs.bottom
        }

        Rectangle {
            id: marker
            color: Theme.highlightBackgroundColor
            width: parent.width / naviRepeater.count
            x: tabs.currentIndex * width
            height: 5
            anchors.bottom: naviRow.top
            opacity: 0.5

            Behavior on x {
                NumberAnimation {
                    duration:  100
                }
            }
        }

        Row {
            width: parent.width
            height: parent.height
            id: naviRow

            Repeater {
                id: naviRepeater
                model: [qsTr("Runtime"), qsTr("Configuration")]

                Item {
                    id: naviItem
                    height: parent.height
                    width: naviRow.width / naviRepeater.count
                    property int ind: index

                    Label {
                        text: modelData
                        anchors.centerIn: parent
                        font.pixelSize: Theme.fontSizeExtraSmall
                        font.bold: true
                        color: Theme.secondaryColor
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            if (tabs.currentIndex != parent.ind)
                                tabs.incrementCurrentIndex()

                        }
                    }
                }
            }
        }
    }
}
