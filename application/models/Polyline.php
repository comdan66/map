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

  private $paths = null;

  const D4_START_LAT = 25.0404423;
  const D4_START_LNG = 121.5192483;

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
    if (!(isset ($this->id) && ($first = Path::first (array ('select' => 'create_time', 'conditions' => array ('polyline_id = ?', $this->id)))) && ($last = Path::last (array ('select' => 'create_time', 'conditions' => array ('polyline_id = ?', $this->id))))))
      return 0;

    return strtotime ($last->create_time->format ('Y-m-d H:i:s')) - strtotime ($first->create_time->format ('Y-m-d H:i:s'));
  }
  public function run_time_units () {
    if (!isset ($this->run_time))
      return array ();

    $units = array ();

    array_push ($units, gmdate ('j', $this->run_time) - 1 ? gmdate ('j', $this->run_time) - 1 . '天' : null);
    array_push ($units, gmdate ('G', $this->run_time) ? gmdate ('G', $this->run_time) . '小時' : null);
    array_push ($units, gmdate ('i', $this->run_time) * 1 ? gmdate ('i', $this->run_time) * 1 . '分' : null);
    array_push ($units, gmdate ('s', $this->run_time) * 1 ? gmdate ('s', $this->run_time) * 1 . '秒' : null);

    return array_filter ($units);
  }
  public function paths ($select = '', $is_GS = true) {
    if ($this->paths !== null) return $this->paths;

    $path_ids = array ();

    if (!isset ($this->id))
      return $path_ids;

    if (!($all_path_sqlite_ids = column_array (Path::find ('all', array ('select' => 'sqlite_id', 'order' => 'sqlite_id DESC', 'conditions' => array (
                                'polyline_id = ? AND accuracy_horizontal < ?', $this->id, 100
                              ))), 'sqlite_id')))
      return $path_ids;

    $c = count ($all_path_sqlite_ids);
    $unit = $c < 10000 ? $c < 5000 ? $c < 2500 ? $c < 1500 ? $c < 1000 ? $c < 500 ? $c < 200 ? $c < 100 ? $c < 10 ? 0 : 0.01 : 0.05 : 0.15 : 0.3 : 0.46 : 1 : 1.5 : 2.3 : 3;
    for ($i = 0; ($key = $is_GS ? round (($i * (2 + ($i - 1) * $unit)) / 2) : $i) < $all_path_sqlite_ids[0]; $i++)
      if ($temp = array_slice ($all_path_sqlite_ids, $key, 1))
        array_push ($path_ids, array_shift ($temp));

    if (!$path_ids) return $path_ids;
echo '<meta http-equiv="Content-type" content="text/html; charset=utf-8" /><pre>';
var_dump ($path_ids);
exit ();
    return $this->paths = Path::find ('all', array ('select' => !$select ? 'id, latitude AS lat, longitude AS lng, speed as sd' : $select, 'order' => 'sqlite_id DESC', 'conditions' => array ('sqlite_id IN (?)', $path_ids)));
  }
  public function picture ($size = '60x60', $type = 'client_key', $color = '0x780f79', $marker_color = 'red') {
    if (count ($paths = array_map (function ($path) { return $path->lat . ',' . $path->lng; }, $this->paths ())) > 1)
      return 'https://maps.googleapis.com/maps/api/staticmap?path=color:' . $color . '|weight:5|' . implode ('|', $paths) . '&size=' . $size . '&markers=color:' . $marker_color . '%7C' . $paths[0] . '&language=zh-TW&key=' . Cfg::setting ('google', ENVIRONMENT, $type);
    else if ($paths && ($paths = array_shift ($paths)))
      return 'https://maps.googleapis.com/maps/api/staticmap?center=' . $paths . '&zoom=13&size=' . $size . '&markers=color:' . $marker_color . '%7C' . $paths . '&language=zh-TW&key=' . Cfg::setting ('google', ENVIRONMENT, $type);
    else
      return 'https://maps.googleapis.com/maps/api/staticmap?center=' . Polyline::D4_START_LAT . ',' . Polyline::D4_START_LNG . '&zoom=13&size=' . $size . '&markers=color:' . $marker_color . '%7C' . Polyline::D4_START_LAT . ',' . Polyline::D4_START_LNG . '&language=zh-TW&key=' . Cfg::setting ('google', ENVIRONMENT, $type);
  }
  public function put_cover () {
    if ($url = $this->picture ('1200x1200', 'server_key'))
      return $this->cover->put_url ($url);
    else
      return true;
  }
}