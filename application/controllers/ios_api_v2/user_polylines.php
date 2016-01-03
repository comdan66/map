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

  public function index () {
    $next_id = OAInput::get ('next_id');
    $limit = OAInput::get ('limit');

    $limit = $limit ? $limit : 5;

    $conditions = $next_id ? array ('id <= ?', $next_id) : array ();
    $polylines = Polyline::find ('all', array ('order' => 'id DESC', 'limit' => $limit + 1, 'include' => array ('user'), 'conditions' => $conditions));

    $next_id = ($temp = (count ($polylines) > $limit ? end ($polylines) : null)) ? $temp->id : -1;

    return $this->output_json (array (
      'status' => true,
      'polylines' => array_map (function ($polyline) {
        return array (
            'id' => $polyline->id,
            'cover' => $polyline->cover->url ('640x640c'),
            'avatar' => $polyline->user->avatar->url ('100x100c'),
            'is_finished' => $polyline->is_finished,
            'run_time' => implode ('', $polyline->run_time_units ()),
            'length' => $polyline->length > 0 ? round ($polyline->length / 1000, 2) . '公里' : '',
          );
      }, array_slice ($polylines, 0, $limit)),
      'next_id' => $next_id
    ));
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
