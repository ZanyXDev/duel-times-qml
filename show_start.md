
Item {
id:root
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
