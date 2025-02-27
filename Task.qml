import QtQuick 2.0

import "tache.js" as Activity


Item {
    id: taskItem

    property string defaultColor : "red"
    property string hoveredColor : "grey"
    property int taskColumnIndex
    property int taskIndex
    property string taskDescription
    property string taskTitle

    width: parent.width
    height: taskColumn.height

    DropArea {
        id: taskItemDropArea
        anchors.fill: parent
        width: parent.width

        onContainsDragChanged: {
            console.log("taskItemDropArea" + taskItemDropArea + " TaskSource" + taskItemDropArea.drag.source + "Mousearea " + mouseArea)

        }


        MouseArea {
            id: mouseArea

            anchors.fill: parent
            drag.target: taskColumn
            width: parent.width

            propagateComposedEvents: true

            onReleased: {
                parent = taskColumn.Drag.target !== null ? taskColumn.Drag.target : taskItem
                console.log("id of the item to drag: " + taskColumn.Drag.target)
                taskColumn.Drag.drop()
                taskColumn.parent = taskItem
                taskColumn.x = 0
                taskColumn.y = 0
            }

            Column {
                id: taskColumn

                property int taskColumnIndex
                property int taskIndex

                taskColumnIndex: taskItem.taskColumnIndex
                taskIndex: taskItem.taskIndex
                width: parent.width
                spacing: 10
                Drag.active: mouseArea.drag.active
                Drag.hotSpot.x: 32
                Drag.hotSpot.y: 32

                Rectangle {
                    id: taskRectangle

                    width: parent.width
                    height: taskContent.computedTaskHeight
                    color: taskItem.defaultColor

                    TaskContent {
                        id: taskContent

                        taskDescription: taskItem.taskDescription
                        taskTitle: taskItem.taskTitle
                    }

                    states: State {
                        when: mouseArea.drag.active
                        ParentChange { target: taskColumn; parent: taskBoard }
                        AnchorChanges {
                            target: taskColumn
                            anchors.horizontalCenter: undefined
                            anchors.verticalCenter: undefined
                        }
                        PropertyChanges {
                            target: taskColumn
                            width: taskItem.parent.width
                        }
                    }
                }

                Rectangle {
                    id: bottomPlaceHolder

                    visible: taskItemDropArea.containsDrag && (taskItemDropArea.drag.source !== taskColumn)
                    width: parent.width
                    height: taskHeight
                    color: !bottomPlaceHolderDropArea.containsDrag ? "grey" : "green"

                    Text {
                        anchors.fill: parent
                        text: "bottom placeholder"
                    }

                    DropArea {
                        id: bottomPlaceHolderDropArea

                        anchors.fill: parent

                        onDropped: {
                            var tmpData = visualModel.model
                            tmpData[taskColumnIndex].tasks.splice(index+1, 0,tmpData[drag.source.taskColumnIndex].tasks[drag.source.taskIndex])
                            tmpData[drag.source.taskColumnIndex].tasks.splice(drag.source.taskIndex, 1)
                            visualModel.model = tmpData

                            console.log("ddd:" + tmpData[0].headertitle)
                            console.log(drag.source.taskColumnIndex)
                            console.log(drag.source.taskIndex)


                        }
                    }
                }
            }
        }
    }
}


