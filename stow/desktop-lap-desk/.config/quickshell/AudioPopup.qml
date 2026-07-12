import QtQuick
import QtQuick.Layouts
import Quickshell.Io

import "components"
import "Style"

// §5.3 Audio popup: sinks (output, green) and sources (input, yellow) with
// per-device volume sliders and mute toggles. Refreshes 400 ms after a change.
Popup {
  id: root
  title: "Audio"
  popupWidth: 380
  popupHeight: 460

  property var sinks: []
  property var sources: []
  property bool showAllSinks: false
  property bool showAllSources: false

  readonly property var activeSinks: root.sinks.filter(s => s.isDefault).concat(root.sinks.filter(s => !s.isDefault)).slice(0, root.showAllSinks ? root.sinks.length : Math.min(1, root.sinks.length))
  readonly property var activeSources: root.sources.filter(s => s.isDefault).concat(root.sources.filter(s => !s.isDefault)).slice(0, root.showAllSources ? root.sources.length : Math.min(1, root.sources.length))
  readonly property bool hasExtraSinks: root.sinks.length > 1
  readonly property bool hasExtraSources: root.sources.length > 1

  Process {
    id: statusProc
    command: ["wpctl", "status"]
    running: false
    property var _sinks: []
    property var _sources: []
    property string _section: ""
    stdout: SplitParser {
      onRead: raw => {
        // Strip box-drawing tree prefix (U+2500–U+257F) + leading whitespace
        var line = raw.replace(/^[\s\u2500-\u257F]+/, "")
        if (line.indexOf("Sinks:") >= 0) {
          statusProc._section = "sink"
          return
        }
        if (line.indexOf("Sources:") >= 0) {
          statusProc._section = "source"
          return
        }
        if (line.indexOf("Devices:") >= 0 || line.indexOf("Filters:") >= 0 || line.indexOf("Clients:") >= 0) {
          statusProc._section = ""
          return
        }
        var m = line.match(/(\*?)\s*(\d+)\.\s+(.+?)\s*\[vol:\s*([\d.]+)([^\]]*)\]/)
        if (!m)
          return
        var entry = {
          id: m[2],
          desc: m[3].trim(),
          vol: parseFloat(m[4]),
          muted: m[5].indexOf("MUTED") >= 0,
          isDefault: m[1] === "*"
        }
        if (statusProc._section === "sink")
          statusProc._sinks.push(entry)
        else if (statusProc._section === "source")
          statusProc._sources.push(entry)
      }
    }
    onExited: {
      // default first
      statusProc._sinks.sort((a, b) => (b.isDefault ? 1 : 0) - (a.isDefault ? 1 : 0))
      statusProc._sources.sort((a, b) => (b.isDefault ? 1 : 0) - (a.isDefault ? 1 : 0))
      root.sinks = statusProc._sinks
      root.sources = statusProc._sources
      statusProc._sinks = []
      statusProc._sources = []
    }
  }

  // periodic refresh while open
  Timer {
    interval: 3000
    running: root.visible
    repeat: true
    triggeredOnStart: true
    onTriggered: statusProc.running = true
  }
  // §5.3 400 ms refresh after a change
  Timer {
    id: afterChange
    interval: 400
    onTriggered: statusProc.running = true
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
  function setVol(id, v) {
    // ponytail: wpctl needs two calls, combine in shell to avoid runCmd race
    root.runCmd(["sh", "-c", "wpctl set-volume " + id + " " + v.toFixed(3) + "; wpctl set-mute " + id + " 0"])
    afterChange.restart()
  }
  function toggleMute(id) {
    root.runCmd(["wpctl", "set-mute", id, "toggle"])
    afterChange.restart()
  }

  content: ColumnLayout {
    width: parent.width
    spacing: 10

    Text {
      Layout.fillWidth: true
      color: Style.color.orange
      text: "Output"
      font {
        family: Style.font.family
        pixelSize: Style.size.textSize
        bold: true
      }
    }
    Repeater {
      model: root.activeSinks
      delegate: AudioDevice {
        Layout.fillWidth: true
        device: modelData
        fillColor: Style.color.green
        isSource: false
        onVolumeChanged: root.setVol(devId, v)
        onMuteToggled: root.toggleMute(devId)
      }
    }

    Rectangle {
      Layout.fillWidth: true
      height: root.hasExtraSinks ? 30 : 0
      visible: root.hasExtraSinks
      radius: Style.size.popupRadius
      color: moreSinksMa.pressed ? Qt.alpha(Style.color.fg, 0.25) : Qt.alpha(Style.color.fg, 0.12)
      Text {
        anchors.centerIn: parent
        color: Style.color.fg
        text: root.showAllSinks ? "▲ Collapse" : "▼ " + (root.sinks.length - 1) + " more output" + (root.sinks.length - 1 > 1 ? "s" : "")
        font { family: Style.font.family; pixelSize: Style.size.textSize }
      }
      MouseArea {
        id: moreSinksMa
        anchors.fill: parent
        onClicked: root.showAllSinks = !root.showAllSinks
      }
    }

    Text {
      Layout.fillWidth: true
      color: Style.color.yellow
      text: "Input"
      font {
        family: Style.font.family
        pixelSize: Style.size.textSize
        bold: true
      }
    }
    Repeater {
      model: root.activeSources
      delegate: AudioDevice {
        Layout.fillWidth: true
        device: modelData
        fillColor: Style.color.yellow
        isSource: true
        onVolumeChanged: root.setVol(devId, v)
        onMuteToggled: root.toggleMute(devId)
      }
    }

    Rectangle {
      Layout.fillWidth: true
      height: root.hasExtraSources ? 30 : 0
      visible: root.hasExtraSources
      radius: Style.size.popupRadius
      color: moreSourcesMa.pressed ? Qt.alpha(Style.color.fg, 0.25) : Qt.alpha(Style.color.fg, 0.12)
      Text {
        anchors.centerIn: parent
        color: Style.color.fg
        text: root.showAllSources ? "▲ Collapse" : "▼ " + (root.sources.length - 1) + " more input" + (root.sources.length - 1 > 1 ? "s" : "")
        font { family: Style.font.family; pixelSize: Style.size.textSize }
      }
      MouseArea {
        id: moreSourcesMa
        anchors.fill: parent
        onClicked: root.showAllSources = !root.showAllSources
      }
    }
  }
}
