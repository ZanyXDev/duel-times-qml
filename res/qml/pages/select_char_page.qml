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
  // Property thats used for sizing/margins/layout
  QtObject {
    id: __p
    readonly property int padding_amount: 2
    readonly property int padding_amount_2x: 2 * __p.padding_amount
    readonly property int image_row_size: 128
    readonly property int spacing: 8
    readonly property int spacing_x3: 3 * __p.spacing
    readonly property int title_row: 64
  }

  // ----- Property Declarations
  // Required properties should be at the top.
  readonly property bool _small_width: AppSingleton.is_width_small(parent.width)
  property bool pageActive: false
  property real soundsVolume
  property bool enableSounds

  // ----- Signal declarations
  signal showStoryPage(int character_id)
  // ----- Size information
  // ----- Then comes the other properties. There's no predefined order to these.
  onPageActiveChanged: {
    if (root.pageActive === true) {
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

  GridLayout {
    id: _grid
    anchors.fill: parent
    anchors.margins: 10
    columnSpacing: 10
    rowSpacing: 10
    columns: 3
    rows: 3
    Rectangle {
      id: _1
      Layout.row: 0
      Layout.column: 0
      Layout.rowSpan: 2
      Layout.fillHeight: true
      Layout.fillWidth: true
      Layout.preferredWidth: 2
      color: "green"
      Text {
        text: "1"
      }
    }
    Rectangle {
      id: _2
      Layout.row: 0
      Layout.column: 1
      Layout.rowSpan: 2
      Layout.fillHeight: true
      Layout.fillWidth: true
      Layout.preferredWidth: 3
      color: "lightgreen"
      Text {
        text: "2"
      }
    }
    Rectangle {
      id: _6
      Layout.row: 2
      Layout.column: 0
      Layout.columnSpan: 2
      Layout.fillHeight: true
      Layout.fillWidth: true
      color: "grey"
      Text {
        text: "6"
      }
    }
    Rectangle {
      id: _3
      Layout.row: 0
      Layout.column: 2
      Layout.fillWidth: true
      Layout.fillHeight: true
      Layout.preferredWidth: 2
      color: "lightgray"
      Text {
        text: "3"
      }
    }
    Rectangle {
      id: _4
      Layout.row: 1
      Layout.column: 2
      Layout.fillWidth: true
      Layout.fillHeight: true
      Layout.preferredWidth: 2
      color: "orange"
      Text {
        text: "4"
      }
    }
    Rectangle {
      id: _5
      Layout.row: 2
      Layout.column: 2
      Layout.fillWidth: true
      Layout.fillHeight: true
      Layout.preferredWidth: 2
      color: "skyblue"
      Text {
        text: "5"
      }
    }
  }

  ColumnLayout {
    id: mainCNL
    visible: false
    anchors.fill: parent
    spacing: __p.spacing
    Item {
      // spacer item
      Layout.fillWidth: true
      Layout.preferredHeight: __p.spacing
      Rectangle {
        id: tst1
        anchors.fill: parent
        color: "red"
      }
    }
    QQC2.Label {
      id: selectCharLabel
      Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
      Layout.fillWidth: true
      Layout.preferredHeight: __p.title_row
      visible: false
      opacity: 0
      padding: (_small_width) ? __p.padding_amount_2x : __p.padding_amount
      style: Text.Outline
      styleColor: "blue"

      color: "lightcyan"
      text: (isDebugMode) ? `Label ${selectCharLabel.height},${selectCharLabel.width}` : qsTr(
                              "Select your character")
      horizontalAlignment: Text.AlignHCenter
      verticalAlignment: Text.AlignVCenter

      font {
        family: AppSingleton.droidFont.name
        pointSize: (_small_width) ? AppSingleton.middleFontSize : AppSingleton.largeFontSize
      }

      layer.enabled: true
      layer.effect: DropShadow {
        horizontalOffset: 3
        verticalOffset: 4
        radius: 8
        samples: 12
        color: "darkgrey"
      }
    }

    RowLayout {
      id: charNameRWL
      Layout.fillWidth: true
      Layout.preferredHeight: __p.image_row_size
      Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
      spacing: __p.spacing_x3

      component PCard: PlayerCard {
        Layout.preferredHeight: __p.image_row_size
        Layout.preferredWidth: __p.image_row_size
        sourceSize.height: __p.image_row_size
        sourceSize.width: __p.image_row_size

        onClicked: {
          if (enableSounds) {
            btnClik.play()
          }
          setupHideAnimation(characterId)
        }
      }
      Item {
        // spacer item
        Layout.fillHeight: true
        Layout.fillWidth: true
      }
      PCard {
        id: pCardRem
        characterName: qsTr("Rem")
        characterPicture: "qrc:/res/images/players/rem-normal.jpeg"
        characterId: Utils.Char_id.Rem
      }
      PCard {
        id: pCardJohn
        characterName: qsTr("John")
        characterPicture: "qrc:/res/images/players/john-normal.jpeg"
        characterId: Utils.Char_id.John
      }
      PCard {
        id: pCardNino
        characterName: qsTr("Nino")
        characterPicture: "qrc:/res/images/players/nino-normal.jpeg"
        characterId: Utils.Char_id.Nino
      }
      PCard {
        id: pCardFoxy
        characterName: qsTr("Foxy")
        characterPicture: "qrc:/res/images/players/foxy-normal.jpeg"
        characterId: Utils.Char_id.Foxy
      }
      Item {
        // spacer item
        Layout.fillHeight: true
        Layout.fillWidth: true
      }
    }

    Item {
      // spacer item
      Layout.fillWidth: true
      Layout.preferredHeight: __p.spacing
      Rectangle {
        id: tst
        anchors.fill: parent
        color: "red"
      }
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
