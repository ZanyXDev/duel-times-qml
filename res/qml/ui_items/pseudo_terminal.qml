import QtQuick 2.15
import QtQuick.Controls 2.15 as QQC2
import QtMultimedia 5.15
import QtQuick.Layouts 1.15
import QtGraphicalEffects 1.0

import common 1.0

Rectangle {
  id: root

  property alias textFont: mTerminal.font
  property int delay: 100

  property int typeWritePos
  property color shadowColor: "white"
  property color textColor: "darkgreen"
  property real shadowOpacity: 0.75
  property string sourceText: ""
  property string terminalText: " "

  layer.effect: DropShadow {
    id: shadow
    horizontalOffset: 3
    verticalOffset: 5
    radius: 8
    samples: 11
    color: root.shadowColor
    opacity: root.shadowOpacity
  }

  TextEdit {
    id: mTerminal
    anchors.fill: parent
    readOnly: true
    textMargin: 10

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
    onTriggered: (Math.random() < 0.75) ? doTypeWriter() : null
    onRunningChanged: ((running === false)
                       && isDebugMode) ? print("Stopped.") : null
  }

  function doTypeWriter() {
    let text = sourceText.slice(0, ++root.typeWritePos)
    if (text === sourceText)
      return effectsTimer.stop()

    root.terminalText = text
  }
}
