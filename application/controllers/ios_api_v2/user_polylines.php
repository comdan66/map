<?php if ( ! defined('BASEPATH')) exit('No direct script access allowed');

/**
 * @author      OA Wu <comdan66@gmail.com>
 * @copyright   Copyright (c) 2015 OA Wu Design
 */

class User_polylines extends Api_controller {

  private $user = null;
  private $polyline = null;

  public function __construct () {
    parent::__construct ();

    if (!(($id = $this->uri->rsegments (6, 0)) && ($this->user = User::find_by_id ($id))))
      return $this->disable ($this->output_json (array ('status' => false)));

    if ($this->uri->rsegments (9, 0) && in_array ($this->uri->rsegments (9, 0), array ('finish')))
      if (!(($id = $this->uri->rsegments (8, 0)) && ($this->polyline = Polyline::find_by_id_and_user_id ($id, $this->user->id))))
        return $this->disable ($this->output_json (array ('status' => false)));
  }

  public function finish () {
    $polyline = $this->polyline;
    $polyline->is_finished = 1;

    $update = Polyline::transaction (function () use ($polyline) {
      return $polyline->save ();
    });

    return $this->output_json (array ('status' => $update ? true : false));
  }
  public function newest () {
    if (!($polyline = Polyline::find ('one', array ('select' => 'id', 'order' => 'id DESC', 'conditions' => array ('user_id = ?', $this->user->id)))))
      return $this->output_json (array ('status' => false));
    return $this->output_json (array ('status' => true, 'id' => $polyline->id));
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
    if (!(isset ($posts['user_id']) && is_numeric ($posts['user_id'] = trim ($posts['user_id'])))) $posts['user_id'] = $this->user->id;

    return '';
  }
}
