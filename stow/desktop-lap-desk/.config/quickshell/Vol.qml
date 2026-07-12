import QtQuick

import "components"
import "Style"

// §4.2 volume: default sink volume % or MUTE (wpctl, 3 s).
Pill {
  id: vol
  icon: "󰕾"
  text: "..."

  property int pct: 0
  property bool muted: false
  dimmed: muted

  Poll {
    command: ["wpctl", "get-volume", "@DEFAULT_AUDIO_SINK@"]
    interval: 3000
    onLine: data => {
      var m = data.match(/Volume:\s*([\d.]+)/)
      if (m)
        vol.pct = Math.round(parseFloat(m[1]) * 100)
      vol.muted = data.indexOf("MUTED") >= 0
      vol.icon = vol.muted ? "󰝟" : "󰕾"
      vol.text = vol.muted ? "MUTE" : vol.pct + "%"
    }
  }

  property var barWindow: null

  onClicked: pop.toggle()

  AudioPopup {
    id: pop
    triggerItem: vol
    barWindow: vol.barWindow
  }
}
