import QtQuick 2.0

import "tache.js" as Activity

Item {
    id: taskItem

    property bool taskHovered: false
    property string defaultColor : "red"
    property string hoveredColor : "grey"
    property int taskColumnIndex
    property string taskDescription : ""


    width: taskWidth
    height: taskHeight

    DropArea {
        id: dragTarget

        property bool entered: false

        width: parent.width
        height: parent.height

        onExited: {
            console.log("exited")
            dropRectangle.color = defaultColor

            console.log("taskItem index: " + index)

            if (taskItem.defaultColor !== "blue") {
                taskData.get(taskColumnIndex).tasks.remove(index-1,1)
            }
        }



        onEntered: {


            console.log("entered index: " + index)


//            console.log("task hovered status: " + taskItem.taskHovered)

            console.log("taskItem.color: " + taskItem.defaultColor)
            dropRectangle.color = hoveredColor


            if (taskItem.defaultColor === "blue") {     //? This part make no sens!!! What I can achieve with a color (blue) I can not do it with a boolean (taskHovered)!
                console.log("task hovered, do not insert")
            } else {
                console.log("task not entered yet, insert")
                taskData.get(taskColumnIndex).tasks.insert(index, {"description": "red", /*"taskHovered": true*/ color:"blue"})
                //taskData.get(taskColumnIndex).tasks.set(index, {"taskHovered": true})
            }

        }

        onDropped: {
            console.log("dropped")
            dropRectangle.color = "black"

            taskData.get(taskColumnIndex).tasks.insert(index, {"description": "red", "taskHovered": true, color:"blue"})
        }


        Rectangle {
            id: dropRectangle

            width: parent.width
            height: parent.height

            anchors.fill: parent

            color: taskItem.defaultColor

            Text {
                anchors.fill: parent

                text: taskItem.taskDescription
            }
        }
    }
}
