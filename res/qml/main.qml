import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15 as QQC2
import QtGraphicalEffects 1.15
import Qt.labs.settings 1.0
import QtMultimedia 5.15

import common 1.0
import pages 1.0

import "qrc:/res/js/logic.js" as Logic

import io.github.zanyxdev.dueltimes.hal 1.0

QQC2.ApplicationWindow {
  id: appWnd
  // ----- Property Declarations

  // Required properties should be at the top.
  readonly property int screenOrientation: (isMobile) ? Screen.orientation : Qt.LandscapeOrientation
  readonly property bool appInForeground: Qt.application.state === Qt.ApplicationActive

  property bool appInitialized: false
  property real soundsVolume
  property real musicsVolume
  property bool enableSounds
  property bool enableMusics

  // ----- Signal declarations
  signal screenOrientationUpdated(int screenOrientation)

  // ----- Size information
  width: (isMobile) ? 640 * DevicePixelRatio : 1280 * DevicePixelRatio
  height: (isMobile) ? 360 * DevicePixelRatio : 700 * DevicePixelRatio
  maximumHeight: height
  maximumWidth: width

  minimumHeight: height
  minimumWidth: width
  // ----- Then comes the other properties. There's no predefined order to these.
  visible: true
  visibility: (isMobile) ? Window.FullScreen : Window.Windowed
  //ToDo need googled QMl.Window.Flags on mobile phone
  flags: Qt.Window
  //title: qsTr(" ")

  //Screen.orientationUpdateMask: Qt.LandscapeOrientation

  // ----- Then attached properties and attached signal handlers.

  // ----- Signal handlers
  onEnableSoundsChanged: {
    soundsVolume = (enableSounds) ? 1.0 : 0.0
  }
  onEnableMusicsChanged: {
    musicsVolume = (enableMusics) ? 1.0 : 0.0
  }

  Component.onCompleted: {
    let infoMsg = `Screen.height[${Screen.height}], Screen.width[${Screen.width}]
    DevicePixelRatio :[${DevicePixelRatio}]
    Screen [height ${height},width ${width}]
    Build with [${HAL.getAppBuildInfo()}]
    Available physical screens [${Qt.application.screens.length}]
    mSettings.enableMusics ${mSettings.enableMusics}
    `
    AppSingleton.toLog(infoMsg)

    appWnd.moveToCenter()
    appWnd.restoreSettings()
    appWnd.enableMusics ? introMusic.play() : introMusic.stop()
  }

  Component.onDestruction: {

    // mSettings.enableSounds = appWnd.enableSounds
    // mSettings.enableMusics = appWnd.enableMusics
    // mSettings.soundsVolume = appWnd.soundsVolume
    // mSettings.musicsVolume = appWnd.musicsVolume
  }

  onAppInForegroundChanged: {
    if (appInForeground) {
      if (!appInitialized) {
        appInitialized = true
      }
    } else {
      if (isDebugMode)
        AppSingleton.toLog(
              `appInForeground: [${appInForeground} , appInitialized: ${appInitialized}]`)
    }
  }

  background: {
    null
  }

  // ----- Visual children
  FadeStackLayout {
    id: fadeLayout

    TestPage {
      id: testPage
    }

    InitPage {
      id: initPage
      soundsVolume: appWnd.soundsVolume
      enableSounds: appWnd.enableSounds

      onShowSelectCharacterPage: {
        fadeLayout.currentIndex++
      }
    }

    SelectCharacter {
      id: selectCharPage
      soundsVolume: appWnd.soundsVolume
      enableSounds: appWnd.enableSounds
      ///ToDo disable into music befor start game
      onShowStoryPage: {
        fadeLayout.currentIndex++
      }
    }

    Component.onCompleted: {
      AppSingleton.toLog(
            `fadeLayout.currentItem: [${fadeLayout.currentItem} , currentIndex: ${fadeLayout.currentIndex}]`)
      initPage.pageActive = true
    }
  }

  //  ----- non visual children
  Settings {
    id: mSettings
    category: "Settings"
    property alias soundsVolume: appWnd.soundsVolume
    property alias musicsVolume: appWnd.musicsVolume
    property alias enableSounds: appWnd.enableSounds
    property alias enableMusics: appWnd.enableMusics
  }

  Audio {
    id: introMusic
    autoPlay: appWnd.enableMusics
    volume: appWnd.musicsVolume
    source: "qrc:/res/sounds/in-game.mp3"
    loops: Audio.Infinite
    audioRole: Audio.GameRole
  }

  // ----- JavaScript functions
  function moveToCenter() {
    appWnd.y = (Screen.desktopAvailableHeight / 2) - (height / 2)
    appWnd.x = (Screen.desktopAvailableWidth / 2) - (width / 2)
  }

  function restoreSettings() {
    appWnd.enableSounds = mSettings.enableSounds
    appWnd.enableMusics = mSettings.enableMusics
    appWnd.soundsVolume = mSettings.soundsVolume
    appWnd.musicsVolume = mSettings.musicsVolume
  }
}
