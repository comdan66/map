<?php defined('BASEPATH') OR exit('No direct script access allowed');

/**
 * @author      OA Wu <comdan66@gmail.com>
 * @copyright   Copyright (c) 2015 OA Wu Design
 */

class Migration_Edit_events extends CI_Migration {
  public function up () {
    $this->db->query (
      "ALTER TABLE `events` ADD `length` DOUBLE NOT NULL COMMENT '總長度(m)' AFTER `cover`;"
    );
    $this->db->query (
      "ALTER TABLE `events` ADD `run_time` int(11) NOT NULL DEFAULT 0 COMMENT '時間(s)' AFTER `length`;"
    );
    $this->db->query (
      "CREATE INDEX `is_visibled_index` ON `events` (`is_visibled`);"
    );
  }
  public function down () {
    $this->db->query (
      "ALTER TABLE `events` DROP INDEX `is_visibled_index`;"
    );
    $this->db->query (
      "ALTER TABLE `events` DROP COLUMN `run_time`;"
    );
    $this->db->query (
      "ALTER TABLE `events` DROP COLUMN `length`;"
    );
  }
}