<?php if ( ! defined('BASEPATH')) exit('No direct script access allowed');

/**
 * @author      OA Wu <comdan66@gmail.com>
 * @copyright   Copyright (c) 2015 OA Wu Design
 */

class Cli extends Site_controller {

  public function __construct () {
    parent::__construct ();

    // if (!(($psw = $this->uri->segment(3)) && (md5 ($psw) == '23a6a54bf45b8ea5551f958e4ed82990'))) {
    //   echo '密碼錯誤！';
    //   exit ();
    // }
    if (!$this->input->is_cli_request ()) {
      echo 'Request 錯誤！';
      exit ();
    }
  }
  public function index () {
    echo "string";
  }
}
