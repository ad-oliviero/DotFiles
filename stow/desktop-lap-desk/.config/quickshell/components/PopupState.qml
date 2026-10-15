pragma Singleton
import QtQuick

// Tracks which popup is currently open (by id), so hovering another pill can
// switch popups without clicking.
QtObject {
  property string openId: ""
}
