<?php if ( ! defined('BASEPATH')) exit('No direct script access allowed');

/**
 * @author      OA Wu <comdan66@gmail.com>
 * @copyright   Copyright (c) 2015 OA Wu Design
 */

class Ios extends Api_controller {

  private function _paths ($polyline) {
    if (!($polyline && ($all_path_ids = column_array (Path::find ('all', array ('select' => 'id', 'order' => 'id DESC', 'conditions' => array (
                        'polyline_id = ? AND accuracy_horizontal < ?', $polyline->id, 100
                      ))), 'id'))))
      return false;

    $is_GS = true;
    $path_ids = array ();
    for ($i = 0; ($key = $is_GS ? round (($i * (2 + ($i - 1) * 0.25)) / 2) : $i) < $all_path_ids[0]; $i++)
      if ($temp = array_slice ($all_path_ids, $key, 1))
        array_push ($path_ids, array_shift ($temp));

    if (!($paths = Path::find ('all', array ('select' => 'id, latitude AS lat, longitude AS lng', 'order' => 'id DESC', 'conditions' => array ('id IN (?)', $path_ids)))))
      return false;

    return array (
        'avatar' => $polyline->user->avatar->url ('100x100c'),
        'is_finished' => $polyline->is_finished,
        'paths' => array_map (function ($path) {
            return $path->to_array ();
          }, $paths)
        );
  }
  public function paths ($polyline_id = 0) {
    if (!($polyline_id && ($polyline = Polyline::find_by_id ($polyline_id, array ('id, is_finished, updated_at')))))
      return $this->output_json (array ('status' => false));

    if (!($paths = $this->_paths ($polyline)))
      return $this->output_json (array ('status' => false));

    return $this->output_json (array_merge (array ('status' => true), $paths));
  }
  public function finish_polyline ($polyline_id = 0) {
    if (!($polyline_id && ($polyline = Polyline::find_by_id ($polyline_id, array ('id, is_finished, updated_at')))))
      return $this->output_json (array ('status' => false));
    
    $update = Path::transaction (function () use ($polyline) {
      $polyline->is_finished = 1;
      return $polyline->save ();
    });
    return $this->output_json (array ('status' => $update ? true : false));
  }
  public function create_polyline () {
    $posts = OAInput::post ();

    if ($msg = $this->_validation_polyline_posts ($posts))
      return $this->output_json (array ('status' => false, 'id' => 0, 'message' => $msg));

    $polyline = null;
    $create = Polyline::transaction (function () use ($posts, &$polyline) {
      if (!(verifyCreateOrm ($polyline = Polyline::create (array_intersect_key ($posts, Polyline::table ()->columns)))))
        return false;

      return true;
    });

    if ($create)
      return $this->output_json (array ('status' => true, 'id' => $polyline->id));
    else
      return $this->output_json (array ('status' => false, 'id' => 0));
  }
  public function create_paths ($polyline_id = 0) {
    if (!($polyline_id && ($polyline = Polyline::find_by_id ($polyline_id, array ('id, is_finished, updated_at')))))
      return $this->output_json (array ('status' => false));
    
    // if ($area = OAInput::post ('area')) {
    //   // push nav
    // }

    $paths = ($paths = OAInput::post ('paths')) ? $paths : array ();
    array_filter ($paths, array ($this, '_validation_path_posts'));
    usort ($paths, function ($a, $b) { return $a['sqlite_id'] > $b['sqlite_id']; });

    $sqlite_ids = column_array (array_filter ($paths, function (&$path) use ($polyline) {
      $create = Path::transaction (function () use (&$path, $polyline) {
        if (!(verifyCreateOrm ($path = Path::create (array_intersect_key (array_merge ($path, array ('polyline_id' => $polyline->id)), Path::table ()->columns)))))
          return false;

        if ($polyline->is_finished && !($polyline->is_finished = 0))
          $polyline->save ();

        return true;
      });
      return $create;
    }), 'sqlite_id');

    // delay_job ('main', 'event', array ('id' => $event->id));

    return $this->output_json (array ('status' => true, 'ids' => $sqlite_ids));
  }
  private function _validation_polyline_posts (&$posts) {
    if (!(isset ($posts['name']) && ($posts['name'] = trim ($posts['name'])))) $posts['name'] = date ('Y-m-d H:i:s');
    if (!(isset ($posts['user_id']) && is_numeric ($posts['user_id'] = trim ($posts['user_id'])))) $posts['user_id'] = 1;

    return '';
  }
  private function _validation_path_posts (&$posts) {
    if (!(isset ($posts['id']) && is_numeric ($posts['id'] = trim ($posts['id'])))) return false; $posts['sqlite_id'] = $posts['id']; unset ($posts['id']);    
    if (!(isset ($posts['lat']) && is_numeric ($posts['lat'] = trim ($posts['lat'])))) return false; $posts['latitude'] = $posts['lat']; unset ($posts['lat']);
    if (!(isset ($posts['lng']) && is_numeric ($posts['lng'] = trim ($posts['lng'])))) return false; $posts['longitude'] = $posts['lng']; unset ($posts['lng']);
    if (!(isset ($posts['a_h']) && is_numeric ($posts['a_h'] = trim ($posts['a_h'])))) return false; $posts['accuracy_horizontal'] = $posts['a_h']; unset ($posts['a_h']);
    if (!(isset ($posts['a_v']) && is_numeric ($posts['a_v'] = trim ($posts['a_v'])))) return false; $posts['accuracy_vertical'] = $posts['a_v']; unset ($posts['a_v']);
    if (!(isset ($posts['al']) && is_numeric ($posts['al'] = trim ($posts['al'])))) return false; $posts['altitude'] = $posts['al']; unset ($posts['al']);
    if (!(isset ($posts['sd']) && is_numeric ($posts['sd'] = trim ($posts['sd'])))) return false; $posts['speed'] = $posts['sd']; unset ($posts['sd']);

    return true;
  }
}
