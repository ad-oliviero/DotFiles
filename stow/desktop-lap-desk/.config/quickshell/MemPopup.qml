import QtQuick
import QtQuick.Layouts

import "components"
import "Style"

// §5.4 Memory popup: usage graph + RAM/Swap/Disks details. Self-contained.
Popup {
  id: root
  title: "Memory"
  popupWidth: 360
  popupHeight: 440

  property real totalGB: 0
  property real usedGB: 0
  property real availGB: 0
  property real pct: 0
  property real swapTotalGB: 0
  property real swapUsedGB: 0
  property var disks: []
  property var history: []

  property var _info: ({})

  Poll {
    active: root.visible
    command: ["cat", "/proc/meminfo"]
    interval: 3000
    onLine: d => {
      var m = d.match(/^(\w+):\s+(\d+)/)
      if (m)
        root._info[m[1]] = parseInt(m[2])
    }
    onFinished: () => {
      var info = root._info
      var total = info.MemTotal || 0
      var avail = info.MemAvailable || 0
      root.totalGB = total / 1048576
      root.availGB = avail / 1048576
      root.usedGB = (total - avail) / 1048576
      root.pct = total > 0 ? (total - avail) / total * 100 : 0
      root.swapTotalGB = (info.SwapTotal || 0) / 1048576
      root.swapUsedGB = ((info.SwapTotal || 0) - (info.SwapFree || 0)) / 1048576
      root._info = ({})
      var h = root.history.slice()
      h.push(Math.round(root.pct))
      if (h.length > 60)
        h.shift()
      root.history = h
    }
  }

  Poll {
    id: dfPoll
    active: root.visible
    command: ["df", "-B1", "-l", "-t", "ext4", "-t", "btrfs", "-t", "xfs", "-t", "zfs", "--output=target,size,used,avail,pcent"]
    interval: 3000
    property var _pending: []

    onLine: d => {
      var p = d.trim().split(/\s+/)
      if (p.length < 5)
        return
      var pcent = parseInt(p[p.length - 1])
      if (isNaN(pcent))
        return
      var used = parseInt(p[p.length - 3])
      var size = parseInt(p[p.length - 4])
      var mount = p.slice(0, p.length - 4).join(" ")
      dfPoll._pending.push({
          mount: mount,
          usedGB: used / 1e9,
          totalGB: size / 1e9,
          pct: pcent
        })
    }
    onFinished: () => {
      root.disks = dfPoll._pending
      dfPoll._pending = []
    }
  }

  content: ColumnLayout {
    width: parent.width
    spacing: 8

    Graph {
      maxSamples: 60
      series: [{
          label: "RAM",
          color: Style.color.orange,
          values: root.history
        }]
    }

    Text {
      Layout.fillWidth: true
      color: Style.color.fg
      text: "RAM: " + root.usedGB.toFixed(2) + " / " + root.totalGB.toFixed(2) + " GB (" + Math.round(root.pct) + "%)"
      font: Style.textFont()
    }
    Text {
      Layout.fillWidth: true
      color: Style.color.fg
      text: "Available: " + root.availGB.toFixed(2) + " GB"
      font: Style.textFont()
    }
    Text {
      Layout.fillWidth: true
      visible: root.swapTotalGB > 0
      color: Style.color.fg
      text: "Swap: " + root.swapUsedGB.toFixed(2) + " / " + root.swapTotalGB.toFixed(2) + " GB"
      font: Style.textFont()
    }
    Repeater {
      model: root.disks
      delegate: Text {
        required property var modelData
        Layout.fillWidth: true
        color: Style.color.fg
        text: modelData.mount + ": " + modelData.usedGB.toFixed(1) + " / " + modelData.totalGB.toFixed(1) + " GB (" + modelData.pct + "%)"
        font: Style.textFont()
      }
    }
  }
}
