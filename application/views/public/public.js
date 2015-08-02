/**
 * @author      OA Wu <comdan66@gmail.com>
 * @copyright   Copyright (c) 2015 OA Wu Design
 */

function getUnit (will, now) {
  var addLat = will.lat () - now.lat ();
  var addLng = will.lng () - now.lng ();
  var aveAdd = ((Math.abs (addLat) + Math.abs (addLng)) / 2);
  var unit = aveAdd < 10 ? aveAdd < 1 ? aveAdd < 0.1 ? aveAdd < 0.01 ? aveAdd < 0.001 ? aveAdd < 0.0001 ? 3 : 6 : 9 : 12 : 15 : 24 : 21;
  var lat = addLat / unit;
  var lng = addLng / unit;

  if (!((Math.abs (lat) > 0) || (Math.abs (lng) > 0)))
    return null;

  return {
    unit: unit,
    lat: lat,
    lng: lng
  };
}

function mapMove (map, unitLat, unitLng, unitCount, unit, callback) {
  if (unit > unitCount) {
    map.setCenter (new google.maps.LatLng (map.getCenter ().lat () + unitLat, map.getCenter ().lng () + unitLng));
    clearTimeout (window.mapMoveTimer);
    window.mapMoveTimer = setTimeout (function () {
      mapMove (map, unitLat, unitLng, unitCount + 1, unit, callback);
    }, 25);
  } else {
    if (callback)
      callback (map);
  }
}

function mapGo (map, will, callback) {
  var now = map.center;

  var Unit = getUnit (will, now);
  if (!Unit)
    return false;

  mapMove (map, Unit.lat, Unit.lng, 0, Unit.unit, callback);
}
function getStorage (key) {
  if ((typeof (Storage) !== 'undefined') && (last = localStorage.getItem (key)) && (last = JSON.parse (last)))
    return last;
  else
    return;
}

function setStorage (key, data) {
  if (typeof (Storage) !== 'undefined') {
    localStorage.setItem (key, JSON.stringify (data));
  }
}

function setMapPosition (map, key) {
  var last = getLastPosition ('oas_maps_admin_last');

  if (last) {
    map.setCenter (new google.maps.LatLng (last.lat, last.lng));
    map.setZoom (last.zoom);
  } else {
    navigator.geolocation.getCurrentPosition (function (position) {
      mapGo (map, new google.maps.LatLng (position.coords.latitude, position.coords.longitude), setLastPosition.bind (this, 'oas_maps_admin_last'));
    });
  }
}
function setLastPosition (key, map) {
  setStorage (key, {
    lat: map.center.lat (),
    lng: map.center.lng (),
    zoom: map.zoom
  });
}
function getLastPosition (key) {
  if ((typeof (Storage) !== 'undefined') && (last = getStorage (key)) && (!isNaN (last.lat) && !isNaN (last.lng) && !isNaN (last.zoom) && (last.lat < 86) && (last.lat > -86)))
    return last;
  else
    return;
}

Array.prototype.column = function (k) {
  return this.map (function (t) { return k ? eval ("t." + k) : t; });
};
Array.prototype.diff = function (a, k) {
  return this.filter (function (i) { return a.column (k).indexOf (eval ("i." + k)) < 0; });
};
Array.prototype.max = function (k) {
  return Math.max.apply (null, this.column (k));
};
Array.prototype.min = function (k) {
  return Math.min.apply (null, this.column (k));
};
window.ajaxError = function (result) {
  console.error (result.responseText);
};

$(function () {
  window.mainLoading = $('<div />').attr ('id', 'main_loading').append ($('<div />')).appendTo ('body');

  window.closeLoading = function (callback) {
    this.mainLoading.fadeOut (function () {
      $(this).hide (function () {
        if (callback)
          callback ();
        $(this).remove ();
      });
    });
  };

});