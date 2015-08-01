<?php if ( ! defined('BASEPATH')) exit('No direct script access allowed');

/**
 * @author      OA Wu <comdan66@gmail.com>
 * @copyright   Copyright (c) 2015 OA Wu Design
 */

class Site_frame_cell extends Cell_Controller {

  /* render_cell ('site_frame_cell', 'header', var1, ..); */
  // public function _cache_header () {
  //   return array ('time' => 60 * 60, 'key' => null);
  // }
  public function header () {
    $left_links = array (
        array ('name' => '首頁', 'href' => base_url (), 'show' => true),
        array ('name' => '地圖', 'href' => base_url ('maps'), 'show' => true),
        array ('name' => '相簿', 'href' => base_url ('albums'), 'show' => true),
        array ('name' => '旅記', 'href' => base_url ('travels'), 'show' => true),
      );
    $right_links = array (
        array ('name' => '後台', 'href' => base_url ('admin'), 'show' => true),
        array ('name' => '關於', 'href' => base_url ('about'), 'show' => true),
      );
    return $this->setUseJsList (true)
                ->setUseCssList (true)
                ->load_view (array (
                    'left_links' => $left_links,
                    'right_links' => $right_links
                  ));
  }

  /* render_cell ('site_frame_cell', 'footer', var1, ..); */
  // public function _cache_footer () {
  //   return array ('time' => 60 * 60, 'key' => null);
  // }
  public function footer () {
    return $this->setUseCssList (true)
                ->load_view ();
  }
}