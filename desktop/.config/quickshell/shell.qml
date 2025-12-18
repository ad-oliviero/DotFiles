import QtQuick
import QtQuick.Layouts
import QtQml
import Quickshell

import "Style"

ShellRoot {
  SystemClock {
    id: timeSource
    precision: SystemClock.Seconds
  }
  PanelWindow {
    id: root

    anchors {
      top: true
      left: true
      right: true
    }
    implicitHeight: 45
    color: Style.color.bgt

    RowLayout {
      anchors.fill: parent
      anchors.margins: 8
      WorkSpaces {}
      Text {
        property var formatString: 'ddd d MMM yyyy, h:mm:ss'
        text: Qt.formatDateTime(timeSource.date, formatString)
        anchors.centerIn: parent
        color: Style.color.fg
        font {
          family: Style.fontFamily
          pixelSize: Style.textSize
          bold: true
        }
      }
      Item {
        Layout.fillWidth: true
      }
      Cpu {}
    }
  }
}
