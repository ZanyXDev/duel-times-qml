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
    readonly property int safe_padding: 24
    readonly property int padding_amount: 2
    readonly property int padding_amount_2x: 2 * __p.padding_amount
    readonly property int image_size: 128
    readonly property int spacing: 8
    readonly property int spacing_x3: 3 * __p.spacing
    readonly property int title_row: 64
    property variant visualItems: [selectCharLabel, pCardRem, labelRem, pCardJohn, labelJohn, pCardNino, labelNino, pCardFoxy, labelFoxy]
  }

  // ----- Property Declarations
  // Required properties should be at the top.
  readonly property bool _small_width: AppSingleton.is_width_small(parent.width)
  property bool pageActive: false
  property bool enableMusics
  property bool enableSounds

  property int player_id: -1
  // ----- Signal declarations
  signal showStoryPage(int player_id)

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
    anchors.margins: __p.safe_padding
    columnSpacing: __p.spacing
    rowSpacing: __p.spacing
    columns: 4
    rows: 4

    component IButton: ImageButton {
      property int player_id: -1

      Layout.fillHeight: true
      Layout.fillWidth: true
      Layout.preferredHeight: 3
      sourceSize.height: __p.image_size
      sourceSize.width: __p.image_size

      onClicked: {
        if (enableSounds) {
          btnClik.play()
        }
        root.player_id = player_id
        setupHideAnimation()
      }
    }

    component ILabel: QQC2.Label {
      Layout.fillHeight: true
      Layout.fillWidth: true
      Layout.preferredHeight: 1

      horizontalAlignment: Text.AlignHCenter
      verticalAlignment: Text.AlignTop
      visible: false
      opacity: 0
      padding: (_small_width) ? __p.padding_amount_2x : __p.padding_amount

      text: qsTr("Don't show")
      style: Text.Outline
      styleColor: "blue"
      color: "lightcyan"

      font.family: AppSingleton.droidFont.name

      layer.enabled: true
      layer.effect: DropShadow {
        horizontalOffset: 2
        verticalOffset: 4
        radius: 4
        samples: 8
        color: "darkgrey"
      }
    }

    ILabel {
      id: selectCharLabel

      Layout.row: 0
      Layout.column: 0
      Layout.columnSpan: 4
      Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter

      text: qsTr("Select your character")
      font.pointSize: (_small_width) ? AppSingleton.middleFontSize : AppSingleton.largeFontSize
    }

    IButton {
      id: pCardRem
      Layout.row: 1
      Layout.column: 0
      player_id: Utils.Char_id.Rem
      source: "qrc:/res/images/players/rem-normal.jpeg"
    }
    IButton {
      id: pCardJohn

      Layout.row: 1
      Layout.column: 1
      player_id: Utils.Char_id.John
      source: "qrc:/res/images/players/john-normal.jpeg"
    }
    IButton {
      id: pCardNino
      Layout.row: 1
      Layout.column: 2
      player_id: Utils.Char_id.Nino
      source: "qrc:/res/images/players/nino-normal.jpeg"
    }
    IButton {
      id: pCardFoxy
      Layout.row: 1
      Layout.column: 3
      player_id: Utils.Char_id.Foxy
      source: "qrc:/res/images/players/foxy-normal.jpeg"
    }

    ILabel {
      id: labelRem

      Layout.row: 2
      Layout.column: 0

      text: qsTr("Rem")
      font.pointSize: AppSingleton.averageFontSize
    }
    ILabel {
      id: labelJohn

      Layout.row: 2
      Layout.column: 1

      text: qsTr("John")
      font.pointSize: AppSingleton.averageFontSize
    }
    ILabel {
      id: labelNino

      Layout.row: 2
      Layout.column: 2

      text: qsTr("Nino")
      font.pointSize: AppSingleton.averageFontSize
    }
    ILabel {
      id: labelFoxy

      Layout.row: 2
      Layout.column: 3

      text: qsTr("Foxy")
      font.pointSize: AppSingleton.averageFontSize
    }

    Rectangle {
      id: textRow
      Layout.row: 3
      Layout.column: 0
      Layout.columnSpan: 4
      Layout.fillHeight: true
      Layout.fillWidth: true
      visible: false
      Layout.preferredHeight: 1
      color: "green"
    }
  }

  // ----- Qt provided non-visual children
  function setupHideAnimation() {

    // switch (player_id) {
    // case Utils.Char_id.Rem:
    //   hideAnimation.firstList
    //       = [selectCharLabel, pCardJohn, labelJohn, pCardNino, labelNino, pCardFoxy, labelFoxy]
    //   hideAnimation.secondList = [pCardRem, labelRem]
    //   break
    // case Utils.Char_id.John:
    //   break
    // case Utils.Char_id.Nino:
    //   break
    // case Utils.Char_id.Foxy:
    //   break
    // default:
    //   break
    // }
    hideAnimation.start()
  }

  function nextPage() {
    root.showStoryPage(root.player_id)
  }

  // Sounds
  SoundEffect {
    id: btnClik
    source: "qrc:/res/sounds/sfx/menu_click.wav"
  }

  SequentialAnimation {
    id: showAnimation
    PropertyAction {
      targets: __p.visualItems
      property: "visible"
      value: true
    }
    NumberAnimation {
      targets: __p.visualItems
      properties: "opacity"
      from: 0
      to: 0.8
      duration: AppSingleton.timer2000
      easing.type: Easing.Linear
    }
  }

  SequentialAnimation {
    id: hideAnimation

    NumberAnimation {
      targets: __p.visualItems
      properties: "opacity"
      from: 1.0
      to: 0
      duration: AppSingleton.timer1500

      easing.type: Easing.Linear
    }
    PropertyAction {
      targets: __p.visualItems
      property: "visible"
      value: false
    }

    PauseAnimation {
      duration: AppSingleton.timer200
    }
    ScriptAction {
      script: nextPage()
    }
  }
}
