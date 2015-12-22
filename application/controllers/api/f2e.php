<?php if ( ! defined('BASEPATH')) exit('No direct script access allowed');

/**
 * @author      OA Wu <comdan66@gmail.com>
 * @copyright   Copyright (c) 2015 OA Wu Design
 */

class F2e extends Api_controller {

  private function _paths ($polyline) {
    if (!($polyline && ($all_path_ids = column_array (Path::find ('all', array ('select' => 'id', 'order' => 'id DESC', 'conditions' => array (
                        'polyline_id = ? AND accuracy_horizontal < ?', $polyline->id, 100
                      ))), 'id'))))
      return false;

    $is_GS = true;
    $path_ids = array ();
    for ($i = 0; ($key = $is_GS ? round (($i * (2 + ($i - 1) * 0.25)) / 2) : $i) < $all_path_ids[0]; $i++)
      if ($temp = array_slice ($all_path_ids, $key, 1))
        array_push ($path_ids, array_shift ($temp));

    if (!($paths = Path::find ('all', array ('select' => 'id, latitude AS lat, longitude AS lng, speed AS s', 'order' => 'id DESC', 'conditions' => array ('id IN (?)', $path_ids)))))
      return false;

    return array (
        'avatar' => $polyline->user->avatar->url ('100x100c'),
        'is_finished' => $polyline->is_finished,
        'paths' => array_map (function ($path) {
            return $path->to_array ();
          }, $paths)
        );
  }
  public function polylines () {
    $user_ids = array (1, 2);
    $users = User::find ('all', array ('conditions' => array ('id IN (?)', $user_ids)));
    $that = $this;
    $units = array_filter (array_map (function ($user) use ($that) {
      $polyline = Polyline::find ('one', array ('order' => 'id DESC', 'conditions' => array ('user_id = ?', $user->id)));
      $paths = $that->_paths ($polyline);
      return $paths ? array_merge (array ('user_id' => $user->id), $paths) : null;
    }, $users));

    return $this->output_json (array_merge (array ('status' => true), array ('units' => $units)));
  }
  public function polyline ($id = 0) {
    if (!($polyline = Polyline::last (array ('conditions' => $id ? array ('id = ?', $id) : array ('is_visibled = ?', 1)))))
      return $this->output_json (array ('status' => false, 'paths' => array ()));

    if (!($paths = $this->_paths ($polyline)))
      return $this->output_json (array ('status' => false, 'paths' => array ()));

    return $this->output_json (array_merge (array ('status' => true), $paths));
  }
}
