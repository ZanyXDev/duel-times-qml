import QtQuick 2.15
import QtQuick.Controls 2.15 as QQC2
import QtMultimedia 5.15
import QtQuick.Layouts 1.15
import QtGraphicalEffects 1.0

import common 1.0

Rectangle {
  id: root

  property alias textFont: mTerminal.font
  property int delay: 40

  property int typeWritePos
  property color shadowColor: "white"
  property color textColor: "darkgreen"
  property real shadowOpacity: 0.75
  property string sourceText
  property string terminalText
  property bool blink: false

  layer.effect: DropShadow {
    id: shadow
    horizontalOffset: 3
    verticalOffset: 5
    radius: 8
    samples: 11
    color: root.shadowColor
    opacity: root.shadowOpacity
  }

  TextInput {
    id: mTerminal
    anchors.fill: parent
    anchors.margins: 10
    readOnly: true
    horizontalAlignment: TextEdit.AlignJustify
    wrapMode: TextEdit.WrapAtWordBoundaryOrAnywhere
    text: root.terminalText
    color: root.textColor
  }

  Timer {
    id: effectsTimer
    interval: root.delay
    repeat: true
    running: true
    onTriggered: {
      blink = (blink) ? false : true
      if (Math.random() < 0.75) {
        doTypeWriter()
      }
      (root.terminalText === root.sourceText) ? effectsTimer.stop() : doBlink()
    }
    // onRunningChanged: running === false ? root.terminalText = root.terminalText.slice(
    //                                         0, -1) : null
  }

  function doTypeWriter() {
    let text = sourceText.slice(0, ++root.typeWritePos)

    root.terminalText = text
  }

  function doBlink() {
    if (root.terminalText.length > 1) {
      root.terminalText = root.terminalText.slice(0, -1)
    }
    root.terminalText += (blink) ? "|" : " "
  }
}
