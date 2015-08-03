/**
 * @author      OA Wu <comdan66@gmail.com>
 * @copyright   Copyright (c) 2015 OA Wu Design
 */

$(function () {
  var $map = $('#map');
  var $length = $('#length');
  var $polylines = $('input[type="hidden"][name="polylines"]');

  var _map = null;
  var _markers = [];
  var colors = ['#CCDDFF', '#99BBFF', '#5599FF', '#0066FF', '#0044BB', '#003C9D', '#003377'];
  function circlePath (r) {
    return 'M 0 0 m -' + r + ', 0 '+
           'a ' + r + ',' + r + ' 0 1,0 ' + (r * 2) + ',0 ' +
           'a ' + r + ',' + r + ' 0 1,0 -' + (r * 2) + ',0';
  }
  function color (speed) {
    speed = parseInt ((speed < 0 ? 0 : speed * 3.6) / 10, 10);
    return colors[speed] ? colors[speed] : colors[colors.length - 1];
  }
  function setPolyline () {
    for (var i = 1; i < _markers.length; i++) {
        new google.maps.Polyline ({
          map: _map,
          strokeColor: color(_markers[i - 1].$obj.data ('speed')),
          strokeWeight: 6,
          path: [_markers[i - 1].getPosition (), _markers[i].getPosition ()]
        });
    }
    
  }
  function initMarker ($obj) {
    return new google.maps.Marker ({
        map: _map,
        draggable: false,
        position: new google.maps.LatLng ($obj.data ('lat'), $obj.data ('lng')),
        icon: { path: 'M 0 0' },
        $obj: $obj
      });
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

    _markers = $polylines.map (function () {
      return initMarker ($(this));
    });

    setPolyline ();

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