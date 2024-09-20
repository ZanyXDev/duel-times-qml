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
  signal showStoryPage
  property bool pageActive: false
  property real soundsVolume
  property bool enableSounds
  property int playerImageSize: 256 * DevicePixelRatio
  // ----- Size information
  // ----- Then comes the other properties. There's no predefined order to these.
  onPageActiveChanged: {
    if (root.pageActive === true) {
      showAnimation.start()
    }
  }

  // ----- Visual children.
  background: Rectangle {
    id: bgrRect
    anchors.fill: parent
    color: "black"
    border.color: "darkgrey"
    border.width: 4 * DevicePixelRatio
  }

  ColumnLayout {
    id: mainSelectCharacterLayout

    anchors.fill: parent
    spacing: 8 * DevicePixelRatio
    Item {
      // spacer item
      Layout.fillWidth: true
      Layout.preferredHeight: 32 * DevicePixelRatio
    }
    QQC2.Label {
      id: selectCharLabel
      Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
      Layout.fillWidth: true
      Layout.preferredHeight: 72 * DevicePixelRatio

      visible: false
      opacity: 0
      text: qsTr("Select your character")
      horizontalAlignment: Text.AlignHCenter
      verticalAlignment: Text.AlignVCenter
      padding: 2 * DevicePixelRatio

      style: Text.Outline
      styleColor: "blue"

      color: "lightcyan"

      font {
        family: AppSingleton.droidFont.name
        pointSize: AppSingleton.extraLargeFontSize
      }

      layer.enabled: true
      layer.effect: DropShadow {
        horizontalOffset: 3 * DevicePixelRatio
        verticalOffset: 4 * DevicePixelRatio
        radius: 8 * DevicePixelRatio
        samples: 12
        color: "darkgrey"
      }
    }
    Item {
      // spacer item
      Layout.fillWidth: true
      Layout.preferredHeight: 1 * DevicePixelRatio
    }
    RowLayout {
      id: characterNameRow
      Layout.fillWidth: true
      Layout.preferredHeight: root.playerImageSize
      Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
      spacing: 24 * DevicePixelRatio

      Item {
        // spacer item
        Layout.fillHeight: true
        Layout.preferredWidth: 24 * DevicePixelRatio
      }

      PlayerCard {
        id: nameRem
        Layout.preferredHeight: root.playerImageSize
        Layout.preferredWidth: root.playerImageSize
        characterName: qsTr("Rem")
        characterPicture: "qrc:/res/images/players/rem-normal.jpeg"
        sourceSize.height: root.playerImageSize
        sourceSize.width: root.playerImageSize
      }

      PlayerCard {
        id: nameJohn
        Layout.preferredHeight: root.playerImageSize
        Layout.preferredWidth: root.playerImageSize

        characterName: qsTr("John")
        characterPicture: "qrc:/res/images/players/john-normal.jpeg"
        sourceSize.height: root.playerImageSize
        sourceSize.width: root.playerImageSize
      }
      PlayerCard {
        id: nameNino
        Layout.preferredHeight: root.playerImageSize
        Layout.preferredWidth: root.playerImageSize
        characterName: qsTr("Nino")
        characterPicture: "qrc:/res/images/players/nino-normal.jpeg"
        sourceSize.height: root.playerImageSize
        sourceSize.width: root.playerImageSize
      }
      PlayerCard {
        id: nameFoxy
        Layout.preferredHeight: root.playerImageSize
        Layout.preferredWidth: root.playerImageSize
        characterName: qsTr("Foxy")
        characterPicture: "qrc:/res/images/players/foxy-normal.jpeg"
        sourceSize.height: root.playerImageSize
        sourceSize.width: root.playerImageSize
      }
      Item {
        // spacer item
        Layout.fillHeight: true
        Layout.preferredWidth: 24 * DevicePixelRatio
      }
    }
    Item {
      // spacer item
      Layout.fillWidth: true
      Layout.preferredHeight: 196 * DevicePixelRatio
      //color: "red"
    }
  }

  // ----- Qt provided non-visual children
  // Sounds
  SoundEffect {
    id: btnClik
    source: "qrc:/res/sounds/sfx/menu_click.wav"
    volume: soundsVolume
  }

  SequentialAnimation {
    id: showAnimation
    PropertyAction {
      targets: [selectCharLabel, nameRem, nameJohn, nameNino, nameFoxy]
      property: "visible"
      value: true
    }
    NumberAnimation {
      targets: [selectCharLabel, nameRem, nameJohn, nameNino, nameFoxy]
      properties: "opacity"
      from: 0
      to: 0.8
      duration: AppSingleton.timer2000
      easing.type: Easing.Linear
    }
  }
}
