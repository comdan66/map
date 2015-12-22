<?php defined('BASEPATH') OR exit('No direct script access allowed');

/**
 * @author      OA Wu <comdan66@gmail.com>
 * @copyright   Copyright (c) 2015 OA Wu Design
 */

class Migration_Add_polylines extends CI_Migration {
  public function up () {
    $this->db->query (
      "CREATE TABLE `polylines` (
        `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
        `user_id` int(11) unsigned NOT NULL COMMENT 'User ID',

        `name` varchar(255) COLLATE utf8_unicode_ci NOT NULL COMMENT '名稱',
        `cover` varchar(100) COLLATE utf8_unicode_ci NOT NULL COMMENT '封面',
        `length` DOUBLE NOT NULL DEFAULT -1 COMMENT '總長度(m)',
        `run_time` int(11) unsigned NOT NULL DEFAULT 0 COMMENT '時間(s)',
        `is_visibled` tinyint(1) NOT NULL DEFAULT 1 COMMENT '是否公開，1 公開，0 不公開',
        `is_finished` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否完成，1 完成，0 未完成',

        `updated_at` datetime NOT NULL DEFAULT '" . date ('Y-m-d H:i:s') . "' COMMENT '更新時間',
        `created_at` datetime NOT NULL DEFAULT '" . date ('Y-m-d H:i:s') . "' COMMENT '新增時間',
        PRIMARY KEY (`id`),
        KEY `user_id_index` (`user_id`),
        FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
      ) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;"
    );
  }
  public function down () {
    $this->db->query (
      "DROP TABLE `polylines`;"
    );
  }
}