/**
 * @author      OA Wu <comdan66@gmail.com>
 * @copyright   Copyright (c) 2015 OA Wu Design
 */

$(function () {
  var $map = $('#map');
  var $polylines = $('input[type="hidden"][name="polylines"]');
  var _map = null;
  var _markers = [];

  function circlePath (r) {
    return 'M 0 0 m -' + r + ', 0 '+
           'a ' + r + ',' + r + ' 0 1,0 ' + (r * 2) + ',0 ' +
           'a ' + r + ',' + r + ' 0 1,0 -' + (r * 2) + ',0';
  }
  function setPolyline () {
    for (var i = 0; i < _markers.length; i++) {
      if (!_markers[i].polyline) {
        _markers[i].polyline = new google.maps.Polyline ({
          map: _map,
          strokeColor: 'rgba(68, 77, 145, .6)',
          strokeWeight: 6,
          drawPath: function () {
            var prevPosition = this.prevMarker.getPosition ();
            var nextPosition = this.nextMarker.getPosition ();
            this.setPath ([prevPosition, nextPosition]);
              if (!this.prevMarker.map)
                this.prevMarker.setMap (_map);
              if (!this.nextMarker.map)
                this.nextMarker.setMap (_map);
              if (!this.map)
                this.setMap (_map);
          }
        });
      }
      
      _markers[i].polyline.prevMarker = _markers[i - 1] ? _markers[i - 1] : _markers[i];
      _markers[i].polyline.nextMarker = _markers[i];
      _markers[i].polyline.drawPath ();
    }
  }
  function initMarker (position, index, id) {
    var marker = new google.maps.Marker ({
        map: _map,
        draggable: false,
        position: position,
        icon: {
            path: circlePath (10),
            strokeColor: 'rgba(50, 60, 140, .4)',
            strokeWeight: 1,
            fillColor: 'rgba(68, 77, 145, .95)',
            fillOpacity: 0.5
          }
      });
    _markers.push (marker);
    
    setPolyline ();
  }
  function initialize () {
    _map = new google.maps.Map ($map.get (0), {
        zoom: 14,
        zoomControl: true,
        scrollwheel: true,
        scaleControl: true,
        mapTypeControl: false,
        navigationControl: true,
        streetViewControl: false,
        disableDoubleClickZoom: true,
        center: new google.maps.LatLng (25.04, 121.55),
      });

    $polylines.each (function () {
      initMarker (new google.maps.LatLng ($(this).data ('lat'), $(this).data ('lng')), 0, $(this).val ());
    });

    if (_markers.length > 0) {
      var bounds = new google.maps.LatLngBounds ();
      for (i = 0; i< _markers.length; i++)
       bounds.extend (_markers[i].getPosition ());
      _map.fitBounds (bounds);
    }

    window.closeLoading ();
  }
  google.maps.event.addDomListener (window, 'load', initialize);
});