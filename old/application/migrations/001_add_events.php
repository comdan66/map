<?php defined('BASEPATH') OR exit('No direct script access allowed');

/**
 * @author      OA Wu <comdan66@gmail.com>
 * @copyright   Copyright (c) 2015 OA Wu Design
 */

class Migration_Add_events extends CI_Migration {
  public function up () {
    $this->db->query (
      "CREATE TABLE `events` (
        `id` int(11) NOT NULL AUTO_INCREMENT,
        `name` varchar(255) COLLATE utf8_unicode_ci NOT NULL COMMENT '名稱',
        `description` text  COMMENT '敘述',
        `cover` varchar(100) COLLATE utf8_unicode_ci NOT NULL COMMENT '封面',
        `is_visibled` int(2) NOT NULL DEFAULT 0,
        `updated_at` datetime NOT NULL DEFAULT '" . date ('Y-m-d H:i:s') . "' COMMENT '更新時間',
        `created_at` datetime NOT NULL DEFAULT '" . date ('Y-m-d H:i:s') . "' COMMENT '新增時間',
        PRIMARY KEY (`id`)
      ) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;"
    );
  }
  public function down () {
    $this->db->query (
      "DROP TABLE `events`;"
    );
  }
}