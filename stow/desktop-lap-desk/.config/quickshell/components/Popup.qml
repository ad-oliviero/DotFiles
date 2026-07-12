import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland

import "../Style"

// Shared popup panel (§5.1). A layer-shell PanelWindow (not an xdg_popup) so
// the Hyprland `layerrule = blur on, match:namespace quickshell` blurs it like
// the bar, and the HyprlandFocusGrab can track it. Positioned below its pill.
PanelWindow {
  id: popup

  property var triggerItem: null
  property var barWindow: null // the bar PanelWindow (passed from the widget)
  property string title: ""
  property real popupWidth: 320
  property real popupHeight: 420
  property alias content: contentSlot.data
  property alias actions: actionsSlot.data

  // fixed size, top-left anchored, offset via margins (set in open())
  anchors {
    top: true
    left: true
  }
  implicitWidth: popupWidth
  implicitHeight: popupHeight
  focusable: true
  exclusionMode: ExclusionMode.Ignore
  visible: false
  color: "transparent"
  surfaceFormat.opaque: false
  // namespace defaults to "quickshell" -> blurred by the Hyprland layerrule

  HyprlandFocusGrab {
    active: popup.visible
    windows: [popup]
    onCleared: popup.close()
  }

  // §5.1 cascade reveal clip (height 0 -> full). Transparent surface so the
  // compositor blur shows through (matches the bar).
  Item {
    id: revealClip
    anchors {
      left: parent.left
      right: parent.right
      top: parent.top
    }
    height: 0
    clip: true
    focus: true
    Keys.onEscapePressed: popup.close()

    Behavior on height {
      NumberAnimation {
        duration: 300
        easing.type: Easing.OutCubic
      }
    }

    Rectangle {
      id: surface
      anchors {
        left: parent.left
        right: parent.right
        top: parent.top
      }
      height: popupHeight
      radius: Style.size.popupRadius
      color: "transparent"
      clip: true

      ColumnLayout {
        anchors.fill: parent
        anchors.margins: 12
        spacing: 10

        Text {
          Layout.fillWidth: true
          text: popup.title
          color: Style.color.fg
          font {
            family: Style.font.family
            pixelSize: Style.size.textSize
            bold: true
          }
        }

        Flickable {
          Layout.fillWidth: true
          Layout.fillHeight: true
          contentWidth: width
          contentHeight: contentSlot.childrenRect.height
          clip: true
          boundsBehavior: Flickable.StopAtBounds

          Item {
            id: contentSlot
            width: parent.width
            height: childrenRect.height
          }
        }

        Item {
          id: actionsSlot
          Layout.fillWidth: true
          visible: actionsSlot.children.length > 0
          height: actionsSlot.childrenRect.height
        }

        Rectangle {
          Layout.fillWidth: true
          Layout.preferredHeight: 34
          radius: Style.size.popupRadius
          color: closeMa.pressed ? Qt.darker(Style.color.red, 1.25) : Style.color.red
          Behavior on color {
            ColorAnimation {
              duration: Style.anim.colorMs
            }
          }
          Text {
            anchors.centerIn: parent
            text: "Close"
            color: Style.color.bg
            font {
              family: Style.font.family
              pixelSize: Style.size.textSize
              bold: true
            }
          }
          MouseArea {
            id: closeMa
            anchors.fill: parent
            onClicked: popup.close()
          }
        }
      }
    }
  }

  // Position below the trigger pill on the bar's screen. The bar sits at the
  // top with a left margin of Style.size.barMargin, so the pill's screen X is
  // barMargin + its X within the bar window.
  function open() {
    if (barWindow && triggerItem) {
      popup.screen = barWindow.screen
      var rect = barWindow.itemRect(triggerItem)
      var sw = barWindow.screen ? barWindow.screen.width : popupWidth
      var left = Math.round(Style.size.barMargin + rect.x + (rect.width - popupWidth) / 2)
      left = Math.max(4, Math.min(left, sw - popupWidth - 4))
      popup.margins.left = left
      popup.margins.top = barWindow.height || Style.size.barHeight
    }
    visible = true
    revealClip.height = 0
    Qt.callLater(() => {
                  revealClip.height = popupHeight
                  revealClip.forceActiveFocus()
                })
  }
  function close() {
    visible = false
  }
  function toggle() {
    if (visible)
      close()
    else
      open()
  }
}
