<?php if ( ! defined('BASEPATH')) exit('No direct script access allowed');

/**
 * @author      OA Wu <comdan66@gmail.com>
 * @copyright   Copyright (c) 2015 OA Wu Design
 */

class Ios extends Api_controller {

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
    if (!($polyline_id && ($polyline = Polyline::find_by_id ($polyline_id))))
      return $this->output_json (array ('status' => false));
    
    $paths = ($paths = OAInput::post ('paths')) ? $paths : array ();
    usort ($paths, function ($a, $b) { return $a['id'] > $b['id']; });
    array_filter ($paths, array ($this, '_validation_path_posts'));
    
    $path_ids = column_array (array_filter ($paths, function (&$path) use ($polyline_id) {
      $create = Path::transaction (function () use (&$path, $polyline_id) {
        if (!(verifyCreateOrm ($path = Path::create (array_intersect_key (array_merge ($path, array ('polyline_id' => $polyline_id)), Path::table ()->columns)))))
          return false;
        return true;
      });
      return $create;
    }), 'id');

    // delay_job ('main', 'event', array ('id' => $event->id));

    return $this->output_json (array ('status' => true, 'path_ids' => $path_ids));
  }
  private function _validation_polyline_posts (&$posts) {
    if (!(isset ($posts['name']) && ($posts['name'] = trim ($posts['name'])))) $posts['name'] = date ('Y-m-d H:i:s');
    if (!(isset ($posts['user_id']) && is_numeric ($posts['user_id'] = trim ($posts['user_id'])))) $posts['user_id'] = 1;

    return '';
  }
  private function _validation_path_posts (&$posts) {
    if ((isset ($posts['id']) && is_numeric ($posts['id'] = trim ($posts['id'])))) unset ($posts['id']);
    if (!(isset ($posts['lat']) && is_numeric ($posts['lat'] = trim ($posts['lat'])))) return false;
    $posts['latitude'] = $posts['lat']; unset ($posts['lat']);
    if (!(isset ($posts['lng']) && is_numeric ($posts['lng'] = trim ($posts['lng'])))) return false;
    $posts['longitude'] = $posts['lng']; unset ($posts['lng']);
    if (!(isset ($posts['accuracy_h']) && is_numeric ($posts['accuracy_h'] = trim ($posts['accuracy_h'])))) return false;
    $posts['accuracy_horizontal'] = $posts['accuracy_h']; unset ($posts['accuracy_h']);
    if (!(isset ($posts['accuracy_v']) && is_numeric ($posts['accuracy_v'] = trim ($posts['accuracy_v'])))) return false;
    $posts['accuracy_vertical'] = $posts['accuracy_v']; unset ($posts['accuracy_v']);
    if (!(isset ($posts['altitude']) && is_numeric ($posts['altitude'] = trim ($posts['altitude'])))) return false;
    if (!(isset ($posts['speed']) && is_numeric ($posts['speed'] = trim ($posts['speed'])))) return false;

    return true;
  }
}
