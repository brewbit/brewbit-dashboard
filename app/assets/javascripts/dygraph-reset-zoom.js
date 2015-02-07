/**
 * @fileoverview Plug-in for providing reset-zoom button on hover.
 */
Dygraph.Plugins.ResetZoom = (function() {

  "use strict";

  /**
   * Create a new instance.
   *
   * @constructor
   */
  var resetzoom = function() {
    this.button_ = null;

    // True when the mouse is over the canvas. Must be tracked
    // because the resetzoom button state can change even when the
    // mouse-over state hasn't.
    this.over_ = false;
  };

  resetzoom.prototype.toString = function() {
    return 'ResetZoom Plugin';
  };

  resetzoom.prototype.activate = function(g) {
    return {
      willDrawChart: this.willDrawChart
    };
  };

  resetzoom.prototype.willDrawChart = function(e) {
    var g = e.dygraph;

    if (this.button_ !== null) {
      // short-circuit: show the button only when we're moused over, and zoomed in.
      var showButton = this.over_ && isZoomed(g);
      this.show(showButton);
      return;
    }

    this.button_ = document.createElement('button');
    this.button_.innerHTML = 'Reset Zoom';
    this.button_.style.display = 'none';
    this.button_.style.position = 'absolute';
    var area = g.plotter_.area;
    this.button_.style.top = (area.y + 4) + 'px';
    this.button_.style.left = (area.x + 4) + 'px';
    this.button_.style.zIndex = 11;
    var parent = g.graphDiv;
    parent.insertBefore(this.button_, parent.firstChild);

    var self = this;
    this.button_.onclick = function() {
      g.updateOptions({ dateWindow: g.getOption('dateWindowLimits') || g.xAxisExtremes() });
    };

    g.addAndTrackEvent(parent, 'mouseover', function() {
      if (isZoomed(g)) {
        self.show(true);
      }
      self.over_ = true;
    });

    g.addAndTrackEvent(parent, 'mouseout', function() {
      self.show(false);
      self.over_ = false;
    });
  };

  resetzoom.prototype.show = function(enabled) {
    this.button_.style.display = enabled ? '' : 'none';
  };

  resetzoom.prototype.destroy = function() {
    this.button_.parentElement.removeChild(this.button_);
  };
  
  function isZoomed(g) {
    var dateWindow = g.getOption('dateWindow');
    if (!dateWindow) {
      return g.isZoomed();
    }
    
    var dateWindowLimits = g.getOption('dateWindowLimits') || g.xAxisExtremes();
    return ((dateWindow[0] != dateWindowLimits[0]) || (dateWindow[1] != dateWindowLimits[1]));
  }

  return resetzoom;

})();
