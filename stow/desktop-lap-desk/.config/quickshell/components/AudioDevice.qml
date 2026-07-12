import QtQuick
import QtQuick.Layouts

import "../Style"

// One audio device row: description (auto-scroll if long), volume slider, mute toggle.
ColumnLayout {
  id: dev

  property var device: ({})
  property color fillColor: Style.color.green
  property bool isSource: false

  signal volumeChanged(string devId, real v)
  signal muteToggled(string devId)

  spacing: 4

  // auto-scrolling device name
  Item {
    Layout.fillWidth: true
    height: nameText.implicitHeight
    clip: true

    property bool overflow: nameText.implicitWidth > width

    Text {
      id: nameText
      color: Style.color.fg
      text: (dev.device.isDefault ? "★ " : "") + dev.device.desc
      font {
        family: Style.font.family
        pixelSize: Style.size.textSize
      }

      SequentialAnimation on x {
        running: parent.overflow
        loops: Animation.Infinite
        PauseAnimation { duration: 1500 }
        NumberAnimation {
          from: 0
          to: -(nameText.implicitWidth - nameText.parent.width)
          duration: Math.max(2000, (nameText.implicitWidth - nameText.parent.width) * 25)
          easing.type: Easing.InOutQuad
        }
        PauseAnimation { duration: 1500 }
        NumberAnimation { to: 0; duration: 400; easing.type: Easing.InOutQuad }
      }
    }
  }

  RowLayout {
    Layout.fillWidth: true
    spacing: 8

    Slider {
      Layout.fillWidth: true
      fillColor: dev.fillColor
      value: dev.device.vol
      onMoved: v => dev.volumeChanged(dev.device.id, v)
    }

    Rectangle {
      width: 34
      height: 34
      radius: Style.size.popupRadius
      color: muteMa.pressed ? Qt.alpha(Style.color.fg, 0.25) : Qt.alpha(Style.color.fg, 0.12)
      Text {
        anchors.centerIn: parent
        color: Style.color.fg
        text: dev.isSource ? (dev.device.muted ? "󰍭" : "󰍰") : (dev.device.muted ? "󰝟" : "󰕾")
        font {
          family: Style.font.family
          pixelSize: Style.size.textSize
        }
      }
      MouseArea {
        id: muteMa
        anchors.fill: parent
        onClicked: dev.muteToggled(dev.device.id)
      }
    }
  }
}
