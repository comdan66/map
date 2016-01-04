<?php if ( ! defined('BASEPATH')) exit('No direct script access allowed');

/**
 * @author      OA Wu <comdan66@gmail.com>
 * @copyright   Copyright (c) 2015 OA Wu Design
 */
class Main extends Delay_controller {

  public function __construct () {
    parent::__construct ();
  }

  public function put_cover () {
    if (!(($id = OAInput::post ('id')) && ($polyline = Polyline::find_by_id ($id, array ('select' => 'id, cover')))))
      return;
    Polyline::transaction (function () use ($polyline) {
      return $polyline->put_cover ();
    });
  }
  public function compute_polyline () {
    if (!(($id = OAInput::post ('id')) && ($polyline = Polyline::find_by_id ($id, array ('select' => 'id, length, run_time')))))
      return;

    $polyline->length = $polyline->compute_length ();
    $polyline->run_time = $polyline->compute_run_time ();
    
    Polyline::transaction (function () use ($polyline) {
      return $polyline->save ();
    });
  }
  // public function event () {
  //   if (!(($id = $this->input_post ('id')) && ($event = Event::find_by_id ($id))))
  //     return;

  //   $event->length = $event->compute_length ();
  //   $event->run_time = $event->compute_run_time ();
  //   $event->put_cover ();
  // }
}
