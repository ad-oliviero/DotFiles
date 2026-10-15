import QtQuick

import "components"
import "Style"

// §4.1 network: Wi-Fi icon + active connection name (nmcli, 5 s).
// No wifi card → hidden unless ethernet is up, then shown with the ethernet icon.
Pill {
  id: net
  icon: "󰤭" // disconnected
  text: ""
  visible: false                  // ponytail: shown once the poll finds wifi card or ethernet

  property string name: ""
  property bool _found: false
  property bool _wifiCard: false
  property string _eth: ""

  Poll {
    command: ["sh", "-c", "nmcli -t -f TYPE device status | grep -q wifi && echo wificard=yes || echo wificard=no; nmcli -t -f NAME,TYPE,DEVICE connection show --active"]
    interval: 5000
    onLine: data => {
      var eq = data.indexOf("=")
      if (eq >= 0 && data.substring(0, eq) === "wificard") {
        net._wifiCard = data.substring(eq + 1) === "yes"
        return
      }
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
      } else if (type.indexOf("ethernet") >= 0) {
        net._eth = p[p.length - 1] // interface name (DEVICE), not connection name
      }
    }
    onFinished: () => {
      if (net._wifiCard) {
        net.visible = true
        if (!net._found) {
          net.name = ""
          net.icon = "󰤭"
          net.text = ""
        }
      } else if (net._eth !== "") {
        net.visible = true
        net.name = net._eth
        net.icon = "󰈀" // ethernet
        net.text = net._eth
      } else {
        net.visible = false
      }
      net._found = false
      net._eth = ""
    }
  }

  property var barWindow: null

  onClicked: pop.toggle()
  onHoverActivated: pop.open()
  popupId: "net"

  NetPopup {
    id: pop
    popupId: "net"
    triggerItem: net
    barWindow: net.barWindow
    wifiCard: net._wifiCard
  }
}
