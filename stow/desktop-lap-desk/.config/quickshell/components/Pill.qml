import QtQuick
import QtQuick.Layouts

import "../Style"

// Shared widget pill (§3). Renders an icon + optional text in a rounded
// rectangle whose background/foreground follow a semantic `state`, with a
// 300 ms color transition. Emits `clicked()` (open popup) and `wheel(delta)`.
Item {
  id: pill

  property string icon: ""
  property string text: ""
  property bool iconTrailing: false
  property string state: "normal" // normal|active|warning|critical|charging
  property bool dimmed: false // 35% fg (e.g. muted volume)

  signal clicked()
  signal wheel(int delta)

  readonly property var _c: Style.colorFor(pill.state)
  readonly property color _fg: pill.dimmed ? Qt.alpha(Style.color.fg, 0.35) : pill._c.fg

  implicitWidth: row.implicitWidth + 16
  implicitHeight: Math.max(28, row.implicitHeight + 8)
  width: implicitWidth
  height: implicitHeight

  Rectangle {
    id: bg
    anchors.fill: parent
    radius: Style.size.pillRadius
    color: pill._c.bg
    Behavior on color {
      ColorAnimation {
        duration: Style.anim.colorMs
      }
    }
  }

  RowLayout {
    id: row
    anchors.centerIn: parent
    spacing: pill.icon === "" || pill.text === "" ? 0 : 6

    // 0 = leading icon, 1 = text, 2 = trailing icon. Constant model so the
    // Repeater never rebuilds (e.g. the clock updates its text every second).
    Repeater {
      model: 3
      delegate: Text {
        required property int index
        visible: index === 0 ? (pill.icon !== "" && !pill.iconTrailing) : index === 1 ? (pill.text !== "") : (pill.icon !== "" && pill.iconTrailing)
        text: index === 1 ? pill.text : pill.icon
        color: pill._fg
        font {
          family: Style.font.family
          pixelSize: Style.size.textSize
          bold: true
        }
        Behavior on color {
          ColorAnimation {
            duration: Style.anim.colorMs
          }
        }
      }
    }
  }

  MouseArea {
    anchors.fill: parent
    cursorShape: Qt.PointingHandCursor
    onClicked: pill.clicked()
    onWheel: wheel => pill.wheel(wheel.angleDelta.y)
  }
}
