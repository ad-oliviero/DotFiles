import QtQuick
import QtQuick.Layouts
import Quickshell.Io

import "components"
import "Style"

// §5.2 network popup: Wi-Fi scan list (sorted by signal, deduped), Rescan +
// Turn Off/On. Without a wifi card: ethernet panel (interface, IP, toggle).
Popup {
  id: root
  title: wifiCard ? "Wi-Fi Networks" : "Ethernet"
  property bool wifiCard: true
  property var ethDevs: [] // [{ dev, state, ip }]
  popupWidth: 360
  popupHeight: 460

  property var networks: [] // [{ ssid, signal, active }]
  property bool radioOn: true
  property bool scanning: false
  property var _lines: []

  // ethernet throughput history (KiB/s), sampled only while open
  property var rxHist: []
  property var txHist: []
  // ponytail: real, not int — QML ints are 32-bit and byte counters overflow
  property real lastRx: 0
  property real lastTx: 0
  property real lastMs: 0

  function speedStr(kibs) {
    return kibs >= 1024 ? (kibs / 1024).toFixed(1) + " MiB/s" : kibs + " KiB/s"
  }

  Poll {
    active: !root.wifiCard // graph keeps filling in the background
    interval: root.visible ? 200 : 1000
    command: ["sh", "-c", "awk 'NR>2 { sub(\":\",\"\",$1); if ($1 != \"lo\") { rx += $2; tx += $10 } } END { print rx, tx }' /proc/net/dev"]
    onLine: d => {
      var p = d.trim().split(/\s+/)
      if (p.length < 2)
        return
      var rx = parseInt(p[0]) || 0
      var tx = parseInt(p[1]) || 0
      var now = Date.now()
      var dt = now - root.lastMs // rate scaled by real elapsed ms (200 ms open, 1 s background)
      if (root.lastRx > 0 && dt > 0) {
        var rh = root.rxHist.slice()
        rh.push(Math.max(0, Math.round((rx - root.lastRx) / 1024 * 1000 / dt)))
        if (rh.length > 300) // ponytail: cap = 60 s window at the 200 ms open rate
          rh.shift()
        root.rxHist = rh
        var th = root.txHist.slice()
        th.push(Math.max(0, Math.round((tx - root.lastTx) / 1024 * 1000 / dt)))
        if (th.length > 300) // ponytail: cap = 60 s window at the 200 ms open rate
          th.shift()
        root.txHist = th
      }
      root.lastRx = rx
      root.lastTx = tx
      root.lastMs = now
    }
  }

  // ethernet devices (only polled when there is no wifi card)
  Poll {
    active: root.visible && !root.wifiCard
    interval: 5000
    command: ["sh", "-c", "nmcli -t -f DEVICE,TYPE,STATE device status | grep ':ethernet:' | grep -v unmanaged | while IFS=: read -r d t s; do ip=''; case \"$s\" in connected*) ip=$(nmcli -t -f IP4.ADDRESS device show \"$d\" | head -1 | cut -d: -f2-);; esac; echo \"$d|$s|$ip\"; done"]
    onLine: d => root._lines.push(d)
    onFinished: () => {
      var arr = []
      for (var i = 0; i < root._lines.length; i++) {
        var p = root._lines[i].split("|")
        if (p.length < 3 || p[0] === "")
          continue
        arr.push({ dev: p[0], state: p[1], ip: p[2] })
      }
      root.ethDevs = arr
      root._lines = []
    }
  }

  Process {
    id: run
    running: false
    command: []
  }
  function runCmd(cmd) {
    run.command = cmd
    run.running = true
  }

  // radio state
  Poll {
    active: root.visible && root.wifiCard
    command: ["nmcli", "radio", "wifi"]
    interval: 5000
    onLine: d => root.radioOn = d.trim() === "enabled"
  }

  // wifi list (only meaningful when the radio is on)
  Poll {
    active: root.visible && root.wifiCard && root.radioOn
    command: ["nmcli", "-t", "-f", "SSID,SIGNAL,IN-USE", "device", "wifi", "list", "--rescan", "no"]
    interval: 5000
    onLine: d => root._lines.push(d)
    onFinished: () => {
      var best = ({})
      for (var i = 0; i < root._lines.length; i++) {
        var p = root._lines[i].split(":")
        if (p.length < 3)
          continue
        var inuse = p[p.length - 1]
        var signal = parseInt(p[p.length - 2])
        var ssid = p.slice(0, p.length - 2).join(":").replace(/\\:/g, ":")
        if (ssid === "" || ssid === "--" || isNaN(signal))
          continue
        if (!best[ssid] || signal > best[ssid].signal)
          best[ssid] = {
            signal: signal,
            active: inuse.indexOf("*") >= 0
          }
      }
      var arr = []
      for (var k in best)
        arr.push({
            ssid: k,
            signal: best[k].signal,
            active: best[k].active
          })
      arr.sort((a, b) => b.signal - a.signal)
      root.networks = arr
      root._lines = []
    }
  }

  Timer {
    id: rescanTimer
    interval: 3000
    onTriggered: root.scanning = false
  }

  function rescan() {
    root.runCmd(["nmcli", "device", "wifi", "rescan"])
    root.scanning = true
    rescanTimer.start()
  }
  function toggleRadio() {
    root.runCmd(["nmcli", "radio", "wifi", root.radioOn ? "off" : "on"])
  }
  function connectEth(dev) {
    root.runCmd(["nmcli", "device", "connect", dev])
  }
  function disconnectEth(dev) {
    root.runCmd(["nmcli", "device", "disconnect", dev])
  }
  function connect(ssid) {
    root.close()
    root.runCmd(["nmcli", "device", "wifi", "connect", ssid])
  }

  function signalIcon(s) {
    if (s >= 80)
      return "󰤨"
    if (s >= 60)
      return "󰤥"
    if (s >= 40)
      return "󰤢"
    return "󰤟"
  }

  actions: RowLayout {
    width: parent.width
    visible: root.wifiCard
    spacing: 8

    Rectangle {
      Layout.fillWidth: true
      Layout.preferredHeight: 30
      radius: Style.size.popupRadius
      color: rescanMa.pressed ? Qt.darker(Style.color.orange, 1.25) : Style.color.orange
      Text {
        anchors.centerIn: parent
        text: "Rescan"
        color: Style.color.bg
        font {
          family: Style.font.family
          pixelSize: Style.size.textSize
          bold: true
        }
      }
      MouseArea {
        id: rescanMa
        anchors.fill: parent
        onClicked: root.rescan()
      }
    }

    Rectangle {
      Layout.fillWidth: true
      Layout.preferredHeight: 30
      radius: Style.size.popupRadius
      color: radioMa.pressed ? Qt.darker(Style.color.red, 1.25) : Style.color.red
      Text {
        anchors.centerIn: parent
        text: root.radioOn ? "Turn Off" : "Turn On"
        color: Style.color.bg
        font {
          family: Style.font.family
          pixelSize: Style.size.textSize
          bold: true
        }
      }
      MouseArea {
        id: radioMa
        anchors.fill: parent
        onClicked: root.toggleRadio()
      }
    }
  }

  content: ColumnLayout {
    width: parent.width
    spacing: 4

    // ethernet panel (no wifi card): one row per ethernet interface + toggle
    Repeater {
      model: root.wifiCard ? [] : root.ethDevs
      delegate: ColumnLayout {
        required property var modelData
        readonly property bool up: modelData.state.indexOf("connected") === 0
        Layout.fillWidth: true
        spacing: 8

        Rectangle {
          Layout.fillWidth: true
          Layout.preferredHeight: 30
          radius: Style.size.popupRadius
          color: ethMa.pressed ? Qt.darker(up ? Style.color.red : Style.color.green, 1.25) : (up ? Style.color.red : Style.color.green)
          Text {
            anchors.centerIn: parent
            text: up ? "Disconnect" : "Connect"
            color: Style.color.bg
            font {
              family: Style.font.family
              pixelSize: Style.size.textSize
              bold: true
            }
          }
          MouseArea {
            id: ethMa
            anchors.fill: parent
            onClicked: up ? root.disconnectEth(modelData.dev) : root.connectEth(modelData.dev)
          }
        }

        Text {
          Layout.fillWidth: true
          color: up ? Style.color.green : Style.color.dim
          text: up ? ((modelData.ip !== "" ? modelData.ip + " — " : "") + modelData.dev) : "Not connected"
          font {
            family: Style.font.family
            pixelSize: Style.size.textSize
          }
        }

        Graph {
          visible: up
          maxSamples: root.visible ? 300 : 60 // more samples when open = same time window, same scroll speed
          yCeilStep: 1024
          series: [{
              label: "Down " + root.speedStr(root.rxHist.length ? root.rxHist[root.rxHist.length - 1] : 0),
              color: Style.color.green,
              values: root.rxHist
            }, {
              label: "Up " + root.speedStr(root.txHist.length ? root.txHist[root.txHist.length - 1] : 0),
              color: Style.color.orange,
              values: root.txHist
            }]
        }
      }
    }

    Text {
      Layout.fillWidth: true
      visible: root.wifiCard && !root.scanning
      color: Style.color.green
      text: {
        if (!root.radioOn)
          return "Radio off"
        var active = null
        for (var i = 0; i < root.networks.length; i++)
          if (root.networks[i].active)
            active = root.networks[i].ssid
        return active || "Not connected"
      }
      font {
        family: Style.font.family
        pixelSize: Style.size.textSize
      }
    }
    Text {
      Layout.fillWidth: true
      visible: root.scanning
      color: Style.color.green
      text: "Scanning…"
      font {
        family: Style.font.family
        pixelSize: Style.size.textSize
      }
    }

    Repeater {
      model: root.wifiCard && root.radioOn ? root.networks : []
      delegate: Rectangle {
        required property var modelData
        Layout.fillWidth: true
        height: 32
        radius: 8
        color: entryMa.containsMouse ? Qt.alpha(Style.color.fg, 0.1) : "transparent"
        RowLayout {
          anchors.fill: parent
          anchors.leftMargin: 8
          anchors.rightMargin: 8
          spacing: 8
          Text {
            text: root.signalIcon(modelData.signal)
            color: modelData.active ? Style.color.green : (modelData.signal < 30 ? Style.color.dim : Style.color.fg)
            font {
              family: Style.font.family
              pixelSize: Style.size.textSize
            }
          }
          Text {
            Layout.fillWidth: true
            text: modelData.ssid
            color: Style.color.fg
            elide: Text.ElideRight
            font {
              family: Style.font.family
              pixelSize: Style.size.textSize
            }
          }
          Text {
            text: modelData.signal + "%"
            color: Style.color.fg
            font {
              family: Style.font.family
              pixelSize: Style.size.textSize
            }
          }
        }
        MouseArea {
          id: entryMa
          anchors.fill: parent
          hoverEnabled: true
          onClicked: root.connect(modelData.ssid)
        }
      }
    }
  }
}
