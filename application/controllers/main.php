<?php if ( ! defined('BASEPATH')) exit('No direct script access allowed');

/**
 * @author      OA Wu <comdan66@gmail.com>
 * @copyright   Copyright (c) 2015 OA Wu Design
 */

class Main extends Site_controller {

  public function __construct () {
    parent::__construct ();
  }

  public function index () {
//     $date_time_array = getdate (time());
// echo '<meta http-equiv="Content-type" content="text/html; charset=utf-8" /><pre>';
// var_dump (gmdate ('H:i:s', 3190));
// exit ();
// exit();
    foreach (Event::all () as $key => $e) {
      delay_job ('main', 'event', array ('id' => $e->id));
    }
    // $this->load->library ('SphericalGeometry');
    // $e = Event::find_by_id (5);
    // echo '<meta http-equiv="Content-type" content="text/html; charset=utf-8" /><pre>';
    // var_dump ($e->compute_run_time ());
    // exit ();;
    
//     $l = SphericalGeometry::computeLength (array_map (function ($polyline) {
//           return new LatLng (
//               $polyline->latitude,
//               $polyline->longitude
//             );
//         }, $e->polylines));
// echo '<meta http-equiv="Content-type" content="text/html; charset=utf-8" /><pre>';
// var_dump ($l);
// exit ();
    $this->load_view (null);
  }
}
