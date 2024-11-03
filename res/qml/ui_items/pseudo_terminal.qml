import QtQuick 2.15
import QtQuick.Controls 2.15 as QQC2
import QtMultimedia 5.15
import QtQuick.Layouts 1.15
import QtGraphicalEffects 1.0

import common 1.0

Rectangle {
  id: root

  property alias textFont: mTerminal.font
  property bool enableTypeWriter: false
  property bool d: false
  property bool cursorBlink: false
  property int delay: AppSingleton.timer150
  property int beginCursorPos: terminalText.length - 1
  property int endCursorPos: terminalText.length
  property int typeWritePos: 0
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

  onCursorBlinkChanged: {
    if (cursorBlink) {
      mTerminal.select(root.beginCursorPos, root.endCursorPos)
    } else {
      mTerminal.deselect()
    }
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
    selectedTextColor: root.textColor
    selectionColor: root.textColor
  }

  Timer {
    id: effectsTimer
    interval: root.delay
    repeat: true
    running: true
    onTriggered: {
      if ((root.enableTypeWriter) && (root.sourceText.length !== 0)
          && (root.typeWritePos < root.sourceText.length)) {
        root.doTypeWriter()
      }
      root.cursorBlink = (root.cursorBlink) ? false : true
    }
  }

  function doTypeWriter() {
    let next_letter = getNext()
    if (next_letter.length !== 0) {
      root.terminalText = root.terminalText.slice(0, -1) + next_letter + " "
    }
  }

  function getNext() {
    let tst = ""
    if (Math.random() < 0.75) {
      tst = root.sourceText.slice(root.typeWritePos, root.typeWritePos + 1)
      root.typeWritePos++
    }
    return tst
  }
}
