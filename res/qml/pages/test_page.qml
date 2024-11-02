import QtQuick 2.15
import QtQuick.Controls 2.15 as QQC2
import QtMultimedia 5.15
import QtQuick.Layouts 1.15
import QtGraphicalEffects 1.0

import common 1.0
import ui_items 1.0

QQC2.Page {
  id: root

  // ----- Property Declarations
  // Required properties should be at the top.

  // ----- Signal declarations
  property bool pageActive: false

  // ----- Size information
  // ----- Then comes the other properties. There's no predefined order to these.
  onPageActiveChanged: {
    AppSingleton.toLog(`TestPage.pageActive [${root.pageActive}]`)
    if (root.pageActive === true) {
      showAnimation.start()
    }
  }

  Component.onCompleted: {
    AppSingleton.toLog(`TestPage [${root.height}h,${root.width}w]`)
  }

  // ----- Visual children.
  background: Rectangle {
    id: bgrRect
    anchors.fill: parent
    color: "black"
    border.color: "darkgrey"
    border.width: 4
  }

  // Text {
  //   id: txt1
  //   // This user interface string is used only here
  //   //: The back of the object, not the front
  //   //~ Context Not related to back-stepping
  //   text: qsTr("Back", "not front")
  // }
  ShadersButton {
    id: btn1
    text: qsTr("btn1")

    anchors {
      left: parent.left
      leftMargin: 10
      bottom: parent.bottom
      bottomMargin: 40
    }

    onClicked: {
      hideAnimation.hideList = [btn2, btn3, btn4]
      hideAnimation.start()
    }
  }
  ShadersButton {
    id: btn2
    text: qsTr("btn2")

    anchors {
      left: btn1.right
      leftMargin: 10
      bottom: parent.bottom
      bottomMargin: 40
    }

    onClicked: {
      hideAnimation.hideList = [btn1, btn3, btn4]
      hideAnimation.start()
    }
  }
  ShadersButton {
    id: btn3
    text: qsTr("btn3")

    anchors {
      left: btn2.right
      leftMargin: 10
      bottom: parent.bottom
      bottomMargin: 40
    }

    onClicked: {
      hideAnimation.hideList = [btn1, btn2, btn4]
      hideAnimation.start()
    }
  }

  ShadersButton {
    id: btn4
    text: qsTr("btn4")

    anchors {
      left: btn3.right
      leftMargin: 10
      bottom: parent.bottom
      bottomMargin: 40
    }

    onClicked: {
      hideAnimation.hideList = [btn1, btn2, btn3]
      hideAnimation.start()
    }
  }
  ShadersButton {
    id: btn5
    text: qsTr("reset")
    enabled: !btn1.visible || !btn2.visible || !btn3.visible || !btn4.visible

    anchors {
      left: btn4.right
      leftMargin: 10
      bottom: parent.bottom
      bottomMargin: 40
    }

    onClicked: {
      showAnimation.hideList = [btn1, btn2, btn3, btn4]
      showAnimation.start()
    }
  }

  ShadersButton {
    id: btn6
    text: qsTr("Add Item")
    enabled: !btn1.visible || !btn2.visible || !btn3.visible || !btn4.visible

    anchors {
      left: btn5.right
      leftMargin: 10
      bottom: parent.bottom
      bottomMargin: 40
    }

    onClicked: {

    }
  }

  Rectangle {
    anchors.left: parent.left
    anchors.top: parent.top
    anchors.margins: 10
    width: parent.width - 20
    height: 128

    border.color: "darkgrey"
    color: "grey"
    radius: 8
    layer.enabled: true
    layer.effect: DropShadow {
      horizontalOffset: 3
      verticalOffset: 5
      radius: 8
      samples: 11
      color: "white"
      opacity: 0.75
    }
    TextEdit {
      id: pseudoTerminal
      property bool blink: false
      property int last_item: text.length - 1

      QtObject {
        id: __p
        readonly property string story_1: qsTr(
                                            "После одного из заседаний мирового съезда судьи собрались в совещательной комнате, чтобы снять свои мундиры, минутку отдохнуть и ехать домой обедать._")
      }

      onBlinkChanged: {
        if (blink) {
          pseudoTerminal.select(text.length - 1, text.length)
          pseudoTerminal.selectedTextColor = "grey"
          pseudoTerminal.selectionColor = "grey"
        } else {
          pseudoTerminal.deselect()
        }
      }

      anchors.fill: parent
      readOnly: true

      textMargin: 10
      horizontalAlignment: TextEdit.AlignJustify
      wrapMode: TextEdit.WrapAtWordBoundaryOrAnywhere

      font {
        family: AppSingleton.digitalFont.name

        pointSize: AppSingleton.averageFontSize
      }
      text: __p.story_1
      Component.onCompleted: {
        timerBlink.start()
      }
      Timer {
        id: timerBlink
        interval: AppSingleton.timer500
        repeat: true
        running: stop
        onTriggered: {
          pseudoTerminal.blink = (pseudoTerminal.blink) ? false : true
        }
      }
    }
  }

  // QQC2.Label {
  //   id: blinkCursor
  //   visible: false
  //   text: "▂▂"

  //   color: "darkorange"

  //   font.family: AppSingleton.droidFont.name
  //   font.bold: true
  //   font.pointSize: AppSingleton.averageFontSize

  //   Timer {
  //     id: timerT1
  //     interval: AppSingleton.timer500
  //     repeat: true
  //     running: stop
  //     onTriggered: {
  //       blinkCursor.visible = (blinkCursor.visible) ? false : true
  //     }
  //   }
  // }
  Rectangle {
    id: rect
    visible: false
    anchors.left: parent.left
    anchors.top: parent.top
    anchors.margins: 10
    height: 20
    color: "red"

    state: "default"

    states: [
      State {
        name: "default"

        PropertyChanges {
          target: rect
          width: 2
        }
      },
      State {
        name: "bigger"

        PropertyChanges {
          target: rect
          width: 250
        }
      }
    ]

    transitions: Transition {
      NumberAnimation {
        duration: 500 //ms
        target: rect
        properties: "width"
      }
    }

    // Just there to trigger the state change by clicking on the Rectangle
    MouseArea {
      anchors.fill: parent
      onClicked: {
        if (rect.state === "default")
          rect.state = "bigger"
        else
          rect.state = "default"
      }
    }
  }

  // ----- Qt provided non-visual children
  SequentialAnimation {
    id: hideAnimation
    property list<QtObject> hideList

    NumberAnimation {
      targets: hideAnimation.hideList
      properties: "opacity"
      from: 1.0
      to: 0
      duration: AppSingleton.timer2000

      easing.type: Easing.Linear
    }

    PropertyAction {
      targets: hideAnimation.hideList
      property: "visible"
      value: false
    }
  }
  SequentialAnimation {
    id: showAnimation
    property list<QtObject> hideList
    PropertyAction {
      targets: hideAnimation.hideList
      property: "visible"
      value: true
    }
    NumberAnimation {
      targets: hideAnimation.hideList
      properties: "opacity"
      from: 0
      to: 1.0
      duration: AppSingleton.timer2000

      easing.type: Easing.Linear
    }
  }
}
