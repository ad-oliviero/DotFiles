import QtQuick
import QtQuick.Layouts

import "components"
import "Style"

// Calendar popup: current month with today highlighted, prev/next navigation.
Popup {
  id: root
  title: "Calendar"
  popupWidth: 340
  popupHeight: 400

  // viewed month stored as a Date (day = 1)
  property var viewDate: {
    var now = new Date()
    return new Date(now.getFullYear(), now.getMonth(), 1)
  }

  readonly property int viewYear: viewDate.getFullYear()
  readonly property int viewMonth: viewDate.getMonth()
  readonly property string monthLabel: Qt.formatDateTime(viewDate, "MMMM yyyy")

  readonly property var _weekdays: ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]

  // flat grid of cells for the month (Mon-first), padded to whole weeks
  readonly property var _grid: {
    var first = new Date(root.viewYear, root.viewMonth, 1)
    var firstWeekday = (first.getDay() + 6) % 7 // Mon=0 .. Sun=6
    var daysInMonth = new Date(root.viewYear, root.viewMonth + 1, 0).getDate()
    var today = new Date()
    var isThisMonth = today.getFullYear() === root.viewYear && today.getMonth() === root.viewMonth
    var cells = []
    for (var i = 0; i < firstWeekday; i++)
      cells.push({
          day: 0,
          today: false
        })
    for (var d = 1; d <= daysInMonth; d++)
      cells.push({
          day: d,
          today: isThisMonth && d === today.getDate()
        })
    while (cells.length % 7 !== 0)
      cells.push({
          day: 0,
          today: false
        })
    return cells
  }

  function prevMonth() {
    root.viewDate = new Date(root.viewYear, root.viewMonth - 1, 1)
  }
  function nextMonth() {
    root.viewDate = new Date(root.viewYear, root.viewMonth + 1, 1)
  }

  content: ColumnLayout {
    width: parent.width
    spacing: 8

    // month header + navigation
    RowLayout {
      Layout.fillWidth: true
      spacing: 8

      Rectangle {
        width: 30
        height: 30
        radius: Style.size.popupRadius
        color: prevMa.pressed ? Qt.alpha(Style.color.fg, 0.25) : Qt.alpha(Style.color.fg, 0.12)
        Text {
          anchors.centerIn: parent
          text: "‹"
          color: Style.color.fg
          font {
            family: Style.font.family
            pixelSize: Style.size.textSize
            bold: true
          }
        }
        MouseArea {
          id: prevMa
          anchors.fill: parent
          onClicked: root.prevMonth()
        }
      }

      Text {
        Layout.fillWidth: true
        horizontalAlignment: Text.AlignHCenter
        text: root.monthLabel
        color: Style.color.fg
        font {
          family: Style.font.family
          pixelSize: Style.size.textSize
          bold: true
        }
      }

      Rectangle {
        width: 30
        height: 30
        radius: Style.size.popupRadius
        color: nextMa.pressed ? Qt.alpha(Style.color.fg, 0.25) : Qt.alpha(Style.color.fg, 0.12)
        Text {
          anchors.centerIn: parent
          text: "›"
          color: Style.color.fg
          font {
            family: Style.font.family
            pixelSize: Style.size.textSize
            bold: true
          }
        }
        MouseArea {
          id: nextMa
          anchors.fill: parent
          onClicked: root.nextMonth()
        }
      }
    }

    // weekday header row
    RowLayout {
      Layout.fillWidth: true
      spacing: 2
      Repeater {
        model: root._weekdays
        delegate: Text {
          required property string modelData
          Layout.fillWidth: true
          horizontalAlignment: Text.AlignHCenter
          text: modelData
          color: Style.color.dim
          font {
            family: Style.font.family
            pixelSize: Style.size.graphText
            bold: true
          }
        }
      }
    }

    // day grid
    GridView {
      id: grid
      Layout.fillWidth: true
      Layout.preferredHeight: 6 * 38
      cellWidth: Math.floor(grid.width / 7)
      cellHeight: 38
      interactive: false
      model: root._grid

      delegate: Rectangle {
        required property var modelData
        width: grid.cellWidth - 2
        height: grid.cellHeight - 2
        radius: 8
        color: modelData.today ? Style.color.orange : "transparent"
        visible: modelData.day !== 0
        Text {
          anchors.centerIn: parent
          text: modelData.day || ""
          color: modelData.today ? Style.color.bg : Style.color.fg
          font {
            family: Style.font.family
            pixelSize: Style.size.textSize
          }
        }
      }
    }
  }
}
