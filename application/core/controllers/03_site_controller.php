<?php if ( ! defined('BASEPATH')) exit('No direct script access allowed');

/**
 * @author      OA Wu <comdan66@gmail.com>
 * @copyright   Copyright (c) 2015 OA Wu Design
 */

class Site_controller extends Oa_controller {

  public function __construct () {
    parent::__construct ();

    $this
         ->set_componemt_path ('component', 'site')
         ->set_frame_path ('frame', 'site')
         ->set_content_path ('content', 'site')
         ->set_public_path ('public')

         ->set_title ("OA's CI")

         ->_add_meta ()
         ->_add_css ()
         ->_add_js ()
         ;
  }

  private function _add_meta () {
    return $this->add_meta (array ('name' => 'viewport', 'content' => 'width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no, minimal-ui'))
    ;
  }

  private function _add_css () {
    return $this->append_css (base_url ('application', 'cell', 'views', 'frame_cell', 'nav', 'content.css'))
                ;
  }

  private function _add_js () {
    return $this->add_js (base_url ('resource', 'javascript', 'jquery_v1.10.2', 'jquery-1.10.2.min.js'))
                ->add_js (base_url ('resource', 'javascript', 'jquery-rails_d2015_03_09', 'jquery_ujs.js'))
                ->add_js (base_url ('resource', 'javascript', 'imgLiquid_v0.9.944', 'imgLiquid-min.js'))
                ;
  }
}