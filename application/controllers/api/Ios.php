<?php if ( ! defined('BASEPATH')) exit('No direct script access allowed');

/**
 * @author      OA Wu <comdan66@gmail.com>
 * @copyright   Copyright (c) 2015 OA Wu Design
 */

class Ios extends Api_controller {

  public function update_polylines () {
    $event_id  = trim (OAInput::post ('event_id'));

    if (!($event_id && ($event = Event::find_by_id ($event_id))))
      return $this->output_json (array ('status' => false));
    
    $polylines = OAInput::post ('polylines');
    
    usort ($polylines, function ($a, $b) { return $a['id'] > $b['id']; });

    array_filter ($polylines, function ($polyline) { return $polyline['accuracy_h'] < 100; });

    $ids = array_filter (array_map (function ($polyline) use ($event) {
          if (verifyCreateOrm (Polyline::create (array (
                          'event_id' => $event->id,
                          'latitude' => $polyline['lat'],
                          'longitude' => $polyline['lng'],
                          'altitude' => $polyline['altitude'],
                          'accuracy_horizontal' => $polyline['accuracy_h'],
                          'accuracy_vertical' => $polyline['accuracy_v'],
                          'speed' => $polyline['speed']
                        ))))
            return $polyline['id'];
          else
            return null;
        }, $polylines));
    
    // delay_job ('main', 'event', array ('id' => $event->id));
    
    return $this->output_json (array ('status' => true, 'ids' => $ids));
  }

  public function create_event () {
    $name  = OAInput::post ('name');

    if (!$name)
      return $this->output_json (array ('status' => false));

    if (verifyCreateOrm ($event = Event::create (array (
        'name' => $name,
        'description' => '',
        'cover' => '',
        'length' => 0,
        'run_time' => 0,
        'is_visibled' => 1
      ))))
      return $this->output_json (array ('status' => true, 'id' => $event->id));
    else
      return $this->output_json (array ('status' => false, 'id' => 0));
  }
}
