import QtQuick

import "../Style"

// Minimal colored slider (drag/click to set). Used by the Audio popup.
Item {
  id: slider
  property real value: 0
  property real maxValue: 1.5
  property color fillColor: Style.color.green
  signal moved(real v)

  implicitHeight: 8
  implicitWidth: 140
  height: implicitHeight

  Rectangle {
    anchors.fill: parent
    radius: 4
    color: Qt.alpha(Style.color.fg, 0.15)
  }
  Rectangle {
    height: parent.height
    radius: 4
    color: slider.fillColor
    width: parent.width * Math.min(1, slider.value / slider.maxValue)
  }

  MouseArea {
    anchors.fill: parent
    function set(mx) {
      var v = Math.max(0, Math.min(slider.maxValue, mx / slider.width * slider.maxValue))
      slider.value = v
      slider.moved(v)
    }
    onClicked: mouse => set(mouse.x)
    onPressed: mouse => set(mouse.x)
    onPositionChanged: mouse => {
      if (pressed)
        set(mouse.x)
    }
  }
}
