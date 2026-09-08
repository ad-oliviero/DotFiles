//@ pragma UseQApplication
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io            // ← required for Process

import "Style"
import "components"

// §1 bar: full-width top, 45 px, transparent (blur via Hyprland layer rule on
// the "quickshell" namespace), 10 px side margins. True-centered clock overlay.
ShellRoot {
  PanelWindow {
    id: bar
    anchors {
      top: true
      left: true
      right: true
    }
    margins {
      left: Style.size.barMargin
      right: Style.size.barMargin
    }
    implicitHeight: Style.size.barHeight
    color: Style.color.bgt

    // §1.2 center — overlaid at the true horizontal center
    Clock {
      id: clock
      barWindow: bar
      anchors.horizontalCenter: parent.horizontalCenter
      anchors.verticalCenter: parent.verticalCenter
    }

    // Launcher button (left of the clock)
    Rectangle {
        id: launcherBtn
        anchors.right: clock.left
        anchors.rightMargin: 8
        anchors.verticalCenter: clock.verticalCenter
        width: 24
        height: 24
        color: "transparent"
        z: 1                          // stay above overlapping items

        Text {
            anchors.centerIn: parent
            text: "\uf00a"            // FontAwesome "th" icon
            font.family: Style.font.icons.family
            font.pixelSize: 18
            color: Style.color.fg
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                console.log("Launcher clicked, starting rofi...")
                launcherProc.running = true   // ← set running to start the process
            }
        }
    }

    // Process – start by setting running = true (as used elsewhere)
    Process {
        id: launcherProc
        running: false
        command: [
            "sh", "-c",
            'uwsm app -- rofi -show drun -theme "$HOME"/.config/rofi/themes/custom -run-command "uwsm app -- {cmd}"'
        ]
      }

    // left
    WorkSpaces {
      anchors.left: parent.left
      anchors.verticalCenter: parent.verticalCenter
    }

    // right row: Network, Volume, Memory, CPU, Temperature, Battery (§4)
    Row {
      anchors.right: parent.right
      anchors.verticalCenter: parent.verticalCenter
      spacing: 8
      Systray { barWindow: bar }
      Net { barWindow: bar }
      Vol { barWindow: bar }
      Mem { barWindow: bar }
      Cpu { barWindow: bar }
      Temp { barWindow: bar }
      Battery { barWindow: bar }
    }
  }
  }
