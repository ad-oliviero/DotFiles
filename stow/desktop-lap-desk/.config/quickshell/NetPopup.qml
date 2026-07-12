import QtQuick
import QtQuick.Layouts
import Quickshell.Io

import "components"
import "Style"

// §5.2 Wi-Fi popup: scan list (sorted by signal, deduped), Rescan + Turn Off/On.
Popup {
  id: root
  title: "Wi-Fi Networks"
  popupWidth: 360
  popupHeight: 460

  property var networks: [] // [{ ssid, signal, active }]
  property bool radioOn: true
  property bool scanning: false
  property var _lines: []

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
    active: root.visible
    command: ["nmcli", "radio", "wifi"]
    interval: 5000
    onLine: d => root.radioOn = d.trim() === "enabled"
  }

  // wifi list (only meaningful when the radio is on)
  Poll {
    active: root.visible && root.radioOn
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

    Text {
      Layout.fillWidth: true
      visible: !root.scanning
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
      model: root.radioOn ? root.networks : []
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
