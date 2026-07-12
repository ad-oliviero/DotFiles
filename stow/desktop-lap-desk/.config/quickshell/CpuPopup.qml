import QtQuick
import QtQuick.Layouts

import "components"
import "Style"

// §5.5 CPU popup: 60 s usage graph + stats. Self-contained polling.
Popup {
  id: root
  title: "CPU Usage"
  popupWidth: 380
  popupHeight: 400

  property var history: []
  property int lastTotal: 0
  property int lastIdle: 0

  // stats
  property int cores: 0
  property int freqMHz: 0
  property real load1: 0

  Poll {
    active: root.visible
    command: ["head", "-1", "/proc/stat"]
    interval: 1000
    onLine: data => {
      if (!data)
        return
      var p = data.trim().split(/\s+/)
      var total = 0
      for (var i = 1; i <= 8; i++)
        total += parseInt(p[i]) || 0
      var idleT = (parseInt(p[4]) || 0) + (parseInt(p[5]) || 0)
      var usage = 0
      if (root.lastTotal > 0) {
        var dt = total - root.lastTotal
        var di = idleT - root.lastIdle
        if (dt > 0)
          usage = Math.round(100 * (dt - di) / dt)
      }
      root.lastTotal = total
      root.lastIdle = idleT
      var h = root.history.slice()
      h.push(usage)
      if (h.length > 60)
        h.shift()
      root.history = h
    }
  }

  Poll {
    active: root.visible
    command: ["sh", "-c", "echo \"cores=$(nproc)\"; echo \"freq=$(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq 2>/dev/null)\"; echo \"load=$(cut -d' ' -f1 /proc/loadavg)\""]
    interval: 2000
    onLine: data => {
      var eq = data.indexOf("=")
      if (eq < 0)
        return
      var key = data.substring(0, eq)
      var val = data.substring(eq + 1).trim()
      if (key === "cores")
        root.cores = parseInt(val) || 0
      else if (key === "freq")
        root.freqMHz = Math.round((parseInt(val) || 0) / 1000)
      else if (key === "load")
        root.load1 = parseFloat(val) || 0
    }
  }

  readonly property int currentUsage: root.history.length > 0 ? root.history[root.history.length - 1] : 0

  content: ColumnLayout {
    width: parent.width
    spacing: 8

    Graph {
      maxSamples: 60
      series: [{
          label: "CPU",
          color: Style.color.orange,
          values: root.history
        }]
    }

    Text {
      Layout.fillWidth: true
      color: Style.color.fg
      text: "Usage: " + root.currentUsage + "%"
      font: Style.textFont()
    }
    Text {
      Layout.fillWidth: true
      color: Style.color.fg
      text: "Cores: " + root.cores + (root.freqMHz > 0 ? "   Frequency: " + root.freqMHz + " MHz" : "")
      font: Style.textFont()
    }
    Text {
      Layout.fillWidth: true
      color: Style.color.fg
      text: "Load (1m): " + root.load1.toFixed(2)
      font: Style.textFont()
    }
  }
}
