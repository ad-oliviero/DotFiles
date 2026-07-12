import QtQuick

import "components"
import "Style"

// §4.3 memory: used RAM in GB (one decimal), warning >60%, critical >80%.
// Disk details live in MemPopup (each popup is self-contained).
Pill {
  id: mem
  icon: "󰍛"
  iconTrailing: true
  text: "..."

  property real usedGB: 0
  property real pct: 0
  state: pct > 80 ? "critical" : pct > 60 ? "warning" : "normal"

  property var _lines: []

  Poll {
    command: ["cat", "/proc/meminfo"]
    interval: 3000
    onLine: data => mem._lines.push(data)
    onFinished: () => {
      var info = {}
      for (var i = 0; i < mem._lines.length; i++) {
        var m = mem._lines[i].match(/^(\w+):\s+(\d+)/)
        if (m)
          info[m[1]] = parseInt(m[2]) // kB
      }
      mem._lines = []
      var total = info.MemTotal || 0
      var avail = info.MemAvailable || 0
      var used = total - avail
      mem.usedGB = used / 1048576
      mem.pct = total > 0 ? used / total * 100 : 0
      mem.text = mem.usedGB > 0 ? mem.usedGB.toFixed(1) + "GB" : "..."
    }
  }

  property var barWindow: null

  onClicked: pop.toggle()

  MemPopup {
    id: pop
    triggerItem: mem
    barWindow: mem.barWindow
  }
}
