<?php defined('BASEPATH') OR exit('No direct script access allowed');

/**
 * @author      OA Wu <comdan66@gmail.com>
 * @copyright   Copyright (c) 2015 OA Wu Design
 */

class Migration_Add_paths extends CI_Migration {
  public function up () {
    $this->db->query (
      "CREATE TABLE `paths` (
        `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
        `polyline_id` int(11) unsigned NOT NULL COMMENT 'Polyline ID',
        `sqlite_id` int(11) unsigned NOT NULL DEFAULT 0 COMMENT 'APP SQLite ID',

        `latitude` DOUBLE NOT NULL DEFAULT -1 COMMENT '緯度',
        `longitude` DOUBLE NOT NULL DEFAULT -1 COMMENT '經度',
        `altitude` DOUBLE NOT NULL DEFAULT -1 COMMENT '海拔(公尺)',
        
        `accuracy_horizontal` DOUBLE NOT NULL DEFAULT -1 COMMENT '水平準確度(公尺)',
        `accuracy_vertical` DOUBLE NOT NULL DEFAULT -1 COMMENT '垂直準確度(公尺)',
        `speed` DOUBLE NOT NULL DEFAULT -1 COMMENT '移動速度(公尺/秒)',

        `updated_at` datetime NOT NULL DEFAULT '" . date ('Y-m-d H:i:s') . "' COMMENT '更新時間',
        `created_at` datetime NOT NULL DEFAULT '" . date ('Y-m-d H:i:s') . "' COMMENT '新增時間',
        PRIMARY KEY (`id`),
        KEY `polyline_id_index` (`polyline_id`),
        KEY `polyline_id_accuracy_horizontal_index` (`polyline_id`, `accuracy_horizontal`),
        FOREIGN KEY (`polyline_id`) REFERENCES `polylines` (`id`) ON DELETE CASCADE
      ) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;"
    );
  }
  public function down () {
    $this->db->query (
      "DROP TABLE `paths`;"
    );
  }
}