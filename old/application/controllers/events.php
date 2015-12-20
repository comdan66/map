<?php if ( ! defined('BASEPATH')) exit('No direct script access allowed');

/**
 * @author      OA Wu <comdan66@gmail.com>
 * @copyright   Copyright (c) 2015 OA Wu Design
 */

class Events extends Site_controller {

  public function __construct () {
    parent::__construct ();
  }

  public function x ($id = 0) {
    
    $this
         ->set_componemt_path ('component', 'new')
         ->set_frame_path ('frame', 'new')
         ->set_content_path ('content', 'new')
         ->set_public_path ('public')
         ->load_view (array (
      ));
  }
  public function show ($id = 0) {
    if (!($event = Event::find ('one', array ('conditions' => array ('id = ? AND is_visibled = ?', $id, 1)))))
      return redirect ('');

    $total = 150;
    $all_polyline_ids = column_array (Polyline::find ('all', array ('select' => 'id', 'order' => 'id DESC', 'conditions' => array (
            'event_id' => $event->id
          ))), 'id');

    $polyline_ids = array ();
    for ($i = 0; ($key = round (($i * (2 + ($i - 1) * 0.25)) / 2)) < $all_polyline_ids[0]; $i++)
      array_push ($polyline_ids, $all_polyline_ids[$key]);

    $polylines = Polyline::find ('all', array ('conditions' => array ('id IN (?)', $polyline_ids)));
    
    $this->add_meta (array ('property' => 'og:image', 'content' => $event->cover->url ('1200x630c'), 'alt' =>  "OA's Maps"))
         ->load_view (array (
        'event' => $event,
        'polylines' => $polylines
      ));


    // $total = 150;
    // $polyline_ids = column_array (Polyline::find ('all', array ('select' => 'id', 'conditions' => array (
    //         'event_id' => $event->id
    //       ))), 'id');




    // if (!($u = round (Polyline::count (array ('conditions' => array ('event_id = ?', $event->id))) / 150)))
    //   return redirect ('');

    // $polylines = array ();
    // foreach ($event->polylines as $i => $polyline)
    //   if ($i % $u == 0)
    //     array_push ($polylines, $polyline);
    
    // if (!$polylines)
    //   return redirect ('');

    // $this->add_meta (array ('property' => 'og:image', 'content' => $event->cover->url ('1200x630c'), 'alt' =>  "OA's Maps"))
    //      ->load_view (array (
    //     'event' => $event,
    //     'polylines' => $polylines
    //   ));
  }
}
