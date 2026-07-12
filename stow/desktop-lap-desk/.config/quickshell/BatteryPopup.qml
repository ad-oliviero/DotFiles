import QtQuick
import QtQuick.Layouts

import "components"
import "Style"

// §5.7 Battery popup: capacity graph (green charging / orange discharging) +
// detailed stats and conditional time estimates. Self-contained polling.
Popup {
  id: root
  title: "Battery"
  popupWidth: 360
  popupHeight: 460

  property var history: []
  property int cap: 0
  property bool charging: false
  property real voltage: 0 // V
  property real power: 0 // W
  property real energy: 0 // Wh
  property real energyFull: 0 // Wh
  property int cycles: 0
  property real tempC: -1

  // §5.7 "Xh YYm" / "--:--" / ">99h"
  function fmtTime(hours) {
    if (!isFinite(hours) || hours <= 0)
      return "--:--"
    if (hours > 99)
      return ">99h"
    var h = Math.floor(hours)
    var m = Math.round((hours - h) * 60)
    if (m === 60) {
      h++
      m = 0
    }
    return h + "h " + (m < 10 ? "0" + m : m) + "m"
  }

  readonly property real to20: root.energyFull > 0 && root.power > 0 ? (root.energy - root.energyFull * 0.2) / root.power : NaN
  readonly property real toEmpty: root.power > 0 ? root.energy / root.power : NaN
  readonly property real to60: root.energyFull > 0 && root.power > 0 ? (root.energyFull * 0.6 - root.energy) / root.power : NaN
  readonly property real toFull: root.power > 0 ? (root.energyFull - root.energy) / root.power : NaN

  Poll {
    active: root.visible
    command: ["sh", "-c", "d=/sys/class/power_supply/BAT0; [ -d \"$d\" ] || d=/sys/class/power_supply/BAT1; cd \"$d\" 2>/dev/null || exit 0; for f in capacity status voltage_now power_now energy_now energy_full cycle_count; do printf '%s=%s\\n' \"$f\" \"$(cat \"$f\" 2>/dev/null)\"; done; printf 'temp=%s\\n' \"$(cat hwmon*/temp1_input 2>/dev/null)\""]
    interval: 5000
    onLine: data => {
      var eq = data.indexOf("=")
      if (eq < 0)
        return
      var key = data.substring(0, eq)
      var val = data.substring(eq + 1).trim()
      if (key === "capacity")
        root.cap = parseInt(val) || 0
      else if (key === "status")
        root.charging = val === "Charging"
      else if (key === "voltage_now")
        root.voltage = parseInt(val) / 1e6
      else if (key === "power_now")
        root.power = parseInt(val) / 1e6
      else if (key === "energy_now")
        root.energy = parseInt(val) / 1e6
      else if (key === "energy_full")
        root.energyFull = parseInt(val) / 1e6
      else if (key === "cycle_count")
        root.cycles = parseInt(val) || 0
      else if (key === "temp")
        root.tempC = parseInt(val) / 1000
      if (key === "capacity") {
        var h = root.history.slice()
        h.push(root.cap)
        if (h.length > 60)
          h.shift()
        root.history = h
      }
    }
  }

  function statFont() {
    return {
      family: Style.font.family,
      pixelSize: Style.size.textSize
    }
  }

  content: ColumnLayout {
    width: parent.width
    spacing: 6

    Graph {
      maxSamples: 60
      series: [{
          label: "Battery",
          color: root.charging ? Style.color.green : Style.color.orange,
          values: root.history
        }]
    }

    Text {
      Layout.fillWidth: true
      color: Style.color.fg
      text: "Status: " + (root.charging ? "Charging" : "Discharging") + ", " + root.cap + "%"
      font: root.statFont()
    }
    Text {
      Layout.fillWidth: true
      color: Style.color.fg
      visible: root.tempC > 0
      text: Math.round(root.tempC) + "°C, " + root.voltage.toFixed(2) + " V"
      font: root.statFont()
    }
    Text {
      Layout.fillWidth: true
      color: Style.color.fg
      text: root.power.toFixed(2) + " W, " + root.energy.toFixed(1) + " / " + root.energyFull.toFixed(1) + " Wh"
      font: root.statFont()
    }
    Text {
      Layout.fillWidth: true
      color: Style.color.fg
      text: "Cycles: " + root.cycles
      font: root.statFont()
    }
    Text {
      Layout.fillWidth: true
      color: Style.color.fg
      text: root.charging ? "→60%: " + root.fmtTime(root.to60) + "   →100%: " + root.fmtTime(root.toFull) : "→20%: " + root.fmtTime(root.to20) + "   →0%: " + root.fmtTime(root.toEmpty)
      font: root.statFont()
    }
  }
}
