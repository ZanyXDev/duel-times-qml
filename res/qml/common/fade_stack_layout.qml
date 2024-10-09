import QtQuick 2.15
import QtQuick.Layouts 1.15
import common 1.0

StackLayout {
  id: root
  anchors.fill: parent

  property int previousIndex: 0
  property Item previousItem
  property Item currentItem

  Component {
    id: crossFader
    ParallelAnimation {
      property Item fadeOutTarget
      property Item fadeInTarget

      NumberAnimation {
        target: fadeOutTarget
        property: "opacity"
        to: 0
        duration: AppSingleton.timer500
        easing.type: Easing.Linear
      }
      PropertyAction {
        targets: [fadeOutTarget]
        property: "pageActive"
        value: false
      }
      NumberAnimation {
        target: fadeInTarget
        property: "opacity"
        to: 1
        duration: AppSingleton.timer500
        easing.type: Easing.Linear
      }
      PropertyAction {
        targets: [fadeInTarget]
        property: "pageActive"
        value: true
      }
    }
  }
  Component.onCompleted: {
    previousIndex = currentIndex
    for (var i = 1; i < count; ++i) {
      children[i].opacity = 0
    }
  }

  onCurrentIndexChanged: {
    previousItem = root.children[previousIndex]
    currentItem = root.children[currentIndex]

    if (previousItem && currentItem && (previousItem != currentItem)) {
      previousItem.visible = true
      currentItem.visible = true
      var crossFaderAnim = crossFader.createObject(parent, {
                                                     "fadeOutTarget": previousItem,
                                                     "fadeInTarget": currentItem
                                                   })
      let infoMsg = `
      FadeStackLayout.onCurrentIndexChanged
      root [height]${root.height}, width[${root.width}]
      previousItem [height${previousItem.height}], width[${previousItem.width}]
      currentItem [height ${currentItem.height},width ${currentItem.width}]
      `
      AppSingleton.toLog(infoMsg)
      crossFaderAnim.restart()
    }

    previousIndex = currentIndex
  }
}
