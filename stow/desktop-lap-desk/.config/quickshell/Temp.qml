import QtQuick

import "components"
import "Style"

// §4.5 temperature: selected sensor on the bar (picked in the popup),
// warning >60 C, critical >80 C. The popup polls continuously, so the pill
// just reads from it — no poll of its own.
Pill {
  id: temp
  icon: "󰔏"
  iconTrailing: true
  text: pop.barText
  state: pop.barValue > 80 ? "critical" : pop.barValue > 60 ? "warning" : "normal"

  property var barWindow: null

  onClicked: pop.toggle()
  onHoverActivated: pop.open()
  popupId: "temp"

  TempPopup {
    id: pop
    popupId: "temp"
    triggerItem: temp
    barWindow: temp.barWindow
  }
}
