<?php if ( ! defined('BASEPATH')) exit('No direct script access allowed');

/**
 * @author      OA Wu <comdan66@gmail.com>
 * @copyright   Copyright (c) 2015 OA Wu Design
 */

class Events extends Site_controller {

  public function __construct () {
    parent::__construct ();
  }

  public function show ($id = 0) {
    if (!($event = Event::find_by_id ($id, array ('conditions' => array ('is_visibled = ?', 1)))))
      return redirect ('');

    if (!($u = round (Polyline::count (array ('conditions' => array ('event_id = ?', $event->id))) / 150)))
      return redirect ('');

    $polylines = array ();
    foreach ($event->polylines as $i => $polyline)
      if ($i % $u == 0)
        array_push ($polylines, $polyline);
    
    if (!$polylines)
      return redirect ('');

    $this->add_meta (array ('property' => 'og:image', 'content' => $event->cover->url ('1200x630c'), 'alt' =>  "OA's Maps"))
         ->load_view (array (
        'event' => $event,
        'polylines' => $polylines
      ));
  }
}
