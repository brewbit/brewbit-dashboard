
var active_graph = null;

function session_graph_mouseenter(event, g, context) {
  active_graph = g;
  $('.sensor-plot').css('cursor', '-webkit-grab');
}

function session_graph_mouseleave(event, g, context) {
  active_graph = null;
  $('.sensor-plot').css('cursor', '');
}

function session_graph_mousedown(event, g, context) {
  context.initializeMouseDown(event, g, context);
  Dygraph.startPan(event, g, context);
  $('.sensor-plot').css('cursor', '-webkit-grabbing');
  context.boundedDates = g.getOption('dateWindowLimits') || g.xAxisExtremes();
}

function session_graph_mousemove(event, g, context) {
  if (context.isPanning) {
    $('.sensor-plot').css('cursor', '-webkit-grabbing');
    Dygraph.movePan(event, g, context);
  }
}

function session_graph_mouseup(event, g, context) {
  $('.sensor-plot').css('cursor', '-webkit-grab');
  if (context.isPanning) {
    Dygraph.endPan(event, g, context);
  }
}

function session_graph_touchstart(event, g, context) {
  Dygraph.Interaction.startTouch(event, g, context);
  context.touchDirections.y = false;
}

function session_graph_touchmove(event, g, context) {
  Dygraph.Interaction.moveTouch(event, g, context);
}

function session_graph_touchend(event, g, context) {
  Dygraph.Interaction.endTouch(event, g, context);
}

// Take the offset of a mouse event on the dygraph canvas and
// convert it to a percentage of the width of the graph.
function offsetToPercentage(g, offsetX) {
  // This is calculating the pixel offset of the leftmost date.
  var xOffset = g.toDomCoords(g.xAxisRange()[0], null)[0];

  // x y w and h are relative to the corner of the drawing area,
  // so that the upper corner of the drawing area is (0, 0).
  var x = offsetX - xOffset;

  // This is computing the rightmost pixel, effectively defining the
  // width.
  var w = g.toDomCoords(g.xAxisRange()[1], null)[0] - xOffset;

  // Percentage from the left.
  var xPct = w == 0 ? 0 : (x / w);

  // The (1-) part below changes it from "% distance down from the top"
  // to "% distance up from the bottom".
  return xPct;
}

function session_graph_dblclick(event, g, context) {
  // Reducing by 20% makes it 80% the original size, which means
  // to restore to original size it must grow by 25%

  if (!event.offsetX){
    event.offsetX = event.layerX - event.target.offsetLeft;
  }

  var xPct = offsetToPercentage(g, event.offsetX);

  if (event.ctrlKey) {
    zoom(g, -.25, xPct);
  } else {
    zoom(g, +.2, xPct);
  }
}

function session_graph_scroll(event, g, context) {
  if (active_graph != g) {
    return;
  }
  var normal = event.detail ? event.detail * -1 : event.wheelDelta / 40;
  // For me the normalized value shows 0.075 for one click. If I took
  // that verbatim, it would be a 7.5%.
  var percentage = normal / 50;

  if (!event.offsetX){
    event.offsetX = event.layerX - event.target.offsetLeft;
  }

  var xPct = offsetToPercentage(g, event.offsetX);

  zoom(g, percentage, xPct);
  Dygraph.cancelEvent(event);
}

// Adjusts [x, y] toward each other by zoomInPercentage%
// Split it so the left axis gets xBias of that change and
// right gets (1-xBias) of that change.
//
// If a bias is missing it splits it down the middle.
function zoom(g, zoomInPercentage, xBias) {
  xBias = xBias || 0.5;
  function adjustAxis(axis, zoomInPercentage, bias) {
    var delta = axis[1] - axis[0];
    var increment = delta * zoomInPercentage;
    var foo = [increment * bias, increment * (1-bias)];
    return [ axis[0] + foo[0], axis[1] - foo[1] ];
  }
  
  var newWindow = adjustAxis(g.xAxisRange(), zoomInPercentage, xBias);
  var windowLimits = g.getOption('dateWindowLimits') || g.xAxisExtremes();

  if (newWindow[0] < windowLimits[0]) {
    newWindow[0] = windowLimits[0];
  }

  if (newWindow[1] > windowLimits[1]) {
    newWindow[1] = windowLimits[1];
  }

  g.updateOptions({
    dateWindow: newWindow
  });
}

function output_status_plotter(e) {
  var ctx = e.drawingContext;
  var points = e.points;
  var area = e.dygraph.getArea();
 
  ctx.fillStyle = e.color;
  ctx.globalAlpha = e.dygraph.getOption('fillAlpha');
  
  for (var i = 0; i < points.length; i++) {
    // find the next ON point
    while ((i < points.length) && (points[i].yval != 1)) {
      i++;
    }
    if (i < points.length) {
      x_on = points[i].canvasx;
    }
    else {
      break;
    }

    // find OFF point
    while ((i < points.length) && (points[i].yval == 1)) {
      i++;
    }
    if (i < points.length) {
      x_off = points[i].canvasx;
    }
    else {
      x_off = (area.x + area.w);
    }
    
    ctx.fillRect(x_on, area.y, x_off - x_on, area.h);
    ctx.strokeRect(x_on, area.y, x_off - x_on, area.h);
  }
}
