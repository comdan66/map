<?php if ( ! defined('BASEPATH')) exit('No direct script access allowed');

/**
 * @author      OA Wu <comdan66@gmail.com>
 * @copyright   Copyright (c) 2015 OA Wu Design
 */

class Polylines extends Site_controller {

  public function index ($id = 0) {
    if (!($id && ($polyline = Polyline::find ('one', array ('conditions' => array ('id = ?', $id))))))
      return redirect_message (array (''), array (
          '_flash_message' => ''
        ));

    $this->add_js (Cfg::setting ('google', 'client_js_url'), false)
         ->add_hidden (array ('id' => 'polyline_url', 'value' => base_url ('api', 'f2e', 'polyline', $polyline->id)))
         ->load_view ();
  }
}
