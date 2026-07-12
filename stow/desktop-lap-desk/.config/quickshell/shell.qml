//@ pragma UseQApplication
import QtQuick
import QtQuick.Layouts
import Quickshell

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
    // namespace defaults to "quickshell" (matches the Hyprland blur layer rule)

    // §1.2 center — overlaid at the true horizontal center
    Clock {
      barWindow: bar
      anchors.horizontalCenter: parent.horizontalCenter
      anchors.verticalCenter: parent.verticalCenter
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
