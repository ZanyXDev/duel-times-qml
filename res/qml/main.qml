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
  property bool enableSounds
  property bool enableMusics

  property var screenWidth: Screen.width
  property var screenHeight: Screen.height
  property var screenAvailableWidth: Screen.desktopAvailableWidth
  property var screenAvailableHeight: Screen.desktopAvailableHeight

  // ----- Signal declarations
  signal screenOrientationUpdated(int screenOrientation)

  // ----- Size information
  width: (isMobile) ? screenAvailableWidth : 640
  height: (isMobile) ? screenAvailableHeight : 360
  maximumHeight: height
  maximumWidth: width

  minimumHeight: height
  minimumWidth: width
  // ----- Then comes the other properties. There's no predefined order to these.
  visible: true
  visibility: (isMobile) ? Window.FullScreen : Window.Windowed

  // ----- Then attached properties and attached signal handlers.

  // ----- Signal handlers
  Component.onCompleted: {
    let infoMsg = `Screen.height[${Screen.height}], Screen.width[${Screen.width}]
    Screen [height ${height},width ${width}]
    Build with [${HAL.getAppBuildInfo()}]
    Available physical screens [${Qt.application.screens.length}]
    mSettings.enableMusics ${mSettings.enableMusics}
    Available Resolution width: ${Screen.desktopAvailableWidth} height ${Screen.desktopAvailableHeight}
    `
    AppSingleton.toLog(infoMsg)

    if (!isMobile) {
      appWnd.moveToCenter()
    }
    appWnd.restoreSettings()
    appWnd.enableMusics ? introMusic.play() : introMusic.stop()
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

    InitPage {
      id: initPage
      enableMusics: appWnd.enableMusics
      enableSounds: appWnd.enableSounds

      onShowSelectCharacterPage: {
        fadeLayout.currentIndex++
      }
    }

    SelectCharacter {
      id: selectCharPage
      enableMusics: appWnd.enableMusics
      enableSounds: appWnd.enableSounds

      ///ToDo disable into music befor start game
      onShowStoryPage: {
        AppSingleton.toLog(
              `fadeLayout.currentIndex ${fadeLayout.currentIndex} recive player_id: [${player_id}]`)
        fadeLayout.currentIndex++
      }
    }
    TestPage {
      id: testPage
    }
    Component.onCompleted: {
      initPage.pageActive = true
    }
  }

  //  ----- non visual children
  Settings {
    id: mSettings
    category: "Settings"
    property alias enableSounds: appWnd.enableSounds
    property alias enableMusics: appWnd.enableMusics
  }

  Audio {
    id: introMusic
    autoPlay: appWnd.enableMusics
    source: "qrc:/res/sounds/in-game.mp3"
    loops: Audio.Infinite
    audioRole: Audio.GameRole
  }

  // ----- JavaScript functions
  function moveToCenter() {
    appWnd.y = (screenAvailableHeight / 2) - (height / 2)
    appWnd.x = (screenAvailableWidth / 2) - (width / 2)
  }

  function restoreSettings() {
    appWnd.enableSounds = mSettings.enableSounds
    appWnd.enableMusics = mSettings.enableMusics
  }
}
