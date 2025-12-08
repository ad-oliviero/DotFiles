import QtQuick
import QtQuick.Layouts
import QtQml
import Quickshell.Hyprland

import "Style"

RowLayout {
  id: wsWidget
  Repeater {
    model: 9
    Rectangle {
      property var ws: Hyprland.workspaces.values.find(w => w.id == index + 1)
      property var isActive: Hyprland.focusedWorkspace?.id == (index + 1)
      color: isActive ? Style.color.orange : (ws ? Style.color.bg : Style.color.bgt)
      height: wsText.height + 4
      width: wsText.width + 16
      radius: 10
      Text {
        id: wsText
        anchors.centerIn: parent
        text: index + 1
        color: parent.isActive ? Style.color.bg : (parent.ws ? Style.color.fg : Style.color.bgt)
        font {
          family: Style.fontFamily
          pixelSize: Style.textSize
          bold: true
        }
        MouseArea {
          anchors.fill: parent
          onClicked: Hyprland.dispatch("workspace " + (index + 1))
        }
      }
    }
  }
}
