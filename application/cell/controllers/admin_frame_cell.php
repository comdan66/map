<?php if ( ! defined('BASEPATH')) exit('No direct script access allowed');

/**
 * @author      OA Wu <comdan66@gmail.com>
 * @copyright   Copyright (c) 2015 OA Wu Design
 */

class Admin_frame_cell extends Cell_Controller {

  /* render_cell ('admin_frame_cell', 'header', var1, ..); */
  // public function _cache_header () {
  //   return array ('time' => 60 * 60, 'key' => null);
  // }
  public function header () {
    $left_links = array (
        array ('name' => '首頁', 'href' => base_url (), 'show' => true),
        array ('name' => '活動', 'href' => base_url ('admin', 'events'), 'show' => identity ()->get_session ('is_login') ? true : false),
      );
    $right_links = array (
        array ('name' => '登出', 'href' => base_url ('admin', 'main', 'logout'), 'show' => identity ()->get_session ('is_login') ? true : false),
        array ('name' => '登入', 'href' => base_url ('admin', 'main', 'login'), 'show' => identity ()->get_session ('is_login') ? false : true),
      );
    return $this->setUseJsList (true)
                ->setUseCssList (true)
                ->load_view (array (
                    'left_links' => $left_links,
                    'right_links' => $right_links
                  ));
  }

  /* render_cell ('admin_frame_cell', 'footer', var1, ..); */
  // public function _cache_footer () {
  //   return array ('time' => 60 * 60, 'key' => null);
  // }
  public function footer () {
    return $this->setUseCssList (true)
                ->load_view ();
  }

  /* render_cell ('admin_frame_cell', 'pagination', var1, ..); */
  // public function _cache_pagination () {
  //   return array ('time' => 60 * 60, 'key' => null);
  // }
  public function pagination ($pagination) {
    return $this->setUseCssList (true)
                ->load_view (array ('pagination' => $pagination));
  }
}