import QtQuick

import "components"
import "Style"

// §4.4 CPU: aggregate usage from /proc/stat jiffy delta (1 s).
Pill {
  id: cpu
  icon: "\uf4bc"
  text: "..."

  property int usage: 0
  property int lastTotal: 0
  property int lastIdle: 0
  state: usage > 80 ? "critical" : usage > 60 ? "warning" : "normal"

  Poll {
    command: ["head", "-1", "/proc/stat"]
    interval: 1000
    onLine: data => {
      if (!data)
        return
      var p = data.trim().split(/\s+/)
      var user = parseInt(p[1]) || 0
      var nice = parseInt(p[2]) || 0
      var sys = parseInt(p[3]) || 0
      var idle = parseInt(p[4]) || 0
      var iowait = parseInt(p[5]) || 0
      var irq = parseInt(p[6]) || 0
      var softirq = parseInt(p[7]) || 0
      var steal = parseInt(p[8]) || 0
      var total = user + nice + sys + idle + iowait + irq + softirq + steal
      var idleT = idle + iowait
      if (cpu.lastTotal > 0) {
        var dt = total - cpu.lastTotal
        var di = idleT - cpu.lastIdle
        if (dt > 0)
          cpu.usage = Math.round(100 * (dt - di) / dt)
      }
      cpu.lastTotal = total
      cpu.lastIdle = idleT
      cpu.text = cpu.usage + "%"
    }
  }

  property var barWindow: null

  onClicked: pop.toggle()

  CpuPopup {
    id: pop
    triggerItem: cpu
    barWindow: cpu.barWindow
  }
}
