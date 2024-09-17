pragma Singleton

import QtQuick 2.15

QtObject {
  id: root
  readonly property int largeFontSize: 36
  readonly property int middleFontSize: 24
  readonly property int averageFontSize: 16
  readonly property int smallFontSize: 12
  readonly property int tinyFontSize: 10

  property FontLoader gameFont: FontLoader {
    id: gameFont
    source: "qrc:/res/fonts/droidsansmono.ttf"
  }
 property FontLoader digitalFont: FontLoader {
    id: digitalFont
    source: "qrc:/res/fonts/681-font.otf"
  }

  /* This is msecs. Half of second is enough for smooth animation. */
  readonly property int timer16: 16
  readonly property int timer500: 500
  readonly property int timer2000: 2000
  readonly property int delay_100: 100

  function toLog(msg) {
    console.log(`${msg}`)
  }
}
