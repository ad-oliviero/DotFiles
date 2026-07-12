import QtQuick

import "components"
import "Style"

// §4.5 temperature: x86_pkg_temp on the bar, warning >60 C, critical >80 C.
Pill {
  id: temp
  icon: "󰔏"
  iconTrailing: true
  text: ""

  property int pkg: -1
  state: pkg > 80 ? "critical" : pkg > 60 ? "warning" : "normal"

  Poll {
    command: ["sh", "-c", "for z in /sys/class/thermal/thermal_zone*; do printf '%s %s\\n' \"$(cat \"$z/type\")\" \"$(cat \"$z/temp\")\"; done"]
    interval: 2000
    onLine: data => {
      var p = data.trim().split(" ")
      var type = p[0]
      var v = parseInt(p[1])
      if (isNaN(v))
        return
      var c = Math.round(v / 1000)
      if (type === "x86_pkg_temp") {
        temp.pkg = c
        temp.text = c + "°C"
      }
    }
  }

  property var barWindow: null

  onClicked: pop.toggle()

  TempPopup {
    id: pop
    triggerItem: temp
    barWindow: temp.barWindow
  }
}
