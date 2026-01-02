pragma Singleton
import QtQuick
import Quickshell

Singleton {
  property var color: Scope {
    property var bgt: "#0a0e1400"
    property var bg: "#0a0e14"
    property var fg: "#b3b1ad"
    property var orange: "#ff8f40"
    property var yellow: "#d5ff80"
    property var red: "#d95757"
    property var green: "#86b300"
  }
  property var textSize: 18
  property var fontFamily: "JetBrains Mono"
}
