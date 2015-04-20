import QtQuick 2.1
import QtFeedback 5.0
import Sailfish.Silica 1.0
import "../components"

Item {
    id: tabRuntime
    height: tabs.height
    width: tabs.width

    state: "NOT_RUNNING"

    states: [
        State {
            name: "RUNNING"
            when: notifications.serverState === notifications._SERVER_STATE_ACTIVE
            PropertyChanges { target: connections; opacity: 1 ; visible: true}
            PropertyChanges { target: notRunning; visible: false }
            PropertyChanges { target: noConnection; visible: false }
        },
        State {
            name: "NOT_RUNNING"
            when: notifications.serverState === notifications._SERVER_STATE_INACTIVE
            PropertyChanges { target: connections; visible: false }
            PropertyChanges { target: notRunning; visible: true }
            PropertyChanges { target: noConnection; visible: false }
        },
        State {
            when: notifications.serverState === notifications._SERVER_STATE_NO_CONNECTIVITY
            name: "NO_CONNECTION"
            PropertyChanges { target: connections; visible: false }
            PropertyChanges { target: notRunning; visible: false }
            PropertyChanges { target: noConnection; visible: true }
        }
    ]

    NumberAnimation { targets: [noConnection, notRunning, connections]; properties: "opacity"; duration: 1000 }


    RuntimeNoConnectivityState {
        id: noConnection
    }

    RuntimeInactivState {
        id: notRunning
    }

    RuntimeActiveState {
        id: connections
    }
}
