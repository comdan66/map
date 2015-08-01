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
}