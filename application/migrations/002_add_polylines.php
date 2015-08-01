<?php defined('BASEPATH') OR exit('No direct script access allowed');

/**
 * @author      OA Wu <comdan66@gmail.com>
 * @copyright   Copyright (c) 2015 OA Wu Design
 */

class Migration_Add_polylines extends CI_Migration {
  public function up () {
    $this->db->query (
      "CREATE TABLE `polylines` (
        `id` int(11) NOT NULL AUTO_INCREMENT,
        `event_id` int(11) NOT NULL,

        `latitude` DOUBLE NOT NULL COMMENT '緯度',
        `longitude` DOUBLE NOT NULL COMMENT '經度',
        `altitude` DOUBLE NOT NULL COMMENT '海拔(公尺)',
        `accuracy_horizontal` DOUBLE NOT NULL COMMENT '水平準確度(公尺)',
        `accuracy_vertical` DOUBLE NOT NULL COMMENT '垂直準確度(公尺)',
        `speed` DOUBLE NOT NULL COMMENT '移動速度(公尺/秒)',
        
        `pic` varchar(100) COLLATE utf8_unicode_ci NOT NULL COMMENT '靜態圖檔',

        `updated_at` datetime NOT NULL DEFAULT '" . date ('Y-m-d H:i:s') . "' COMMENT '更新時間',
        `created_at` datetime NOT NULL DEFAULT '" . date ('Y-m-d H:i:s') . "' COMMENT '新增時間',
        PRIMARY KEY (`id`),
        KEY `event_id_index` (`event_id`),
        FOREIGN KEY (`event_id`) REFERENCES `events` (`id`) ON DELETE CASCADE
      ) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;"
    );
  }
  public function down () {
    $this->db->query (
      "DROP TABLE `polylines`;"
    );
  }
}