<?php if ( ! defined('BASEPATH')) exit('No direct script access allowed');

/**
 * @author      OA Wu <comdan66@gmail.com>
 * @copyright   Copyright (c) 2015 OA Wu Design
 */

class F2e extends Api_controller {

  public function polyline ($id = 0) {
    if (!($event = Event::find ('one', array ('conditions' => array ('id = ? AND is_visibled = ?', $id, 1)))))
      return $this->output_json (array ('status' => true, 'markers' => array ()));

    if (!($all_polyline_ids = column_array (Polyline::find ('all', array ('select' => 'id', 'order' => 'id DESC', 'conditions' => array (
                    'event_id' => $event->id
                  ))), 'id')))
      return $this->output_json (array ('status' => true, 'markers' => array ()));

    $is_GS = true;
    $polyline_ids = array ();
    for ($i = 0; ($key = $is_GS ? round (($i * (2 + ($i - 1) * 0.25)) / 2) : $i) < $all_polyline_ids[0]; $i++)
      if ($temp = array_slice ($all_polyline_ids, $key, 1))
        array_push ($polyline_ids, array_shift ($temp));

    if (!($polylines = Polyline::find ('all', array ('select' => 'id, latitude AS lat, longitude AS lng, speed AS s', 'order' => 'id DESC', 'conditions' => array ('id IN (?)', $polyline_ids)))))
      return $this->output_json (array ('status' => true, 'markers' => array ()));

    return $this->output_json (array ('status' => true, 'markers' => array_map (function ($polyline) {
      return $polyline->to_array ();
    }, $polylines)));
  }
}
