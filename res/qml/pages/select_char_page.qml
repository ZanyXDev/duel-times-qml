import QtQuick 2.15
import QtQuick.Controls 2.15 as QQC2
import QtMultimedia 5.15
import QtQuick.Layouts 1.15
import QtGraphicalEffects 1.0

import common 1.0
import ui_items 1.0
import "qrc:/res/js/utils.js" as Utils

QQC2.Page {
  id: root

  // ----- Property Declarations
  // Required properties should be at the top.
  readonly property bool _small_width: AppSingleton.is_width_small(parent.width)
  property bool pageActive: false
  property real soundsVolume
  property bool enableSounds
  property int playerImageSize: 128

  // ----- Signal declarations
  signal showStoryPage(int character_id)
  // ----- Size information
  // ----- Then comes the other properties. There's no predefined order to these.
  onPageActiveChanged: {
    if (root.pageActive === true) {

      let infoMsg = `
      select_page.onPageActiveChanged: ${root.height},${root.width}
      selectCharLabel: ${selectCharLabel.height}, ${selectCharLabel.width}
      charNameRWL: ${charNameRWL.height}, ${charNameRWL.width}
      placeHolder: ${placeHolder.height}, ${placeHolder.width}
      `
      AppSingleton.toLog(infoMsg)
      showAnimation.start()
    }
  }
  Component.onCompleted: {
    AppSingleton.toLog(`select_page.onCompleted: ${root.height},${root.width}`)
  }
  // ----- Visual children.
  background: Rectangle {
    id: bgrRect
    anchors.fill: parent
    color: "black"
  }

  ColumnLayout {
    id: mainCNL
    anchors.fill: parent
    spacing: 8

    Item {
      // spacer item
      Layout.fillWidth: true
      Layout.fillHeight: true
    }
    Rectangle {
      id: selectCharLabel
      Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
      Layout.fillWidth: true
      Layout.preferredHeight: 72

      color: "red"
      Text {
        id: selectCharLabelTxt
        text: `selectCharLabel: ${selectCharLabel.height}, ${selectCharLabel.width}`
      }
    }
    Rectangle {
      id: charNameRWL
      Layout.fillWidth: true
      Layout.preferredHeight: root.playerImageSize
      Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
      color: "green"
      Text {
        id: charNameRWLTxt
        text: `charNameRWL: ${charNameRWL.height}, ${charNameRWL.width}`
      }
    }
    Rectangle {
      id: placeHolder
      Layout.alignment: Qt.AlignRight
      Layout.preferredHeight: root.playerImageSize
      Layout.fillWidth: true
      // /Layout.margins: 32
      height: root.playerImageSize
      width: root.playerImageSize
      color: "yellow"
      Text {
        id: debugTxt
        text: `placeHolder: ${placeHolder.height}, ${placeHolder.width}`
      }
    }
    Item {
      // spacer item
      Layout.fillWidth: true
      Layout.fillHeight: true
    }
  }

  // ----- Qt provided non-visual children
  function setupHideAnimation(char_id) {
    switch (char_id) {
    case Utils.Char_id.Rem:
    {
      hideAnimation.hideList = [pCardJohn, pCardNino, pCardFoxy, pCardRem]
      break
    }
    default:
    {
      break
    }
    }
    hideAnimation.start()
  }

  // Sounds
  SoundEffect {
    id: btnClik
    source: "qrc:/res/sounds/sfx/menu_click.wav"
    volume: soundsVolume
  }

  SequentialAnimation {
    id: showAnimation
    PropertyAction {
      targets: [selectCharLabel, pCardRem, pCardJohn, pCardNino, pCardFoxy]
      property: "visible"
      value: true
    }
    NumberAnimation {
      targets: [selectCharLabel, pCardRem, pCardJohn, pCardNino, pCardFoxy]
      properties: "opacity"
      from: 0
      to: 0.8
      duration: AppSingleton.timer2000
      easing.type: Easing.Linear
    }
  }
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
}
