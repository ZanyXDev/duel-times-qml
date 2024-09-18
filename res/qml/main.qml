import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15 as QQC2
import QtGraphicalEffects 1.15
import Qt.labs.settings 1.0

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

  // ----- Signal declarations
  signal screenOrientationUpdated(int screenOrientation)

  // ----- Size information
  width: (isMobile) ? 640 * DevicePixelRatio : 1280 * DevicePixelRatio
  height: (isMobile) ? 360 * DevicePixelRatio : 720 * DevicePixelRatio
  maximumHeight: height
  maximumWidth: width

  minimumHeight: height
  minimumWidth: width
  // ----- Then comes the other properties. There's no predefined order to these.
  visible: true
  visibility: (isMobile) ? Window.FullScreen : Window.Windowed
  flags: Qt.Dialog
  title: qsTr(" ")

  //Screen.orientationUpdateMask: Qt.LandscapeOrientation

  // ----- Then attached properties and attached signal handlers.

  // ----- Signal handlers
  Component.onCompleted: {
    let infoMsg = `Screen.height[${Screen.height}], Screen.width[${Screen.width}]
    DevicePixelRatio :[${DevicePixelRatio}]
    Screen [height ${height},width ${width}]
    Build with [${HAL.getAppBuildInfo()}]
    Available physical screens [${Qt.application.screens.length}]
    `
    AppSingleton.toLog(infoMsg)
    appWnd.moveToCenter()
  }

  Component.onDestruction: {

    //    let bgrIndex = mSettings.currentBgrIndex
    //  bgrIndex++
    // mSettings.currentBgrIndex = (bgrIndex < 20) ? bgrIndex : 0
    //mSettings.currentLevelId = gamePage.currentLevel
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

  background: Image {
    id: background
    anchors.fill: parent
    source: "qrc:/res/images/title.jpg"
    fillMode: Image.PreserveAspectCrop
    opacity: 0.8
  }

  // ----- Visual children
  FadeStackLayout {
    id: fadeLayout

    InitPage {
      id: initPage
      onShowNextPage: {
        console.trace()
        AppSingleton.toLog(`onShowNextPage`)
        if (fadeLayout.count > 1) {
          fadeLayout.currentIndex++
        }
      }
    }

    // GamePage {
    //   id: gamePage
    // }
    Component.onCompleted: {
      initPage.pageActive = true
    }
  }

  //  ----- non visual children
  Settings {
    id: mSettings
    category: "Settings"
    property int currentBgrIndex
    // property alias currentLevelId: gamePage.currentLevel
  }

  Timer {
    id: timerT1
    interval: AppSingleton.timer2000
    repeat: true
    running: false
    onTriggered: {
      if (isDebugMode) {

        // fadeLayout.currentIndex = 1
      } else {
        var idx = fadeLayout.currentIndex

        if (idx < fadeLayout.count) {
          idx++
        }
        if (idx == fadeLayout.count) {
          idx = 0
        }
        fadeLayout.currentIndex = idx
      }
    }
  }

  // ----- JavaScript functions
  function moveToCenter() {
    appWnd.y = (Screen.desktopAvailableHeight / 2) - (height / 2)
    appWnd.x = (Screen.desktopAvailableWidth / 2) - (width / 2)
  }
}

/**
    Item {
  splashScreen
      /**
       //3..2..1..go
                  Timer {
                      id: countdownTimer
                      interval: 1000
                      running: root.countdown < 5
                      repeat: true
                      onTriggered: root.countdown++
                  }
                  Repeater {
                      model: ["content/gfx/text-blank.png", "content/gfx/text-3.png", "content/gfx/text-2.png", "content/gfx/text-1.png", "content/gfx/text-go.png"]
                      delegate: Image {
                          visible: root.countdown <= index
                          opacity: root.countdown == index ? 0.5 : 0.1
                          scale: root.countdown >= index ? 1.0 : 0.0
                          source: modelData
                          Behavior on opacity { NumberAnimation {} }
                          Behavior on scale { NumberAnimation {} }
                      }
                  }


    }
  */

