import QtQuick 2.1
import QtFeedback 5.0
import Sailfish.Silica 1.0

Item {
    height: tabs.height
    width: tabs.width

    Column {
        width: parent.width
        anchors {
            left: parent.left
            //leftMargin: Theme.paddingLarge * 2
            topMargin: 50
            top: parent.top

        }

        ComboBox {
            width: parent.width
            label: "Interface"
            currentIndex: 0
            anchors.left: parent.left

            menu: ContextMenu {
                MenuItem { text: "192.168.1.11" }
            }
        }

        ComboBox {
            width: parent.width
            label: "Port"
            anchors.left: parent.left
            menu: ContextMenu {
                MenuItem { text: "7777" }
            }
        }

        TextSwitch {
            text: "Start on launch"
            description: "Start server on app launch"
        }


        TextSwitch {
            text: "Use HTTPS"
        }


        ComboBox {
            id: keyboardMode
            width: parent.width
            label: "Keyboard mode"
            currentIndex: 0
            anchors.left: parent.left

            menu: ContextMenu {
                MenuItem { text: "Clipboard" }
                MenuItem { text: "Keyboard layout" }
            }
        }

        Label {
            id: desc
            width: parent.width
            text: "Experimental"
            anchors.left: parent.left
            anchors.leftMargin: Theme.paddingLarge
            opacity: 1
            wrapMode: Text.Wrap
            font.pixelSize: Theme.fontSizeExtraSmall
            color: Theme.secondaryColor
        }

    }
}
