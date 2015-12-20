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
  var $fm = $('#fm');

  var _map = null;
  var _markers = [];
  var _polyline = [];

  function circlePath (r) {
    return 'M 0 0 m -' + r + ', 0 '+
           'a ' + r + ',' + r + ' 0 1,0 ' + (r * 2) + ',0 ' +
           'a ' + r + ',' + r + ' 0 1,0 -' + (r * 2) + ',0';
  }
  function setPolyline () {
    for (var i = 0; i < _markers.length; i++) {
      if (!_markers[i].polyline) {
        var polyline = new google.maps.Polyline ({
          map: _map,
          strokeColor: 'rgba(68, 77, 145, .6)',
          strokeWeight: 6,
          drawPath: function () {
            // var prevPosition = this.prevMarker.getPosition ();
            // var nextPosition = this.nextMarker.getPosition ();
            // var isPrevIn = (prevPosition.lat () < _map.getBounds ().getNorthEast ().lat ()) && (prevPosition.lng () < _map.getBounds ().getNorthEast ().lng ()) && (prevPosition.lat () > _map.getBounds ().getSouthWest ().lat ()) && (prevPosition.lng () > _map.getBounds ().getSouthWest ().lng ());
            // var isNextIn = (nextPosition.lat () < _map.getBounds ().getNorthEast ().lat ()) && (nextPosition.lng () < _map.getBounds ().getNorthEast ().lng ()) && (nextPosition.lat () > _map.getBounds ().getSouthWest ().lat ()) && (nextPosition.lng () > _map.getBounds ().getSouthWest ().lng ());

            // this.setPath ([prevPosition, nextPosition]);

            // if (isPrevIn || isNextIn) {
            //   if (!this.prevMarker.map)
            //     this.prevMarker.setMap (_map);
            //   if (!this.nextMarker.map)
            //     this.nextMarker.setMap (_map);
            //   if (!this.map)
            //     this.setMap (_map);
            // } else {
            //   this.prevMarker.setMap (null);
            //   this.nextMarker.setMap (null);
            //   this.setMap (null);
            // }

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

        google.maps.event.addListener (polyline, 'rightclick', function (e) {
          $polylineContextMenu.css ({ top: e.ub.offsetY, left: e.ub.offsetX })
                              .data ('lat', e.latLng.lat ())
                              .data ('lng', e.latLng.lng ())
                              .addClass ('show').polyline = polyline;
                              
        });
        _markers[i].polyline = polyline;
      }
      
      _markers[i].polyline.prevMarker = _markers[i - 1] ? _markers[i - 1] : _markers[i];
      _markers[i].polyline.nextMarker = _markers[i];
      _markers[i].polyline.drawPath ();
    }
  }
  function initMarker (position, index, id) {
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

    $fm.find ('[name="polylines"]').each (function () {
      initMarker (new google.maps.LatLng ($(this).data ('lat'), $(this).data ('lng')), 0, $(this).val ());
    });

    if (_markers.length > 0) {
      var bounds = new google.maps.LatLngBounds ();
      for (i = 0; i< _markers.length; i++)
       bounds.extend (_markers[i].getPosition ());
      _map.fitBounds (bounds);
    }

    google.maps.event.addListener (_map, 'zoom_changed', setLastPosition.bind (this, 'oas_maps_admin_last', _map));
    google.maps.event.addListener (_map, 'idle', setLastPosition.bind (this, 'oas_maps_admin_last', _map));
    google.maps.event.addListener (_map, 'zoom_changed',setPolyline);
    google.maps.event.addListener (_map, 'idle', setPolyline);

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
      if ($polylineContextMenu.polyline)
        initMarker (new google.maps.LatLng ($polylineContextMenu.data ('lat'), $polylineContextMenu.data ('lng')), _markers.indexOf ($polylineContextMenu.polyline.nextMarker));

      $contextMenu.css ({ top: -100, left: -100 }).removeClass ('show');
    });

    $fm.submit (function () {
      $(this).find ('*').not ('button').remove ();

      $(this).append (_markers.map (function (t, i) {
        return $('<input />').attr ('type', 'hidden').attr ('name', 'polylines[' + i + '][lat]').val (t.getPosition ().lat ()).add ($('<input />').attr ('type', 'hidden').attr ('name', 'polylines[' + i + '][lng]').val (t.getPosition ().lng ()));
      }));
    });
    window.closeLoading ();
  }
  google.maps.event.addDomListener (window, 'load', initialize);
});