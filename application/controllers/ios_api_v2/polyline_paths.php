<?php if ( ! defined('BASEPATH')) exit('No direct script access allowed');

/**
 * @author      OA Wu <comdan66@gmail.com>
 * @copyright   Copyright (c) 2015 OA Wu Design
 */

class Polyline_paths extends Api_controller {
  private $polyline = null;

  public function __construct () {
    parent::__construct ();

    if (!(($id = $this->uri->rsegments (6, 0)) && ($this->polyline = Polyline::find_by_id ($id))))
      return $this->disable ($this->output_error_json ('Parameters error!'));
  }
  private function _paths ($polyline) {
    if (!($paths = $this->polyline->paths ()))
      return false;

    return array (
        'avatar' => $polyline->user->avatar->url ('100x100c'),
        'is_finished' => $polyline->is_finished ? true : false,
        'paths' => array_map (function ($path) {
            return $path->to_array ();
          }, $paths)
        );
  }
  public function index () {
    if (!($paths = $this->_paths ($this->polyline)))
      return $this->output_json (array (
          'avatar' => $this->polyline->user->avatar->url ('100x100c'),
          'is_finished' => true,
          'paths' => array (),
          'run_time' => '0秒',
          'length' => '0公尺'
        ));

    $run_time = $this->polyline->run_time_units ();

    return $this->output_json (array_merge (array (
        'run_time' => $run_time ? implode ('', $run_time) : '0秒',
        'length' => $this->polyline->length > 0 ? round ($this->polyline->length / 1000, 2) . '公里' : '0公尺',
      ), $paths));
  }
  public function create () {
    $paths = ($paths = OAInput::post ('paths')) ? $paths : array ();

    $paths = array_filter ($paths, array ($this, '_validation_path_posts'));
    usort ($paths, function ($a, $b) { return $a['sqlite_id'] > $b['sqlite_id']; });

    $polyline = $this->polyline;
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
    
    delay_job ('main', 'compute_polyline', array ('id' => $this->polyline->id));

    return $this->output_json (array ('ids' => $sqlite_ids));
  }
  private function _validation_path_posts (&$posts) {
    if (!(isset ($posts['id']) && is_numeric ($posts['id'] = trim ($posts['id'])))) return false; $posts['sqlite_id'] = $posts['id']; unset ($posts['id']);    
    if (!(isset ($posts['lat']) && is_numeric ($posts['lat'] = trim ($posts['lat'])))) return false; $posts['latitude'] = $posts['lat']; unset ($posts['lat']);
    if (!(isset ($posts['lng']) && is_numeric ($posts['lng'] = trim ($posts['lng'])))) return false; $posts['longitude'] = $posts['lng']; unset ($posts['lng']);
    if (!(isset ($posts['ah']) && is_numeric ($posts['ah'] = trim ($posts['ah'])))) return false; $posts['accuracy_horizontal'] = $posts['ah']; unset ($posts['ah']);
    if (!(isset ($posts['av']) && is_numeric ($posts['av'] = trim ($posts['av'])))) return false; $posts['accuracy_vertical'] = $posts['av']; unset ($posts['av']);
    if (!(isset ($posts['al']) && is_numeric ($posts['al'] = trim ($posts['al'])))) return false; $posts['altitude'] = $posts['al']; unset ($posts['al']);
    if (!(isset ($posts['sd']) && is_numeric ($posts['sd'] = trim ($posts['sd'])))) return false; $posts['speed'] = $posts['sd']; unset ($posts['sd']);
    if (!(isset ($posts['ct']) && $posts['ct'] = trim ($posts['ct']))) return false; $posts['create_time'] = $posts['ct']; unset ($posts['ct']);

    return true;
  }
}
