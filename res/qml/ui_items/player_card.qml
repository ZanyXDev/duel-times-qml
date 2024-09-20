import QtQuick 2.15
import QtQuick.Controls 2.15 as QQC2
import QtQuick.Layouts 1.15
import QtGraphicalEffects 1.0

import common 1.0
import ui_items 1.0

Item {
  id: root

  property alias characterName: nameLabel.text
  property alias characterPicture: characterPicture.source
  property alias sourceSize: characterPicture.sourceSize
  signal pressed
  signal clicked
  signal hoverChanged

  ColumnLayout {
    id: mainLayout
    anchors.fill: parent
    spacing: 2 * DevicePixelRatio
    Item {
      // spacer item
      Layout.fillWidth: true
      Layout.preferredHeight: 2 * DevicePixelRatio
    }
    ImageRotateButton {
      id: characterPicture

      Layout.preferredWidth: root.width
      Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
      onClicked: root.clicked()
      onPressed: root.pressed()
      onHoverChanged: root.hoverChanged()
    }
    Item {
      // spacer item
      Layout.fillWidth: true
      Layout.preferredHeight: 8 * DevicePixelRatio
    }

    QQC2.Label {
      id: nameLabel

      Layout.preferredWidth: root.width
      Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
      horizontalAlignment: Text.AlignHCenter
      verticalAlignment: Text.AlignVCenter
      padding: 2 * DevicePixelRatio

      style: Text.Outline
      styleColor: "blue"

      color: "lightcyan"

      font {
        family: AppSingleton.droidFont.name
        pointSize: AppSingleton.middleFontSize
      }

      layer.enabled: true
      layer.effect: DropShadow {
        horizontalOffset: 2 * DevicePixelRatio
        verticalOffset: 4 * DevicePixelRatio
        radius: 4 * DevicePixelRatio
        samples: 8
        color: "darkgrey"
      }
    }

    Item {
      // spacer item
      Layout.fillWidth: true
      Layout.preferredHeight: 2 * DevicePixelRatio
    }
  }
}
