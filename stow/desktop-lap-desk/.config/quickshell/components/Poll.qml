import QtQuick
import QtQml
import Quickshell.Io

// Generic command poller: runs `command` immediately and then every `interval`
// ms while `active`. Emits one `line(line)` per stdout line and `finished()`
// when the process exits (use the latter to parse multi-line output gathered
// across `line` signals). Mirrors the Process + Timer pattern in Cpu.qml.
Item {
  id: poll

  property var command: []
  property int interval: 1000
  property bool active: true

  signal line(string data)
  signal finished()

  Process {
    id: proc
    command: poll.command
    running: false
    stdout: SplitParser {
      onRead: data => poll.line(data)
    }
    onExited: poll.finished()
  }

  Timer {
    interval: poll.interval
    running: poll.active
    repeat: true
    triggeredOnStart: true
    onTriggered: proc.running = true
  }
}
