import QtQuick 2.15
import QtQuick.Controls 2.15 as QQC2
import QtMultimedia 5.15

import common 1.0
import ui_items 1.0

QQC2.Page {
  id: root

  ///TODO add private QtObject

  // ----- Property Declarations
  // Required properties should be at the top.
  readonly property bool _small_width: AppSingleton.is_width_small(parent.width)

  property bool pageActive: false
  property bool enableMusics
  property bool enableSounds

  // ----- Signal declarations
  signal showSelectCharacterPage

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
    AppSingleton.toLog(
          `AppSingleton._scaling_factor[${AppSingleton._scaling_factor}]`)
  }

  // ----- Visual children.
  background: BorderImage {
    id: background
    anchors.fill: parent
    border {
      left: 48
      top: 48
      right: 48
      bottom: 48
    }
    horizontalTileMode: BorderImage.Stretch
    verticalTileMode: BorderImage.Stretch
    source: "qrc:/res/images/title.jpg"
    opacity: 0.8
  }

  AppVersionTxt {
    id: appVerText
    text: "v." + AppVersion
    color: "black"
    z: 1
    opacity: 0
    visible: false
    anchors {
      bottom: parent.bottom
      bottomMargin: 24
      right: parent.right
      rightMargin: 24
    }
  }

  ShadersButton {
    id: tapToStartBtn
    text: qsTr("Tap to Start")
    font {
      family: AppSingleton.baseFont.name
      pointSize: AppSingleton.averageFontSize
    }

    visible: false
    opacity: 0
    anchors {
      bottom: parent.bottom
      bottomMargin: 24
      horizontalCenter: parent.horizontalCenter
    }
    onClicked: {
      if (enableSounds) {
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
