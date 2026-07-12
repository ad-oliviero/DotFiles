import QtQuick
import Quickshell

import "components"
import "Style"

// §1.3 center clock pill, 1 s precision, 12-hour with seconds + AM/PM.
// Click opens the calendar popup.
Pill {
  id: clock
  state: "normal"
  text: Qt.formatDateTime(clk.date, "ddd d MMM yyyy, h:mm:ss AP")

  SystemClock {
    id: clk
    precision: SystemClock.Seconds
  }

  property var barWindow: null

  onClicked: pop.toggle()

  CalendarPopup {
    id: pop
    triggerItem: clock
    barWindow: clock.barWindow
  }
}
