import QtQuick 2.15
import QtGraphicalEffects 1.0
import common 1.0

Item {
  id: root
  property alias image: img
  property alias source: img.source
  property alias fillMode: img.fillMode
  property alias sourceSize: img.sourceSize
  property alias verticalAlignment: img.verticalAlignment
  property alias horizontalAlignment: img.horizontalAlignment

  /**
    * @var Qt::MouseButtons acceptedButtons
    * This property holds the mouse buttons that the mouse area reacts to.
    * See <a href="https://doc.qt.io/qt-5/qml-qtquick-mousearea.html#acceptedButtons-prop">Qt documentation</a>.
    */
  property alias acceptedButtons: mArea.acceptedButtons

  /**
    * @var mouseArea Mouse area element covering the button.
    */
  property alias mouseArea: mArea
  property bool isActive: root.enabled && mArea.containsMouse
  property int buttonWidth
  property int buttonHeight: root.buttonWidth

  signal pressed
  signal clicked
  signal hoverChanged

  /** This property Enables accessibility of QML items.
    * See <a href="https://doc.qt.io/qt-5/qml-qtquick-accessible.html">Qt documentation</a>.
    */
  Accessible.role: Accessible.Button
  Accessible.name: qsTr("Image Button")
  Accessible.onPressAction: root.clicked(null)

  implicitWidth: img.sourceSize.width
  implicitHeight: img.sourceSize.height

  Image {
    id: img
    anchors.centerIn: parent
    mipmap: true
    smooth: true
    layer.enabled: true
    layer.effect: DropShadow {
      anchors.fill: img
      horizontalOffset: 3
      verticalOffset: 4
      radius: 5
      samples: 11
      color: "black"
      opacity: 0.75
    }

    MouseArea {
      id: mArea
      anchors.fill: parent
      hoverEnabled: true

      cursorShape: isActive ? Qt.PointingHandCursor : Qt.ArrowCursor
      onClicked: {
        root.clicked()
      }
      onPressed: {
        root.pressed()
      }

      onHoveredChanged: root.hoverChanged()
    }
    state: mArea.pressed ? "buttonDown" : "buttonUp"
    states: [
      State {
        name: "buttonDown"
        PropertyChanges {
          target: img
          scale: 0.7
        }
      },
      State {
        name: "buttonUp"
        PropertyChanges {
          target: img
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
  }
}
