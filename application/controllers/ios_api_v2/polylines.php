<?php if ( ! defined('BASEPATH')) exit('No direct script access allowed');

/**
 * @author      OA Wu <comdan66@gmail.com>
 * @copyright   Copyright (c) 2015 OA Wu Design
 */

class Polylines extends Api_controller {

  public function first () {
    
  }
  public function create () {
    $posts = OAInput::post ();

    if ($msg = $this->_validation_polyline_posts ($posts))
      return $this->output_json (array ('status' => false));

    $polyline = null;
    $create = Polyline::transaction (function () use ($posts, &$polyline) {
      if (!(verifyCreateOrm ($polyline = Polyline::create (array_intersect_key ($posts, Polyline::table ()->columns)))))
        return false;

      return true;
    });

    if ($create)
      return $this->output_json (array ('status' => true, 'id' => $polyline->id));
    else
      return $this->output_json (array ('status' => false));
  }
  private function _validation_polyline_posts (&$posts) {
    if (!(isset ($posts['name']) && ($posts['name'] = trim ($posts['name'])))) $posts['name'] = date ('Y-m-d H:i:s');
    if (!(isset ($posts['user_id']) && is_numeric ($posts['user_id'] = trim ($posts['user_id'])))) $posts['user_id'] = 1;

    return '';
  }
}
