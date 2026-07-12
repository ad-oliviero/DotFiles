import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.SystemTray
import Quickshell.Widgets

import "../Style"

// System tray: collapsed by default (toggle + pinned items only).
// Left-click: activate (or show menu for onlyMenu items).
// Right-click: show native context menu.
// Middle-click: pin/unpin.
Row {
  id: root
  spacing: 4
  property bool expanded: false
  property var pinnedIds: ({}) // id -> true
  property var barWindow: null

  // SNI icons arrive as "name?path=/usr/..." — resolve to a file URL
  function iconSource(icon) {
    if (!icon)
      return ""
    if (icon.includes("?path=")) {
      var chunks = icon.split("?path=")
      var name = chunks[0]
      var path = chunks[1]
      var fileName = name.substring(name.lastIndexOf("/") + 1)
      return "file://" + path + "/" + fileName
    }
    if (icon.startsWith("/") && !icon.startsWith("file://"))
      return "file://" + icon
    return icon
  }

  // toggle button
  Rectangle {
    width: 28
    height: 28
    radius: 8
    color: togMa.pressed ? Qt.alpha(Style.color.fg, 0.25) : Qt.alpha(Style.color.fg, 0.12)
    Text {
      anchors.centerIn: parent
      color: Style.color.fg
      text: root.expanded ? "◀" : "▶"
      font {
        family: Style.font.family
        pixelSize: Style.size.textSize
      }
    }
    MouseArea {
      id: togMa
      anchors.fill: parent
      onClicked: root.expanded = !root.expanded
    }
  }

  Repeater {
    model: SystemTray.items
    delegate: Item {
      id: wrapper
      required property var modelData
      width: 28
      height: 28
      visible: root.expanded || root.pinnedIds[wrapper.modelData.id] === true

      Rectangle {
        anchors.fill: parent
        radius: 8
        color: itemMa.containsMouse ? Qt.alpha(Style.color.fg, 0.12) : "transparent"
      }

      IconImage {
        anchors.centerIn: parent
        width: 20
        height: 20
        source: root.iconSource(wrapper.modelData.icon)
        visible: status === Image.Ready
      }

      MouseArea {
        id: itemMa
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
        onClicked: function(mouse) {
          var item = wrapper.modelData
          if (!item)
            return
          var pos = mapToItem(null, mouse.x, mouse.y)
          if (mouse.button === Qt.MiddleButton) {
            // toggle pin
            if (root.pinnedIds[item.id])
              delete root.pinnedIds[item.id]
            else
              root.pinnedIds[item.id] = true
            root.pinnedIds = root.pinnedIds
          } else if (mouse.button === Qt.RightButton) {
            // native context menu
            if (item.hasMenu)
              item.display(root.barWindow, Math.round(pos.x), Math.round(pos.y))
            else
              item.secondaryActivate()
          } else {
            // left: activate the app (open/toggle window). Menu-only items
            // fall back to showing the menu.
            if (item.onlyMenu && item.hasMenu)
              item.display(root.barWindow, Math.round(pos.x), Math.round(pos.y))
            else
              item.activate()
          }
        }
        onWheel: function(wheel) {
          var item = wrapper.modelData
          if (item)
            item.scroll(wheel.angleDelta.y, false)
        }
      }
    }
  }
}
