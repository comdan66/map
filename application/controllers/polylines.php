<?php if ( ! defined('BASEPATH')) exit('No direct script access allowed');

/**
 * @author      OA Wu <comdan66@gmail.com>
 * @copyright   Copyright (c) 2015 OA Wu Design
 */

class Polylines extends Site_controller {

  public function index () {
    // $user_ids = array (1, 2);
    // $users = array_filter (array_map (function ($user_id) {
    //       return Polyline::find ('one', array ('order' => 'id DESC', 'include' => array ('user'), 'conditions' => array ('user_id = ?', $user_id)));
    //     }, $user_ids));
    // echo '<meta http-equiv="Content-type" content="text/html; charset=utf-8" /><pre>';
    // var_dump ($users);
    // exit ();
    $this->add_js (Cfg::setting ('google', 'client_js_url'), false)
         ->add_js (base_url ('resource', 'javascript', 'markerwithlabel', 'markerwithlabel_packed.js'))
         ->add_hidden (array ('id' => 'polylines_url', 'value' => base_url ('api', 'f2e', 'polylines')))
         ->load_view ();
  }
  public function content ($id = 0) {
    if (!($id && ($polyline = Polyline::find ('one', array ('conditions' => array ('id = ?', $id))))))
      return redirect_message (array (''), array (
          '_flash_message' => ''
        ));

    $this->add_js (Cfg::setting ('google', 'client_js_url'), false)
         ->add_js (base_url ('resource', 'javascript', 'markerwithlabel', 'markerwithlabel_packed.js'))
         ->add_hidden (array ('id' => 'polyline_url', 'value' => base_url ('api', 'f2e', 'polyline', $polyline->id)))
         ->load_view ();
  }
}
