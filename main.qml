import QtQuick 2.15
import QtQuick.Window 2.15

Window {
    id: window
    //коэффициент пропорции размеров элементов
    property int ratio: 3
    property int initSize: 60

    minimumHeight: initSize * ratio
    minimumWidth: minimumHeight * 2
    property int oldSize: minimumHeight

    //для сохранения пропорции элементов при изменении размеров окна
    function position(){
        circle.x = circle.x * height / oldSize
        circle.y = circle.y * height / oldSize
        oldSize = height
    }
    onWidthChanged: {
        height = width / 2
        position()
    }
    onHeightChanged: {
        width = height * 2
        position()
    }

    visible: true

    Rectangle {
        id: scene

        state: "initialState"
        anchors.fill: parent

        Rectangle {
            id: leftRect

            width: parent.height / ratio
            height: width

            anchors.left: parent.left
            anchors.leftMargin: (parent.height - height) / 2
            anchors.verticalCenter: parent.verticalCenter

            border.width: ratio
            border.color: "black"
            radius: ratio * 2
            Text {
                anchors.bottom: parent.bottom
                anchors.bottomMargin: parent.height / ratio / 8
                anchors.horizontalCenter: parent.horizontalCenter
                font {
                    pixelSize: parent.height / ratio / 2

                }
                text: "move"
            }
            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    circle.x += Math.random() * parent.width
                    scene.state = "intermediateState"
                    if (circle.x + circle.width >= rightRect.x) {
                        scene.state = "initialState"
                    }
                }
            }
        }

        Rectangle {
            id: rightRect

            width: parent.height / ratio
            height: width

            anchors.right: parent.right
            anchors.rightMargin: (parent.height - height) / 2
            anchors.verticalCenter: parent.verticalCenter

            border.width: ratio
            border.color: "black"
            radius: ratio * 2
            Text {
                id: ret
                anchors.bottom: parent.bottom
                anchors.bottomMargin: parent.height / ratio / 8
                anchors.horizontalCenter: parent.horizontalCenter
                font {
                    pixelSize: parent.height / ratio / 2
                }
                text: "return"
            }
            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: scene.state = "initialState"
            }
        }

        Rectangle {
            id: circle

            width: leftRect.width / ratio
            height: width
            radius: width / 2
            border.width: ratio
            color: "green"
        }

        states: [
            State {
                name: "initialState"
                PropertyChanges {
                    target: circle
                    x: (parent.height - height) / 2
                    y: (parent.height - height) / 2
                }
            },
            State {
                name: "intermediateState"
                PropertyChanges {
                    target: circle
                    x: circle.x
                    y: circle.y
                }
            }
        ]

        transitions: [
            Transition {
                from: "intermediateState"
                to: "initialState"
                NumberAnimation {
                    properties: "x,y"
                    duration: 1000
                    easing.type: Easing.OutBounce
                }
            }
        ]
}
}
