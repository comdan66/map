<?php if ( ! defined('BASEPATH')) exit('No direct script access allowed');

/**
 * @author      OA Wu <comdan66@gmail.com>
 * @copyright   Copyright (c) 2015 OA Wu Design
 */

class Event extends OaModel {

  static $table_name = 'events';

  static $has_one = array (
  );

  static $has_many = array (
    array ('polylines', 'class_name' => 'Polyline', 'order' => 'id ASC')
  );

  static $belongs_to = array (
  );

  public function __construct ($attributes = array (), $guard_attributes = true, $instantiating_via_find = false, $new_record = true) {
    parent::__construct ($attributes, $guard_attributes, $instantiating_via_find, $new_record);

    OrmImageUploader::bind ('cover', 'EventCoverImageUploader');
  }

  public function compute_run_time () {
    if (!(($first = Polyline::first (array ('select' => 'created_at', 'conditions' => array ('event_id = ?', $this->id)))) && ($last = Polyline::last (array ('select' => 'created_at', 'conditions' => array ('event_id = ?', $this->id))))))
      return 0;

    return strtotime ($last->created_at->format ('Y-m-d H:i:s')) - strtotime ($first->created_at->format ('Y-m-d H:i:s'));
  }
  public function compute_length () {
    if (!isset ($this->length))
      return;

    $this->CI->load->library ('SphericalGeometry');

    return SphericalGeometry::computeLength (array_map (function ($polyline) {
          return new LatLng (
              $polyline->latitude,
              $polyline->longitude
            );
        }, Polyline::find ('all', array ('select' => 'latitude, longitude', 'conditions' => array ('event_id = ?', $this->id)))));
  }
  public function destroy () {
    Polyline::delete_all (array ('conditions' => array ('event_id = ?', $this->id)));
    return $this->cover->cleanAllFiles () && $this->delete ();
  }
  public function put_cover () {
    if ($url = $this->picture ('1200x1200', 'server_key'))
      return $this->cover->put_url ($url);
    else
      return true;
  }
  public function picture ($size = '60x60', $type = 'client_key', $color = 'red') {
    $u = round (Polyline::count (array ('conditions' => array ('event_id = ?', $this->id))) / 50);

    $paths = array ();
    foreach ($this->polylines as $i => $polyline)
      if ($i % $u == 0)
        array_push ($paths, $polyline->latitude . ',' . $polyline->longitude);

    if ($paths)
      return 'https://maps.googleapis.com/maps/api/staticmap?path=color:' . $color . '|weight:5|' . implode ('|', $paths) . '&size=' . $size . '&key=' . Cfg::setting ('google', ENVIRONMENT, $type);
    else
      return '';
  }
  public function run_time_str () {
    return (gmdate ('j', $this->run_time) - 1 ? gmdate ('j', $this->run_time) - 1 . '天 ' : '') .
           (gmdate ('G', $this->run_time) ? gmdate ('G', $this->run_time) . '小時 ' : '') .
           (gmdate ('i', $this->run_time) * 1 ? gmdate ('i', $this->run_time) * 1 . '分 ' : '') .
           (gmdate ('s', $this->run_time) * 1 ? gmdate ('s', $this->run_time) * 1 . '秒' : '');
  }
}