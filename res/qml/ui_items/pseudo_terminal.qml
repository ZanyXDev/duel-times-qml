import QtQuick 2.15
import QtQuick.Controls 2.15 as QQC2
import QtMultimedia 5.15
import QtQuick.Layouts 1.15
import QtQuick.Particles 2.15
import QtGraphicalEffects 1.0

import common 1.0

Rectangle {
  id: root

  property alias textFont: mTerminal.font
  property int delay: AppSingleton.timer40

  property int typeWritePos
  property color shadowColor: "white"
  property color textColor: "darkgreen"
  property real shadowOpacity: 0.75
  property string sourceText
  property string terminalText
  property bool blink: false

  signal typeWriterStoped

  layer.effect: DropShadow {
    id: shadow
    horizontalOffset: 2
    verticalOffset: 4
    radius: 8
    samples: 16
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
    onRunningChanged: running === false ? doAnimation() : null
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

  function doAnimation() {
    fogEmitter.enabled = true
    mTerminal.opacity = 1
    fogEmitter.emitRate = 4000
    fogAnimation.restart()
  }

  /// TODO think move separate file or not
  ParticleSystem {
    id: fogParticleSystem
  }
  ImageParticle {
    id: fogImageParticle
    visible: false /// Fix visiual artefact blink red dots
    system: fogParticleSystem
    source: "qrc:/res/images/particles/smoke.png"
    color: "#30333333"
  }
  Emitter {
    id: fogEmitter
    system: fogParticleSystem
    anchors.centerIn: parent
    enabled: false

    width: mTerminal.width
    height: mTerminal.height / 2
    anchors.left: mTerminal.left
    y: mTerminal.height / 2 - 12

    lifeSpan: 1000
    lifeSpanVariation: 500
    emitRate: 4000
    size: 12
    sizeVariation: 8
    endSize: 8

    velocity: PointDirection {
      y: -48
      x: 48
      xVariation: 32
      yVariation: 32
    }
  }
  Turbulence {
    id: fogTurbulence
    enabled: true
    anchors.fill: root
    strength: 128
    system: fogParticleSystem
  }

  SequentialAnimation {
    id: fogAnimation

    PauseAnimation {
      duration: AppSingleton.timer200
    }
    /// Fix visiual artefact blink red dots
    PropertyAction {
      target: fogImageParticle
      property: "visible"
      value: true
    }
    ParallelAnimation {
      PropertyAnimation {
        target: fogEmitter
        properties: "emitRate"
        from: 0
        to: 4000
        duration: AppSingleton.timer1500
      }

      PropertyAnimation {
        target: mTerminal
        properties: "opacity"
        to: 0.9
        duration: AppSingleton.timer1500
      }
    }

    // numeric animation
    PropertyAnimation {
      target: mTerminal
      properties: "opacity"
      to: 0.0
      duration: AppSingleton.timer1500
    }

    onStopped: {
      fogEmitter.enabled = false
      typeWriterStoped()
    }
  }
}
