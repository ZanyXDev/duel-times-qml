pragma Singleton

import QtQuick 2.15
import QtQuick.Window 2.15

QtObject {
  id: root
  readonly property real _scaling_factor: Math.min(1.8, Screen.devicePixelRatio)

  readonly property real extraLargeFontSize: _scaling_factor * 48
  readonly property real largeFontSize: _scaling_factor * 36
  readonly property real middleFontSize: _scaling_factor * 24
  readonly property real averageFontSize: _scaling_factor * 16
  readonly property real smallFontSize: _scaling_factor * 12

  /// TODO document better
  // This is for smartphone's and small screen, If they have a screen width less than this
  // we adjust the layout for that kind of display
  readonly property int min_width_threshold: 700

  property FontLoader droidFont: FontLoader {
    id: droidFont
    source: "qrc:/res/fonts/droidsansmono.ttf"
  }
  property FontLoader digitalFont: FontLoader {
    id: digitalFont
    source: "qrc:/res/fonts/681-font.otf"
  }
  property FontLoader gameFont: FontLoader {
    id: gameFont
    source: "qrc:/res/fonts/mailrays.ttf"
  }
  property FontLoader baseFont: FontLoader {
    id: baseFont
    source: "qrc:/res/fonts/nasalization-rg.otf"
  }
  property FontLoader chinaFont: FontLoader {
    id: chinaFont
    source: "qrc:/res/fonts/china.ttf"
  }

  /* This is msecs. Half of second is enough for smooth animation. */
  readonly property int timer16: 16
  readonly property int timer150: 150
  readonly property int timer200: 200
  readonly property int timer500: 500
  readonly property int timer1500: 1500
  readonly property int timer2000: 2000

  function toLog(msg) {
    console.log(`${msg}`)
  }

  /** Checks to see if a given width is considered "small" for the theme */
  function is_width_small(width) {
    return (width < root.min_width_threshold)
  }
}
