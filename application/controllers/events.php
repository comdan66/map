<?php if ( ! defined('BASEPATH')) exit('No direct script access allowed');

/**
 * @author      OA Wu <comdan66@gmail.com>
 * @copyright   Copyright (c) 2015 OA Wu Design
 */

class Events extends Site_controller {

  public function __construct () {
    parent::__construct ();
  }

  public function show ($id = 0) {
    if (!($event = Event::find_by_id ($id)))
      return redirect ('');

    $this->load_view (array (
        'event' => $event
      ));
  }
}
