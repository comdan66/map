<?php if ( ! defined('BASEPATH')) exit('No direct script access allowed');

/**
 * @author      OA Wu <comdan66@gmail.com>
 * @copyright   Copyright (c) 2015 OA Wu Design
 */

class F2e extends Api_controller {

  public function polyline ($id = 0) {
    if (!($polyline = Polyline::last (array ('conditions' => $id ? array ('id = ?', $id) : array ('is_visibled = ?', 1)))))
      return $this->output_json (array ('status' => true, 'paths' => array ()));

    if (!($all_path_ids = column_array (Path::find ('all', array ('select' => 'id', 'order' => 'id DESC', 'conditions' => array (
                    'polyline_id' => $polyline->id
                  ))), 'id')))
      return $this->output_json (array ('status' => true, 'paths' => array ()));

    $is_GS = true;
    $path_ids = array ();
    for ($i = 0; ($key = $is_GS ? round (($i * (2 + ($i - 1) * 0.25)) / 2) : $i) < $all_path_ids[0]; $i++)
      if ($temp = array_slice ($all_path_ids, $key, 1))
        array_push ($path_ids, array_shift ($temp));

    if (!($paths = Path::find ('all', array ('select' => 'id, latitude AS lat, longitude AS lng, speed AS s', 'order' => 'id DESC', 'conditions' => array ('id IN (?)', $path_ids)))))
      return $this->output_json (array ('status' => true, 'paths' => array ()));

    return $this->output_json (array ('status' => true, 'avatar' => $polyline->user->avatar->url ('100x100c'), 'paths' => array_map (function ($path) {
      return $path->to_array ();
    }, $paths)));
  }
}
