import QtQuick

import "components"
import "Style"

// §4.1 network: Wi-Fi icon + active connection name (nmcli, 5 s).
Pill {
  id: net
  icon: "󰤭" // disconnected
  text: ""

  property string name: ""
  property bool _found: false

  Poll {
    command: ["nmcli", "-t", "-f", "NAME,TYPE,DEVICE", "connection", "show", "--active"]
    interval: 5000
    onLine: data => {
      var p = data.split(":")
      if (p.length < 3)
        return
      var type = p[p.length - 2]
      var name = p.slice(0, p.length - 2).join(":")
      if (type.indexOf("wireless") >= 0) {
        net.name = name
        net.icon = "󰤨"
        net.text = name
        net._found = true
      }
    }
    onFinished: () => {
      if (!net._found) {
        net.name = ""
        net.icon = "󰤭"
        net.text = ""
      }
      net._found = false
    }
  }

  property var barWindow: null

  onClicked: pop.toggle()

  NetPopup {
    id: pop
    triggerItem: net
    barWindow: net.barWindow
  }
}
