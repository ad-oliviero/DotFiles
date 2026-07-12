import QtQuick

import "components"
import "Style"

// §4.6 battery: capacity % + level icon, charging green / <20 red / <30 yellow.
Pill {
  id: bat
  iconTrailing: true
  text: "..."

  property int cap: 0
  property bool charging: false
  state: charging ? "charging" : cap < 20 ? "critical" : cap < 30 ? "warning" : "normal"

  readonly property var _icons: ["󰁺", "󰁻", "󰁼", "󰁽", "󰁾", "󰁿", "󰂀", "󰂁", "󰂂", "󰁹"]
  icon: bat._icons[Math.min(9, Math.floor(bat.cap / 10))]

  Poll {
    command: ["sh", "-c", "d=/sys/class/power_supply/BAT0; [ -d \"$d\" ] || d=/sys/class/power_supply/BAT1; cd \"$d\" 2>/dev/null || exit 0; echo \"capacity=$(cat capacity)\"; echo \"status=$(cat status)\""]
    interval: 5000
    onLine: data => {
      var eq = data.indexOf("=")
      if (eq < 0)
        return
      var key = data.substring(0, eq)
      var val = data.substring(eq + 1).trim()
      if (key === "capacity")
        bat.cap = parseInt(val) || 0
      else if (key === "status")
        bat.charging = val === "Charging"
      bat.text = bat.cap + "%"
    }
  }

  property var barWindow: null

  onClicked: pop.toggle()

  BatteryPopup {
    id: pop
    triggerItem: bat
    barWindow: bat.barWindow
  }
}
