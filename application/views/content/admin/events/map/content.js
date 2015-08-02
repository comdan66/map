/**
 * @author      OA Wu <comdan66@gmail.com>
 * @copyright   Copyright (c) 2015 OA Wu Design
 */

$(function () {
  var $map = $('#map');
  var $contextMenu = $('.context_menu');
  var $mapContextMenu = $('#map_context_menu');
  var $markerContextMenu = $('#marker_context_menu');
  var $polylineContextMenu = $('#polyline_context_menu');
  var _map = null;
  var _markers = [];
  var _polyline = [];

  function circlePath (r) {
    return 'M 0 0 m -' + r + ', 0 '+
           'a ' + r + ',' + r + ' 0 1,0 ' + (r * 2) + ',0 ' +
           'a ' + r + ',' + r + ' 0 1,0 -' + (r * 2) + ',0';
  }
  function setPolyline () {
    // var positions = _markers.map (function (t) {
    //   return t.getPosition ();
    // });
    // _polyline.setPath (positions);

    // calculateLength (positions);
    for (var i = 1; i < _markers.length; i++) {
      if (!_markers[i].polyline) {
        var polyline = new google.maps.Polyline ({
          map: _map,
          strokeColor: 'rgba(68, 77, 145, .6)',
          strokeWeight: 6,
          index: i
        });

        google.maps.event.addListener (polyline, 'rightclick', function (e) {
          $polylineContextMenu.css ({ top: e.ub.offsetY, left: e.ub.offsetX })
                              .data ('lat', e.latLng.lat ())
                              .data ('lng', e.latLng.lng ())
                              .addClass ('show').index = polyline.index;
                              
        });
        _markers[i].polyline = polyline;
      }
      _markers[i].polyline.index = i;
      _markers[i].polyline.setPath ([_markers[i - 1].getPosition (), _markers[i].getPosition ()]);
    }
  }
  function initMarker (position, index) {
    var marker = new google.maps.Marker ({
        map: _map,
        draggable: true,
        position: position,
        icon: {
            path: circlePath (10),
            strokeColor: 'rgba(50, 60, 140, .4)',
            strokeWeight: 1,
            fillColor: 'rgba(68, 77, 145, .95)',
            fillOpacity: 0.5
          },
        getPixelPosition: function () {
          var scale = Math.pow (2, this.map.getZoom ());
          var nw = new google.maps.LatLng (
              this.map.getBounds ().getNorthEast ().lat (),
              this.map.getBounds ().getSouthWest ().lng ()
          );
          var worldCoordinateNW = this.map.getProjection ().fromLatLngToPoint (nw);
          var worldCoordinate = this.map.getProjection ().fromLatLngToPoint (this.getPosition ());
          
          return new google.maps.Point (
              (worldCoordinate.x - worldCoordinateNW.x) * scale,
              (worldCoordinate.y - worldCoordinateNW.y) * scale
          );
        }
      });

    google.maps.event.addListener (marker, 'drag', setPolyline);

    google.maps.event.addListener (marker, 'rightclick', function (e) {
      var pixel = marker.getPixelPosition ();
      $markerContextMenu.css ({ top: pixel.y, left: pixel.x }).addClass ('show').marker = marker;
    });
    _markers.splice (index ? index : _markers.length, 0, marker);
    
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

    setMapPosition (_map, 'oas_maps_admin_last');

    google.maps.event.addListener (_map, 'zoom_changed', setLastPosition.bind (this, 'oas_maps_admin_last', _map));
    google.maps.event.addListener (_map, 'idle', setLastPosition.bind (this, 'oas_maps_admin_last', _map));
    google.maps.event.addListener (_map, 'rightclick', function (e) {
      $mapContextMenu.css ({ top: e.pixel.y, left: e.pixel.x })
                     .data ('lat', e.latLng.lat ())
                     .data ('lng', e.latLng.lng ()).addClass ('show');
    });
    google.maps.event.addListener (_map, 'mousemove', function () {
      $contextMenu.css ({ top: -100, left: -100 }).removeClass ('show');
    });

    $mapContextMenu.find ('.add_marker').click (function () {
      initMarker (new google.maps.LatLng ($mapContextMenu.data ('lat'), $mapContextMenu.data ('lng')), 0);
      $contextMenu.css ({ top: -100, left: -100 }).removeClass ('show');
    });
    $markerContextMenu.find ('.del').click (function () {
      _markers.splice (_markers.indexOf ($markerContextMenu.marker), 1);
      $markerContextMenu.marker.setMap (null);
      
      if ($markerContextMenu.marker.polyline)
        $markerContextMenu.marker.polyline.setMap (null);
      
      setPolyline ();
      $contextMenu.css ({ top: -100, left: -100 }).removeClass ('show');
    });
    $polylineContextMenu.find ('.add').click (function () {
      if ($polylineContextMenu.index)
        initMarker (new google.maps.LatLng ($polylineContextMenu.data ('lat'), $polylineContextMenu.data ('lng')), $polylineContextMenu.index);

      $contextMenu.css ({ top: -100, left: -100 }).removeClass ('show');
    });
    window.closeLoading ();
  }
  google.maps.event.addDomListener (window, 'load', initialize);
});