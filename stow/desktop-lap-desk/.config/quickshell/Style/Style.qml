pragma Singleton
import QtQuick
import Quickshell

Singleton {
  id: root

  // eww theme palette (exact hex match).
  property var color: Scope {
    property var bgt: "#0A0E1400" // transparent bar base
    property var bg: "#0A0E14" // eww $bg
    property var fg: "#B3B1AD" // eww $fg
    property var orange: "#FF8F40" // active
    property var yellow: "#D5FF80" // warning
    property var red: "#D95757" // critical
    property var green: "#86B300" // charging / positive
    property var pill: "rgba(60, 56, 54, 0.8)" // eww label bg
    property var popup: "rgba(60, 56, 54, 0.9)" // eww tooltip bg
    property var dim: "#6B6965" // fg at ~0.38 luminance
  }

  // sizing
  property var size: Scope {
    property int barHeight: 45
    property int barMargin: 10
    property int pillRadius: 32
    property int popupRadius: 12
    property int textSize: 17
    property int graphText: 10
  }

  // typography
  property var font: Scope {
    property var family: "JetBrains Mono"
    property var icons: "JetBrainsMono Nerd Font"
  }

  // animations
  property var anim: Scope {
    property int colorMs: 300
    property int revealMs: 200
  }

  // conditional coloring: returns { bg, fg } for a semantic state
  function colorFor(state) {
    switch (state) {
      case "active": return { bg: root.color.orange, fg: root.color.bg }
      case "warning": return { bg: root.color.yellow, fg: root.color.bg }
      case "critical": return { bg: root.color.red, fg: root.color.bg }
      case "charging": return { bg: root.color.green, fg: root.color.bg }
      default: return { bg: root.color.pill, fg: root.color.fg }
    }
  }

  // shared stat-text font for popups
  function textFont() {
    return {
      family: root.font.family,
      pixelSize: root.size.textSize
    }
  }
}
