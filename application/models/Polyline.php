<?php if ( ! defined('BASEPATH')) exit('No direct script access allowed');

/**
 * @author      OA Wu <comdan66@gmail.com>
 * @copyright   Copyright (c) 2015 OA Wu Design
 */

class Polyline extends OaModel {

  static $table_name = 'polylines';

  static $has_one = array (
  );

  static $has_many = array (
  );

  static $belongs_to = array (
    array ('user', 'class_name' => 'User')
  );

  public function __construct ($attributes = array (), $guard_attributes = true, $instantiating_via_find = false, $new_record = true) {
    parent::__construct ($attributes, $guard_attributes, $instantiating_via_find, $new_record);

    OrmImageUploader::bind ('cover', 'PolylineCoverImageUploader');
  }
  public function compute_length () {
    if (!(isset ($this->length) && isset ($this->length)))
      return 0;

    $this->CI->load->library ('SphericalGeometry');

    return SphericalGeometry::computeLength (array_map (function ($path) {
        return new LatLng ($path->latitude, $path->longitude);
      }, Path::find ('all', array ('select' => 'latitude, longitude', 'conditions' => array ('polyline_id = ?', $this->id)))));
  }
  public function compute_run_time () {
    if (!(isset ($this->id) && ($first = Path::first (array ('select' => 'created_at', 'conditions' => array ('polyline_id = ?', $this->id)))) && ($last = Path::last (array ('select' => 'created_at', 'conditions' => array ('polyline_id = ?', $this->id))))))
      return 0;

    return strtotime ($last->created_at->format ('Y-m-d H:i:s')) - strtotime ($first->created_at->format ('Y-m-d H:i:s'));
  }
}