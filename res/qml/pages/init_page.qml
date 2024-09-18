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
  signal showSelectCharacterPage
  property bool pageActive: false

  // ----- Size information
  // ----- Then comes the other properties. There's no predefined order to these.
  onPageActiveChanged: {
    AppSingleton.toLog(`InitPage.pageActive [${root.pageActive}]`)
    if (root.pageActive === true) {
      showAnimation.start()
    }
  }

  Component.onCompleted: {
    AppSingleton.toLog(`InitPage [${root.height}h,${root.width}w]`)
  }
  // ----- Visual children.
  background: {
    null
  }

  AppVersionTxt {
    id: appVerText
    text: "v. " + AppVersion
    color: "white"
    z: 1
    opacity: 0
    visible: false
    anchors {
      bottom: parent.bottom
      bottomMargin: 20 * DevicePixelRatio
      right: parent.right
      rightMargin: 20 * DevicePixelRatio
    }
  }

  SButton {
    id: tapToStartBtn
    text: qsTr("Tap to Start")
    visible: false
    opacity: 0
    anchors {
      bottom: parent.bottom
      bottomMargin: 40 * DevicePixelRatio
      horizontalCenter: parent.horizontalCenter
    }
    onClicked: {
      if (appWnd.enableSounds) {
        btnClik.play()
      }
      root.showSelectCharacterPage()
    }
  }
  // ----- Qt provided non-visual children
  // Sounds
  SoundEffect {
    id: btnClik
    source: "qrc:/res/sounds/sfx/button-click.wav"
    volume: appWnd.soundsVolume
  }

  SequentialAnimation {
    id: showAnimation
    PropertyAction {
      targets: [tapToStartBtn, appVerText]
      property: "visible"
      value: true
    }
    NumberAnimation {
      targets: [tapToStartBtn, appVerText]
      properties: "opacity"
      from: 0
      to: 0.8
      duration: AppSingleton.timer2000
      easing.type: Easing.Linear
    }
  }
}
