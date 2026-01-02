import QtQuick
import QtQml
import Quickshell.Io

import "Style"

Text {
  id: cpu
  property var cpuUsage: 0
  property var lastCpuIdle: 0
  property var lastCpuTotal: 0

  text: "  " + cpuUsage + "%"
  color: Style.color.fg
  font {
    family: Style.fontFamily
    pixelSize: Style.textSize
    bold: true
  }
  Process {
    id: cpuProc
    command: ["head", "-1", "/proc/stat"]
    stdout: SplitParser {
      onRead: data => {
        if (!data) {
          cpu.visible = false;
          return;
        }
        var parts = data.trim().split(/\s+/);
        var user = parseInt(parts[1]) || 0;
        var nice = parseInt(parts[2]) || 0;
        var system = parseInt(parts[3]) || 0;
        var idle = parseInt(parts[4]) || 0;
        var iowait = parseInt(parts[5]) || 0;
        var irq = parseInt(parts[6]) || 0;
        var softirq = parseInt(parts[7]) || 0;

        var total = user + nice + system + idle + iowait + irq + softirq;
        var idleTime = idle + iowait;

        if (cpu.lastCpuTotal > 0) {
          var totalDiff = total - cpu.lastCpuTotal;
          var idleDiff = idleTime - cpu.lastCpuIdle;
          if (totalDiff > 0) {
            cpu.cpuUsage = Math.round(100 * (totalDiff - idleDiff) / totalDiff);
          }
        }
        cpu.lastCpuTotal = total;
        cpu.lastCpuIdle = idleTime;
      }
    }
    Component.onCompleted: running = false
  }
  Timer {
    interval: 1000
    running: true
    repeat: true
    onTriggered: cpuProc.running = true
  }
}
