import QtQuick
import QtQuick.Layouts

import "components"
import "Style"

// §5.6 Temperature popup: graph OR list view (toggle). Multi-zone, auto-scaled.
Popup {
  id: root
  title: "Temperatures"
  popupWidth: 460
  popupHeight: 480

  property var zones: ({})
  property string viewMode: "graph"

  readonly property var _palette: [Style.color.orange, Style.color.green, Style.color.yellow, Style.color.red]

  readonly property var _series: {
    var out = []
    var i = 0
    for (var k in root.zones) {
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
    active: root.visible
    command: ["sh", "-c", "for z in /sys/class/thermal/thermal_zone*; do printf '%s %s\\n' \"$(cat \"$z/type\")\" \"$(cat \"$z/temp\")\"; done"]
    interval: 2000
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
      if (arr.length > 30)
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

    Graph {
      visible: root.viewMode === "graph"
      maxSamples: 30
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
  }
}
