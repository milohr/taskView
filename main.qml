import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQml.Models 2.1

import "tache.js" as Activity


ApplicationWindow {
    id: applicationWindow
    visible: true
    width: 1000
    height: 1000
    
    
    property string tempTaskValue : ""


    property int taskWidth: 250
    property int taskHeight: 100



    function app()
    {
        return   applicationWindow;
    }



    // Add here the QML items you need to access in javascript
    QtObject {
        id: items
        property alias taskRepeater : taskRepeater
        //property alias tasksModel : tasksModel
        property alias root : root
        property alias taskData : taskData

    }


    Component.onCompleted: {
        Activity.start(items)
        Activity.init()
    }


    Rectangle {
        id: root

        width: taskWidth * 3
        height: 1000

        ListModel {
            id: taskData

            ListElement {

                headerTitle: "Header Title 1"
                tasks: [
                    ListElement {
                        title: "Column 1 First task title"
                        description: "Column 1 First task description"
                        image: "Column 1 First task image"
                        taskHovered: false
                        color: "red"
                    },
                    ListElement {
                        title: "Column 1 second task title"
                        description: "Column 1 second task description"
                        image: "Column 1 second task image"
                        taskHovered: false
                        color: "red"
                    }
                ]
                footerTitle: "Footer Title"
            }


            ListElement {

                headerTitle: "Header Title 2"
                tasks: [
                    ListElement {
                        title: "Column 2 First task title"
                        description: "Column 2 First task description"
                        image: "Column 2 First task image"
                        taskHovered: false
                        color: "red"
                    },
                    ListElement {
                        title: "Column 2 second task title"
                        description: "Column 2 second task description"
                        image: "Column 2 second task image"
                        taskHovered: false
                        color: "red"
                    }
                ]
                footerTitle: "Footer Title 2"
            }

        }


        //tasksRow and its repeater create n tasks columns, n being the number of elements (level 1) in Activity.tasks array
        Row {
            id: tasksRow
            spacing: 10

            Repeater {
                id: taskRepeater

                model: taskData

                // taskColumnRectangle includes tasks header, n tasks and a footer button to add additional tasks
                Rectangle {
                    id: taskColumnRectangle

                    property bool tempTaskAreaInserted: false
                    property int previousIndex: 0

                    width: taskWidth
                    height: 1000
                    border.width: 1
                    color: "yellow"

                    property int taskColumnRectangleIndex: index

                    Rectangle {
                        id: headerRectangle

                        anchors.top: parent.top
                        anchors.left: parent.left
                        width: taskWidth
                        height: 50

                        Text {
                            id: headerText

                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.verticalCenter: parent.verticalCenter

                            text: qsTr("Title " + taskData.get(index).headerTitle)
                        }
                    }


                    //listView displaying all the tasks contained in each Activity.tasks array level
                    ListView {
                        id: tasksListView

                        anchors.top: headerRectangle.bottom
                        anchors.left: parent.left

                        spacing: 20

                        width: parent.width
                        //height: Activity.tasks[taskColumnRectangleIndex].length * 50 < 500 ? Activity.tasks[taskColumnRectangleIndex].length * 50 : 500

                        height: 800

                        property int dragItemIndex: -1

                        model: taskData.get(index).tasks

                        delegate: taskComponent

                        Component.onCompleted: { console.log("Index : " + index) }
                    }


                    //at the moment a simple DropArea linked to a rectangle but will be replaced by Tache.qml in the future to be able to contain task informations and goals
                    Component {
                        id: taskComponent

                        Task {

                            taskColumnIndex: taskColumnRectangleIndex
                            taskDescription: description
                            taskHovered: taskHovered
                            defaultColor: color
                        }
                    }

                    //footer with the + caption
                    Rectangle {
                        id: footerRectangle

                        anchors.top: tasksListView.bottom
                        anchors.left: parent.left
                        width: parent.width
                        height: 50

                        Text {
                            id: footerText

                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.verticalCenter: parent.verticalCenter

                            text: qsTr("+")

                            MouseArea {
                                id: addTaskButton

                                anchors.fill: parent
                                onClicked: {
                                    var tmp = Activity.tasks
                                    tmp[taskColumnRectangleIndex].push("test")
                                    Activity.tasks = tmp

                                    console.log("rr")

                                    //taskRepeater.model = Activity.tasks
                                }
                            }
                        }
                    }
                }
            }
        }

        // movingTask is a temporary task that is movable. It is used to try the concept.
        // the Task elements contained in the ListView are at the moment a DropArea that interacts with movingTask
        // movingTask is a mousearea linked to a rectangle.
        // When movingTask enters Task, an supplementary task (a value in the array) is added at the index of the task entered.
        // When exiting the task, this supplementary task is removed.
        // If movingTask is dropped on any of the Task element a supplementary task is definitly added.
        TaskMobile {
            id: movingTask

            z: 10

            anchors.top: tasksRow.top
            anchors.left: tasksRow.right

            width: taskWidth
            height: taskHeight

        }
    }
}
