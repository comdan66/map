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

  public function destroy () {
    Polyline::delete_all (array ('conditions' => array ('event_id = ?', $this->id)));
    return $this->cover->cleanAllFiles () && $this->delete ();
  }
  public function put_cover () {
    if ($url = $this->picture ('1200x1200', 'server_key'))
      return $this->cover->put_url ();
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
}