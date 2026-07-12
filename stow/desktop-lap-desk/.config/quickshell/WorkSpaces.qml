import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland

import "components"
import "Style"

// §2 dynamic Hyprland workspaces: only existing ones, ascending. Active =
// focused (orange). Click switches; scroll cycles within the existing set.
RowLayout {
  id: root
  spacing: 6

  // existing workspaces, ascending by id (reactive to Hyprland.workspaces)
  readonly property var sorted: {
    var v = Hyprland.workspaces.values
    var list = []
    for (var i = 0; i < v.length; i++)
      list.push(v[i])
    list.sort(function (a, b) {
      return a.id - b.id
    })
    return list
  }

  Repeater {
    model: root.sorted
    delegate: Pill {
      required property var modelData
      text: modelData.id
      state: modelData.id === Hyprland.focusedWorkspace?.id ? "active" : "normal"
      onClicked: Hyprland.dispatch("workspace " + modelData.id)
      onWheel: delta => {
        var idx = root.sorted.findIndex(w => w.id === modelData.id)
        if (idx < 0)
          return
        // scroll up (delta > 0) -> lower number, scroll down -> higher
        var next = delta > 0 ? idx - 1 : idx + 1
        if (next < 0 || next >= root.sorted.length)
          return
        Hyprland.dispatch("workspace " + root.sorted[next].id)
      }
    }
  }
}
