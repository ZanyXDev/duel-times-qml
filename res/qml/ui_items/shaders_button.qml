import QtQuick 2.15
import QtQuick.Particles 2.15
import QtQuick.Controls 2.15 as QQC2
import QtGraphicalEffects 1.0
import common 1.0

QQC2.Button {
  id: root

  property bool effectsOn: true
  property color particleColor: "green"
  state: pressed ? "buttonDown" : "buttonUp"

  background: Rectangle {
    id: bgrRect
    radius: 8
    color: "lightgrey"
    width: parent.width
    height: parent.height
  }

  states: [
    State {
      name: "buttonDown"
      PropertyChanges {
        target: root
        scale: 0.7
      }
    },
    State {
      name: "buttonUp"
      PropertyChanges {
        target: root
        scale: 1.0
      }
    }
  ]

  transitions: Transition {
    NumberAnimation {
      properties: scale
      easing.type: Easing.InOutQuad
      duration: AppSingleton.timer200
    }
  }

  Behavior on scale {
    NumberAnimation {
      duration: AppSingleton.timer200
      easing.type: Easing.OutQuad
    }
  }

  layer.enabled: true
  layer.effect: DropShadow {
    horizontalOffset: 3
    verticalOffset: 4
    radius: 8
    samples: 12
    color: "black"
  }

  // Stars effect
  ParticleSystem {
    id: particleSystem
    anchors.fill: bgrRect
    running: root.effectsOn
    ImageParticle {
      source: "qrc:/res/images/particles/star.png"
      rotationVariation: 180
      color: root.particleColor
    }
    Emitter {
      width: parent.width
      height: 8
      emitRate: 16
      lifeSpan: 2000
      size: 32
      sizeVariation: 16
      endSize: 8
      velocity: PointDirection {
        y: 20
        x: -2
        xVariation: 5
        yVariation: 10
      }
    }
    Turbulence {
      width: parent.width
      height: (parent.height / 2)
      strength: 8
    }
  }

  // Button background
  ShaderEffectSource {
    id: shaderSource
    anchors.fill: bgrRect
    sourceItem: bgrRect
    hideSource: true
    visible: false
  }

  // Particles
  ShaderEffectSource {
    id: shaderSource2
    anchors.fill: particleSystem
    sourceItem: particleSystem
    hideSource: true
    visible: false
  }

  // Mask particles inside the button
  ShaderEffect {
    id: shaderEffectItem
    anchors.fill: shaderSource

    property variant source: shaderSource
    property variant source2: shaderSource2

    fragmentShader: "
uniform sampler2D source;
uniform sampler2D source2;
uniform lowp float qt_Opacity;
varying highp vec2 qt_TexCoord0;
void main() {
lowp vec4 pix = texture2D(source, qt_TexCoord0);
lowp vec4 pix2 = texture2D(source2, qt_TexCoord0);
gl_FragColor = qt_Opacity * (pix + pix.a * pix2);
}"
  }
}
