<?php if ( ! defined('BASEPATH')) exit('No direct script access allowed');

/**
 * @author      OA Wu <comdan66@gmail.com>
 * @copyright   Copyright (c) 2015 OA Wu Design
 */

class Events extends Admin_controller {

  public function __construct () {
    parent::__construct ();
  }

  public function map ($id = 0) {
    if (!($event = Event::find_by_id ($id)))
      return redirect (array ('admin', 'events'));

    $message  = identity ()->get_session ('_flash_message', true);
    $polylines = identity ()->get_session ('polylines', true);

    $this->load_view (array (
        'event' => $event,
        'message' => $message,
        'polylines' => $polylines
      ));
  }
  public function destroy ($id = 0) {
    if (!($event = Event::find_by_id ($id)))
      return redirect (array ('admin', 'events'));

    $message = $event->destroy () ? '刪除成功！' : '刪除失敗！';

    return identity ()->set_session ('_flash_message', $message, true)
                    && redirect (array ('admin', 'events'), 'refresh');
  }
  public function edit ($id = 0) {
    if (!($event = Event::find_by_id ($id)))
      return redirect (array ('admin', 'events'));

    $message  = identity ()->get_session ('_flash_message', true);

    $name = trim (identity ()->get_session ('name', true));
    $description = trim (identity ()->get_session ('description', true));

    $this->load_view (array (
        'event' => $event,
        'message' => $message,
        'name' => $name,
        'description' => $description
      ));
  }

  public function update ($id = 0) {
    if (!($event = Event::find_by_id ($id)))
      return redirect (array ('admin', 'events'));

    if (!$this->has_post ())
      return redirect (array ('admin', 'events', 'edit', $event->id));

    $name = trim ($this->input_post ('name'));
    $description = trim ($this->input_post ('description'));

    if (!$name)
      return identity ()->set_session ('_flash_message', '填寫資訊有少！', true)
                        ->set_session ('name', $name, true)
                        ->set_session ('description', $description, true)
                        && redirect (array ('admin', 'events', 'edit', $event->id), 'refresh');

    $event->name = $name;
    $event->description = $description;

    if (!$event->save ())
      return identity ()->set_session ('_flash_message', '修改失敗！', true)
                        ->set_session ('name', $name, true)
                        ->set_session ('description', $description, true)
                        && redirect (array ('admin', 'events', 'edit', $event->id), 'refresh');

    return identity ()->set_session ('_flash_message', '修改成功！', true)
                      && redirect (array ('admin', 'events'), 'refresh');
  }

  public function add () {
    $message  = identity ()->get_session ('_flash_message', true);
    
    $name = trim (identity ()->get_session ('name', true));
    $description = trim (identity ()->get_session ('description', true));

    $this->load_view (array (
        'message' => $message,
        'name' => $name,
        'description' => $description,
      ));
  }
  public function create () {
    if (!$this->has_post ())
      return redirect (array ('admin', 'events', 'add'));

    $name = trim ($this->input_post ('name'));
    $description = trim ($this->input_post ('description'));

    if (!$name)
      return identity ()->set_session ('_flash_message', '填寫資訊有少！', true)
                        ->set_session ('name', $name, true)
                        ->set_session ('description', $description, true)
                        && redirect (array ('admin', 'events', 'add'), 'refresh');

    $params = array (
        'name' => $name,
        'description' => $description,
        'cover' => ''
      );

    if (!verifyCreateOrm ($event = Event::create ($params)))
      return identity ()->set_session ('_flash_message', '新增失敗！', true)
                        ->set_session ('name', $name, true)
                        ->set_session ('description', $description, true)
                        && redirect (array ('admin', 'events', 'add'), 'refresh');

    // if (!$event->put_pic () && ($event->destroy () || true))
    //   return identity ()->set_session ('_flash_message', '新增失敗(取得 Static 失敗)！', true)
    //                     ->set_session ('event_category_id', $event_category_id, true)
    //                     ->set_session ('name', $name, true)
    //                     ->set_session ('postal_code', $postal_code, true)
    //                     ->set_session ('latitude', $latitude, true)
    //                     ->set_session ('longitude', $longitude, true)
    //                     ->set_session ('zoom', $zoom, true)
    //                     && redirect (array ('admin', 'events', 'add'), 'refresh');

    return identity ()->set_session ('_flash_message', '新增成功！', true)
                      && redirect (array ('admin', 'events'), 'refresh');
  }

  public function index ($offset = 0) {
    $columns = array ('id' => 'int', 'name' => 'string', 'description' => 'string');
    $configs = array ('admin', 'events', '%s');

    $conditions = conditions (
                    $columns,
                    $configs,
                    'Event',
                    $this->input_gets ()
                  );
    $has_search = $conditions ? true : false;
    $conditions = array (implode (' AND ', $conditions));

    $limit = 25;
    $total = Event::count (array ('conditions' => $conditions));
    $offset = $offset < $total ? $offset : 0;

    $this->load->library ('pagination');
    $configs = array_merge (array ('total_rows' => $total, 'num_links' => 5, 'per_page' => $limit, 'uri_segment' => 0, 'base_url' => '', 'page_query_string' => false, 'first_link' => '第一頁', 'last_link' => '最後頁', 'prev_link' => '上一頁', 'next_link' => '下一頁', 'full_tag_open' => '<ul class="pagination">', 'full_tag_close' => '</ul>', 'first_tag_open' => '<li>', 'first_tag_close' => '</li>', 'prev_tag_open' => '<li>', 'prev_tag_close' => '</li>', 'num_tag_open' => '<li>', 'num_tag_close' => '</li>', 'cur_tag_open' => '<li class="active"><a href="#">', 'cur_tag_close' => '</a></li>', 'next_tag_open' => '<li>', 'next_tag_close' => '</li>', 'last_tag_open' => '<li>', 'last_tag_close' => '</li>'), $configs);
    $this->pagination->initialize ($configs);
    $pagination = $this->pagination->create_links ();

    $events = Event::find ('all', array ('offset' => $offset, 'limit' => $limit, 'order' => 'id DESC', 'conditions' => $conditions));

    $message = identity ()->get_session ('_flash_message', true);

    $this->add_hidden (array ('id' => 'refresh_weather_url', 'value' => base_url ('admin', 'events', 'refresh_weather')))
         ->load_view (array (
        'message' => $message,
        'pagination' => $pagination,
        'events' => $events,
        'has_search' => $has_search,
        'columns' => $columns
      ));
  }
}
