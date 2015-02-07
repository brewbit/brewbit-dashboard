/*global Dygraph:false */

Dygraph.Plugins.Events = (function() {

"use strict";

/**
 * @typedef {
 *   xval:  number,      // x-value (i.e. millis or a raw number)
 *   infoDiv: !Element    // div containing info about the nearest points
 *   selected: boolean    // whether this event is selected
 * } Event
 */

var events = function(opt_options) {
  /* @type {!Array.<!Event>} */
  this.events_ = [];

  // Used to detect resizes (which require the divs to be repositioned).
  this.lastWidth_ = -1;
  this.lastHeight = -1;
  this.dygraph_ = null;

  this.addTimer_ = null;
  opt_options = opt_options || {};

  this.divFiller_ = opt_options['divFiller'] || null;
};

events.prototype.toString = function() {
  return "Events Plugin";
};

events.prototype.activate = function(g) {
  this.dygraph_ = g;
  this.events_ = [];

  return {
    didDrawChart: this.didDrawChart,
    dataDidUpdate: this.dataDidUpdate
  };
};

events.prototype.detachLabels = function() {
  for (var i = 0; i < this.events_.length; i++) {
    var h = this.events_[i];
    $(h.infoDiv).remove();
    this.events_[i] = null;
  }
  this.events_ = [];
};

// This creates the event object and returns it.
// It does not position it and does not attach it to the chart.
events.prototype.createEvent = function(props) {
  var h;
  var self = this;
  
  var templateDiv = $('#event-template').get(0);

  var $infoDiv = $('#event-template').clone().removeAttr('id').css({
      'position': 'absolute'
    })
    .show();

  h = $.extend({
    selected: false,
    infoDiv: $infoDiv.get(0)
  }, props);

  var that = this;
  $infoDiv.on('click', function() {
    that.moveEventToTop(h);
  });
  $infoDiv.hover(function() {
    that.moveEventToTop(h);
  });

  $infoDiv.html(this.getTemplateHTML(templateDiv, props));

  return h;
};

// Fill out a div using the values in the annotation object.
// The div's html is expected to have text of the form "{{key}}"
events.prototype.getTemplateHTML = function(div, a) {
  var g = this.dygraph_;

  var html = div.innerHTML;
  for (var k in a) {
    var v = a[k];
    if (typeof(v) == 'object') continue;  // e.g. infoDiv or lineDiv
    html = html.replace(new RegExp('\{\{' + k + '\}\}', 'g'), v);
  }
  return html;
};

// Moves a event's divs to the top of the z-ordering.
events.prototype.moveEventToTop = function(h) {
  var div = this.dygraph_.graphDiv;
  $(h.infoDiv).appendTo(div);

  var idx = this.events_.indexOf(h);
  this.events_.splice(idx, 1);
  this.events_.push(h);
};

// Positions existing event divs.
events.prototype.updateEventDivPositions = function() {
  var g = this.dygraph_;
  var layout = this.dygraph_.getArea();
  var chartLeft = layout.x, chartRight = layout.x + layout.w;

  $.each(this.events_, function(idx, h) {
    var left = g.toDomXCoord(h.xval);
    h.domX = left;  // See comments in this.dataDidUpdate
    $(h.infoDiv).css({
      'left': left-5 + 'px',
      'bottom': '16px',
    });

    var visible = (left >= chartLeft && left <= chartRight);
    $(h.infoDiv).toggle(visible);
  });
};

// Sets styles on the event (i.e. "selected")
events.prototype.updateEventStyles = function() {
  $.each(this.events_, function(idx, h) {
    $(h.infoDiv).toggleClass('selected', h.selected);
  });
};

// Find prevRow and nextRow such that
// g.getValue(prevRow, 0) <= xval
// g.getValue(nextRow, 0) >= xval
// g.getValue({prev,next}Row, col) != null, NaN or undefined
// and there's no other row such that:
//   g.getValue(prevRow, 0) < g.getValue(row, 0) < g.getValue(nextRow, 0)
//   g.getValue(row, col) != null, NaN or undefined.
// Returns [prevRow, nextRow]. Either can be null (but not both).
events.findPrevNextRows = function(g, xval, col) {
  var prevRow = null, nextRow = null;
  var numRows = g.numRows();
  for (var row = 0; row < numRows; row++) {
    var yval = g.getValue(row, col);
    if (yval === null || yval === undefined || isNaN(yval)) continue;

    var rowXval = g.getValue(row, 0);
    if (rowXval <= xval) prevRow = row;

    if (rowXval >= xval) {
      nextRow = row;
      break;
    }
  }

  return [prevRow, nextRow];
};

// After a resize, the event divs can get dettached from the chart.
// This reattaches them.
events.prototype.attachEventsToChart_ = function() {
  var div = this.dygraph_.graphDiv;
  $.each(this.events_, function(idx, h) {
    $(h.infoDiv).appendTo(div);
  });
};

// Deletes a event and removes it from the chart.
events.prototype.removeEvent = function(h) {
  var idx = this.events_.indexOf(h);
  if (idx >= 0) {
    this.events_.splice(idx, 1);
    $(h.infoDiv).remove();
  } else {
    Dygraph.warn('Tried to remove non-existent event.');
  }
};

events.prototype.didDrawChart = function(e) {
  var g = e.dygraph;

  // Early out in the (common) case of zero events.
  if (this.events_.length === 0) return;

  this.updateEventDivPositions();
  this.attachEventsToChart_();
  this.updateEventStyles();
};

events.prototype.dataDidUpdate = function(e) {
  // When the data in the chart updates, the events should stay in the same
  // position on the screen. didDrawChart stores a domX parameter for each
  // event. We use that to reposition them on data updates.
  var g = this.dygraph_;
  $.each(this.events_, function(idx, h) {
    if (h.hasOwnProperty('domX')) {
      h.xval = g.toDataXCoord(h.domX);
    }
  });
};

events.prototype.destroy = function() {
  this.detachLabels();
};


// Public API

/**
 * This is a restricted view of this.events_ which doesn't expose
 * implementation details like the handle divs.
 *
 * @typedef {
 *   xval:  number,       // x-value (i.e. millis or a raw number)
 *   selected: bool       // whether the event is selected.
 * } PublicEvent
 */

/**
 * @param {!Event} h Internal event.
 * @return {!PublicEvent} Restricted public view of the event.
 */
events.prototype.createPublicEvent_ = function(h) {
  return {
    xval: h.xval,
    selected: h.selected
  };
};

/**
 * @return {!Array.<!PublicEvent>} The current set of events, ordered
 *     from back to front.
 */
events.prototype.get = function() {
  var result = [];
  for (var i = 0; i < this.events_.length; i++) {
    var h = this.events_[i];
    result.push(this.createPublicEvent_(h));
  }
  return result;
};

/**
 * Calling this will result in a eventsChanged event being triggered, no
 * matter whether it consists of additions, deletions, moves or no changes at
 * all.
 *
 * @param {!Array.<!PublicEvent>} events The new set of events,
 *     ordered from back to front.
 */
events.prototype.set = function(events) {
  // Re-use divs from the old events array so far as we can.
  // They're already correctly z-ordered.
  var anyCreated = false;
  for (var i = 0; i < events.length; i++) {
    var h = events[i];

    if (this.events_.length > i) {
      // Only the divs need to be preserved.
      var oldA = this.events_[i];
      this.events_[i] = $.extend({
        infoDiv: oldA.infoDiv,
        lineDiv: oldA.lineDiv
      }, h);
    } else {
      this.events_.push(this.createEvent(h));
      anyCreated = true;
    }
  }

  // If there are any remaining events, destroy them.
  while (events.length < this.events_.length) {
    this.removeEvent(this.events_[events.length]);
  }

  this.updateEventDivPositions();
  this.updateEventStyles();
  if (anyCreated) {
    this.attachEventsToChart_();
  }

  $(this).triggerHandler('eventsChanged', {});
};

return events;

})();
