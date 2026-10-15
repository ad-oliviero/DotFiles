import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io

import "components"
import "Style"

// §5.6 Temperature popup: graph OR list view (toggle). Multi-zone, auto-scaled.
Popup {
  id: root
  title: "Temperatures"
  popupWidth: 460
  popupHeight: 480

  // small check box used in the per-sensor rows below
  component Cb: Rectangle {
    id: cb
    property bool checked: false
    signal toggled()
    width: 22
    height: 22
    radius: 4
    color: cb.checked ? Style.color.orange : Qt.alpha(Style.color.fg, 0.12)
    Text {
      anchors.centerIn: parent
      visible: cb.checked
      text: "✓"
      color: Style.color.bg
      font {
        family: Style.font.family
        pixelSize: 14
        bold: true
      }
    }
    MouseArea {
      anchors.fill: parent
      onClicked: cb.toggled()
    }
  }

  property var zones: ({})
  property string viewMode: "graph"
  // persisted settings (graph exclusions + bar sensor), stored as JSON strings
  FileView {
    id: settings
    path: "file://" + (Quickshell.env("XDG_STATE_HOME") || Quickshell.env("HOME") + "/.local/state") + "/quickshell/temp-settings.json"
    adapter: JsonAdapter {
      id: settingsAdapter
      property string graphHidden: "{}"
      property string barSensor: ""
    }
  }

  // ponytail: map held as a JSON string since JsonAdapter can't round-trip a var
  readonly property var graphHidden: {
    try {
      return JSON.parse(settingsAdapter.graphHidden)
    } catch (e) {
      return {}
    }
  }
  readonly property string barSensor: settingsAdapter.barSensor

  function setGraphHidden(type, hidden) {
    var h = {}
    for (var k in root.graphHidden)
      h[k] = true
    if (hidden)
      h[type] = true
    else
      delete h[type]
    settingsAdapter.graphHidden = JSON.stringify(h)
    settings.writeAdapter()
  }

  readonly property int barValue: {
    var arr = root.zones[root.barSensor]
    return arr && arr.length > 0 ? arr[arr.length - 1] : -1
  }
  readonly property string barText: root.barValue < 0 ? "" : root.barValue + "°C"

  readonly property var _palette: [Style.color.orange, Style.color.green, Style.color.yellow, Style.color.red]

  readonly property var _series: {
    var out = []
    var i = 0
    for (var k in root.zones) {
      if (root.graphHidden[k])
        continue
      out.push({
          label: k,
          color: root._palette[i % root._palette.length],
          values: root.zones[k]
        })
      i++
    }
    return out
  }

  // flat list of { type, current } for list view
  readonly property var _zoneList: {
    var out = []
    for (var k in root.zones) {
      var arr = root.zones[k]
      out.push({
          type: k,
          current: arr.length > 0 ? arr[arr.length - 1] : 0
        })
    }
    out.sort((a, b) => b.current - a.current)
    return out
  }

  Poll {
    active: true // graph keeps filling in the background
    command: ["sh", "-c", "seen=''; for f in /sys/class/hwmon/hwmon*/temp*_input; do [ -e \"$f\" ] || continue; d=$(dirname \"$f\"); n=$(cat \"$d/name\"); l=$(cat \"${f%_input}_label\" 2>/dev/null); [ -n \"$l\" ] || l=$(basename \"$f\" _input); k=\"${n}_${l}\"; case \" $seen \" in *\" $k \"*) continue;; esac; seen=\"$seen $k\"; printf '%s %s\\n' \"$k\" \"$(cat \"$f\")\"; done"]
    interval: root.visible ? 200 : 2000
    onLine: data => {
      var p = data.trim().split(" ")
      var type = p[0]
      var v = parseInt(p[1])
      if (isNaN(v))
        return
      var c = Math.round(v / 1000)
      var z = {}
      for (var k in root.zones)
        z[k] = root.zones[k].slice()
      var arr = z[type] || []
      arr.push(c)
      if (arr.length > 300) // ponytail: cap = 60 s window at the 200 ms open rate
        arr.shift()
      z[type] = arr
      root.zones = z
    }
  }

  actions: RowLayout {
    width: parent.width
    spacing: 8

    Rectangle {
      Layout.fillWidth: true
      Layout.preferredHeight: 30
      radius: Style.size.popupRadius
      color: viewMa.pressed ? Qt.darker(Style.color.orange, 1.25) : (root.viewMode === "graph" ? Style.color.orange : Qt.alpha(Style.color.fg, 0.12))
      Behavior on color {
        ColorAnimation {
          duration: Style.anim.colorMs
        }
      }
      Text {
        anchors.centerIn: parent
        text: root.viewMode === "graph" ? "Switch to List" : "Switch to Graph"
        color: root.viewMode === "graph" ? Style.color.bg : Style.color.fg
        font {
          family: Style.font.family
          pixelSize: Style.size.textSize
          bold: true
        }
      }
      MouseArea {
        id: viewMa
        anchors.fill: parent
        onClicked: root.viewMode = root.viewMode === "graph" ? "list" : "graph"
      }
    }
  }

  content: ColumnLayout {
    width: parent.width
    spacing: 4

    // bar sensor dropdown (top of content so expanded options stay in view)
    Rectangle {
      id: barSel
      property bool expanded: false
      Layout.fillWidth: true
      Layout.preferredHeight: 30
      radius: Style.size.popupRadius
      color: Qt.alpha(Style.color.fg, 0.12)
      Text {
        anchors.centerIn: parent
        text: "Bar sensor: " + (root.barSensor === "" ? "none" : root.barSensor)
        color: Style.color.fg
        font: Style.textFont()
      }
      MouseArea {
        anchors.fill: parent
        onClicked: barSel.expanded = !barSel.expanded
      }
    }
    Repeater {
      model: barSel.expanded ? root._zoneList : []
      delegate: Rectangle {
        id: opt
        required property var modelData
        Layout.fillWidth: true
        Layout.preferredHeight: 26
        radius: 6
        color: optMa.containsMouse ? Qt.alpha(Style.color.fg, 0.1) : "transparent"
        Text {
          anchors.centerIn: parent
          text: opt.modelData.type
          color: root.barSensor === opt.modelData.type ? Style.color.orange : Style.color.fg
          font: Style.textFont()
        }
        MouseArea {
          id: optMa
          hoverEnabled: true
          anchors.fill: parent
          onClicked: {
            settingsAdapter.barSensor = opt.modelData.type
            settings.writeAdapter()
            barSel.expanded = false
          }
        }
      }
    }

    Graph {
      visible: root.viewMode === "graph"
      maxSamples: root.visible ? 300 : 30 // more samples when open = same time window, same scroll speed
      series: root._series
    }

    Repeater {
      model: root.viewMode === "list" ? root._zoneList : []
      delegate: RowLayout {
        Layout.fillWidth: true
        spacing: 8

        required property var modelData
        readonly property bool hot: modelData.current > 80
        readonly property bool warm: modelData.current > 60

        Text {
          Layout.fillWidth: true
          color: Style.color.fg
          text: modelData.type
          elide: Text.ElideRight
          font {
            family: Style.font.family
            pixelSize: Style.size.textSize
          }
        }
        Text {
          color: parent.hot ? Style.color.red : (parent.warm ? Style.color.yellow : Style.color.fg)
          text: modelData.current + "°C"
          font {
            family: Style.font.family
            pixelSize: Style.size.textSize
            bold: true
          }
        }
      }
    }

    // per-sensor checkboxes: include in graph / show on the bar
    Repeater {
      model: root._zoneList
      delegate: RowLayout {
        required property var modelData
        Layout.fillWidth: true
        spacing: 6

        Text {
          Layout.fillWidth: true
          color: Style.color.dim
          text: modelData.type
          elide: Text.ElideRight
          font {
            family: Style.font.family
            pixelSize: Style.size.textSize
          }
        }
        Cb {
          checked: !root.graphHidden[modelData.type]
          onToggled: root.setGraphHidden(modelData.type, checked)
        }
        Text {
          color: Style.color.dim
          text: "graph"
          font {
            family: Style.font.family
            pixelSize: Style.size.graphText
          }
        }
      }
    }
  }
}
