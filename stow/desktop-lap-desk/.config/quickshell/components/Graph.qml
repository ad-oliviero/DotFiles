import QtQuick
import QtQuick.Layouts

import "../Style"

// Canvas-based multi-series line graph (§6). Anti-aliased lines (2 px) with a
// semi-transparent area fill, 4 horizontal grid divisions, auto-scaled Y axis
// (ceil to nearest `yCeilStep`), right-aligned Y labels, a bottom legend, and
// a centered "no data" empty state.
//
// series: [{ label: string, color: color, values: [number, ...] }]
Canvas {
  id: canvas

  property var series: []
  property int maxSamples: 60
  property int yCeilStep: 10
  property int gridDivisions: 4
  property real aspectRatio: 2.0 // width : height — fixed for all graphs

  // fixed aspect ratio, fills available width
  Layout.fillWidth: true
  Layout.preferredHeight: width / aspectRatio

  onSeriesChanged: requestPaint()
  onWidthChanged: requestPaint()
  onHeightChanged: requestPaint()

  onPaint: {
    var ctx = getContext("2d")
    ctx.reset()

    var W = width
    var H = height
    var padL = 32, padR = 8, padT = 8, padB = 20
    var plotW = W - padL - padR
    var plotH = H - padT - padB
    if (plotW <= 0 || plotH <= 0)
      return

    var gridCol = Qt.alpha(Style.color.fg, 0.12)
    var labelCol = Style.color.fg

    // --- Y scale: ceil(max across all series) to nearest yCeilStep ---
    var maxVal = 0
    for (var s = 0; s < series.length; s++) {
      var vals = series[s].values || []
      for (var v = 0; v < vals.length; v++)
        if (vals[v] > maxVal)
          maxVal = vals[v]
    }
    var yMax = Math.ceil(maxVal / yCeilStep) * yCeilStep
    if (yMax < yCeilStep)
      yMax = yCeilStep

    ctx.font = Style.size.graphText + "px " + Style.font.family

    // --- grid + Y labels ---
    ctx.strokeStyle = gridCol
    ctx.lineWidth = 1
    ctx.fillStyle = labelCol
    ctx.textAlign = "right"
    ctx.textBaseline = "middle"
    for (var i = 0; i <= gridDivisions; i++) {
      var yv = yMax * i / gridDivisions
      var yy = padT + plotH - yv / yMax * plotH
      ctx.beginPath()
      ctx.moveTo(padL, yy)
      ctx.lineTo(W - padR, yy)
      ctx.stroke()
      ctx.fillText(Math.round(yv), padL - 5, yy)
    }

    // --- series lines + area fills ---
    var hasData = false
    var denom = maxSamples > 1 ? maxSamples - 1 : 1
    function xOf(j, n) {
      return padL + (maxSamples - n + j) / denom * plotW
    }
    function yOf(val) {
      return padT + plotH - Math.min(val, yMax) / yMax * plotH
    }
    for (var k = 0; k < series.length; k++) {
      var ser = series[k]
      var arr = ser.values || []
      var n = arr.length
      if (n === 0)
        continue
      hasData = true

      // line
      ctx.beginPath()
      for (var j = 0; j < n; j++) {
        var x = xOf(j, n)
        var y = yOf(arr[j])
        if (j === 0)
          ctx.moveTo(x, y)
        else
          ctx.lineTo(x, y)
      }
      ctx.strokeStyle = ser.color
      ctx.lineWidth = 2
      ctx.stroke()

      // area fill (close to baseline)
      ctx.lineTo(xOf(n - 1, n), padT + plotH)
      ctx.lineTo(xOf(0, n), padT + plotH)
      ctx.closePath()
      ctx.fillStyle = Qt.alpha(ser.color, 0.18)
      ctx.fill()
    }

    // --- empty state ---
    if (!hasData) {
      ctx.fillStyle = labelCol
      ctx.textAlign = "center"
      ctx.textBaseline = "middle"
      ctx.font = Style.size.textSize + "px " + Style.font.family
      ctx.fillText("no data", W / 2, padT + plotH / 2)
      return
    }

    // --- legend ---
    ctx.textAlign = "left"
    ctx.textBaseline = "middle"
    ctx.font = Style.size.graphText + "px " + Style.font.family
    var lx = padL
    for (var m = 0; m < series.length; m++) {
      var lbl = series[m].label
      if (!lbl)
        continue
      ctx.fillStyle = series[m].color
      ctx.beginPath()
      ctx.arc(lx + 4, H - padB / 2, 3, 0, Math.PI * 2)
      ctx.fill()
      ctx.fillStyle = labelCol
      ctx.fillText(lbl, lx + 12, H - padB / 2)
      lx += 24 + ctx.measureText(lbl).width
    }
  }
}
