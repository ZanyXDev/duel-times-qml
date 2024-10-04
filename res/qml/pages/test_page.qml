import QtQuick 2.15
import QtQuick.Controls 2.15 as QQC2
import QtMultimedia 5.15

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
    border.width: 4 * DevicePixelRatio
  }

  Rectangle {
    id: rect
    anchors.left: parent.left
    anchors.top: parent.top
    anchors.margins: 100
    height: 200
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

  ShadersButton {
    id: btn1
    text: qsTr("btn1")

    anchors {
      left: parent.left
      leftMargin: 10 * DevicePixelRatio
      bottom: parent.bottom
      bottomMargin: 40 * DevicePixelRatio
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
      leftMargin: 10 * DevicePixelRatio
      bottom: parent.bottom
      bottomMargin: 40 * DevicePixelRatio
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
      leftMargin: 10 * DevicePixelRatio
      bottom: parent.bottom
      bottomMargin: 40 * DevicePixelRatio
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
      leftMargin: 10 * DevicePixelRatio
      bottom: parent.bottom
      bottomMargin: 40 * DevicePixelRatio
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
      leftMargin: 10 * DevicePixelRatio
      bottom: parent.bottom
      bottomMargin: 40 * DevicePixelRatio
    }

    onClicked: {
      showAnimation.hideList = [btn1, btn2, btn3, btn4]
      showAnimation.start()
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
