<?php

use Parse\ParseObject;
use Parse\ParseQuery;
use Parse\ParseACL;
use Parse\ParsePush;
use Parse\ParseUser;
use Parse\ParseInstallation;
use Parse\ParseException;
use Parse\ParseAnalytics;
use Parse\ParseFile;
use Parse\ParseCloud;
use Parse\ParseClient;



if ( ! defined('BASEPATH')) exit('No direct script access allowed');

/**
 * @author      OA Wu <comdan66@gmail.com>
 * @copyright   Copyright (c) 2015 OA Wu Design
 */

class PushToParse {

  public function __construct () {
    require_once FCPATH . 'vendor/autoload.php';

    ParseClient::initialize (Cfg::setting ('parse', ENVIRONMENT, 'app_id'), Cfg::setting ('parse', ENVIRONMENT, 'rest_key'), Cfg::setting ('parse', ENVIRONMENT, 'master_key'));
  }
  public static function send ($msg, $channels = array ()) {
    $data = array (
            'sound' => 'default',
            'alert' => $msg,
            'url' => 'http://tinyurl.com/qjqt7l5/',
            'badge' => 2028
            // 'launch-image' => 'http://www.imageshop.com.tw/pic/shop/home/women-world.jpg'
        );

    if ($channels)
      ParsePush::send (array ('channels' => $channels, 'data' => $data));
    else
      ParsePush::send (array ('where' => ParseInstallation::query (), 'data' => $data));
  }

}
