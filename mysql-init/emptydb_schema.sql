-- emptydbのテーブル定義
-- このファイルはコンテナ起動時に自動実行されます

-- データベースを選択
USE emptydb;

-- 文字セット設定
SET NAMES utf8mb4;
SET CHARACTER SET utf8mb4;

-- 外部キーチェックを一時的に無効化
SET FOREIGN_KEY_CHECKS=0;

-- プロジェクトテーブル
DROP TABLE IF EXISTS `project`;
CREATE TABLE `project` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `name` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  UNIQUE KEY `code` (`code`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 選択肢カテゴリーテーブル
DROP TABLE IF EXISTS `choice_category`;
CREATE TABLE `choice_category` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `project_id` int unsigned NOT NULL,
  `category_id` int unsigned NOT NULL,
  `name` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  UNIQUE KEY `project_id_category_id` (`project_id`,`category_id`),
  CONSTRAINT `FK_category_project` FOREIGN KEY (`project_id`) REFERENCES `project` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 選択肢属性テーブル
DROP TABLE IF EXISTS `choice_attribute`;
CREATE TABLE `choice_attribute` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `project_id` int unsigned NOT NULL DEFAULT '0',
  `attribute_id` int unsigned NOT NULL DEFAULT '0',
  `name` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  UNIQUE KEY `project_id` (`project_id`,`attribute_id`),
  CONSTRAINT `FK_choice_attribute_project` FOREIGN KEY (`project_id`) REFERENCES `project` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 選択肢テーブル
DROP TABLE IF EXISTS `choice`;
CREATE TABLE `choice` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT '主キー',
  `project_id` int unsigned NOT NULL DEFAULT '0' COMMENT '案件ID',
  `choice_id` int unsigned NOT NULL DEFAULT '0' COMMENT '見栄え目的',
  `attribute_id` int unsigned NOT NULL DEFAULT '0' COMMENT '属性ID',
  `sort_order` int unsigned NOT NULL DEFAULT '0',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'ラベル',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `project_id` (`project_id`,`choice_id`) USING BTREE,
  KEY `FK_choice_choice_attribute` (`attribute_id`),
  CONSTRAINT `FK__project` FOREIGN KEY (`project_id`) REFERENCES `project` (`id`),
  CONSTRAINT `FK_choice_choice_attribute` FOREIGN KEY (`attribute_id`) REFERENCES `choice_attribute` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='選択肢テーブル';

-- 選択肢グループテーブル
DROP TABLE IF EXISTS `choice_group`;
CREATE TABLE `choice_group` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `project_id` int unsigned NOT NULL,
  `group_id` int unsigned NOT NULL,
  `name` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  UNIQUE KEY `project_id_group_id` (`project_id`,`group_id`),
  CONSTRAINT `FK__project1` FOREIGN KEY (`project_id`) REFERENCES `project` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 選択肢グループリレーションテーブル
DROP TABLE IF EXISTS `choice_group_relation`;
CREATE TABLE `choice_group_relation` (
  `group_id` int unsigned NOT NULL DEFAULT (0),
  `choice_id` int unsigned NOT NULL DEFAULT (0),
  PRIMARY KEY (`group_id`,`choice_id`),
  KEY `FK__choice` (`choice_id`),
  CONSTRAINT `FK__choice` FOREIGN KEY (`choice_id`) REFERENCES `choice` (`id`),
  CONSTRAINT `FK__choice_group` FOREIGN KEY (`group_id`) REFERENCES `choice_group` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 選択肢ファミリーテーブル
DROP TABLE IF EXISTS `choice_family`;
CREATE TABLE `choice_family` (
  `parent_choice_id` int unsigned NOT NULL DEFAULT (0),
  `child_choiceid` int unsigned NOT NULL DEFAULT (0),
  PRIMARY KEY (`parent_choice_id`,`child_choiceid`),
  KEY `FK_choice_family_choice_2` (`child_choiceid`),
  CONSTRAINT `FK_choice_family_choice` FOREIGN KEY (`parent_choice_id`) REFERENCES `choice` (`id`),
  CONSTRAINT `FK_choice_family_choice_2` FOREIGN KEY (`child_choiceid`) REFERENCES `choice` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- データカテゴリー属性階層テーブル
DROP TABLE IF EXISTS `data_category_attribute_hierarchy`;
CREATE TABLE `data_category_attribute_hierarchy` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `category_id` int unsigned NOT NULL DEFAULT '0',
  `attribute_id` int unsigned NOT NULL DEFAULT '0',
  `hierarchy_level` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `FK__choice_category` (`category_id`),
  KEY `FK__choice_attribute` (`attribute_id`),
  CONSTRAINT `FK__choice_attribute` FOREIGN KEY (`attribute_id`) REFERENCES `choice_attribute` (`id`),
  CONSTRAINT `FK__choice_category` FOREIGN KEY (`category_id`) REFERENCES `choice_category` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 設問テーブル
DROP TABLE IF EXISTS `question`;
CREATE TABLE `question` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `project_id` int unsigned NOT NULL,
  `question_id` int unsigned NOT NULL,
  `category_id` int unsigned NOT NULL,
  `name` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  UNIQUE KEY `project_id` (`project_id`,`question_id`),
  KEY `FK_question_choice_category` (`category_id`),
  CONSTRAINT `FK__project2` FOREIGN KEY (`project_id`) REFERENCES `project` (`id`),
  CONSTRAINT `FK_question_choice_category` FOREIGN KEY (`category_id`) REFERENCES `choice_category` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 画面基本設定テーブル
DROP TABLE IF EXISTS `screen_base_config`;
CREATE TABLE `screen_base_config` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `project_id` int unsigned NOT NULL,
  `screen_number` int unsigned NOT NULL,
  `question_id` int unsigned NOT NULL,
  `sort_order` int unsigned NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `project_id` (`project_id`,`screen_number`,`question_id`),
  KEY `FK__question` (`question_id`),
  CONSTRAINT `FK__project3` FOREIGN KEY (`project_id`) REFERENCES `project` (`id`),
  CONSTRAINT `FK__question` FOREIGN KEY (`question_id`) REFERENCES `question` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='各画面で無条件に表示される基本設問を定義。この設問は回答状況に関わらず必ず表示される。';

-- 動的設問ルールテーブル
DROP TABLE IF EXISTS `dynamic_question_rules`;
CREATE TABLE `dynamic_question_rules` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `project_id` int unsigned NOT NULL DEFAULT (0),
  `name` int unsigned NOT NULL DEFAULT (0),
  `target_screen` int unsigned NOT NULL DEFAULT (0),
  `add_question_id` int unsigned NOT NULL DEFAULT (0),
  `insert_position` int unsigned NOT NULL DEFAULT (0),
  `reference_question_id` int unsigned NOT NULL DEFAULT (0),
  `priority` int unsigned NOT NULL DEFAULT (0),
  PRIMARY KEY (`id`),
  KEY `FK__project4` (`project_id`),
  KEY `FK__question2` (`add_question_id`),
  KEY `FK__question3` (`reference_question_id`),
  CONSTRAINT `FK__project4` FOREIGN KEY (`project_id`) REFERENCES `project` (`id`),
  CONSTRAINT `FK__question2` FOREIGN KEY (`add_question_id`) REFERENCES `question` (`id`),
  CONSTRAINT `FK__question3` FOREIGN KEY (`reference_question_id`) REFERENCES `question` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 動的設問条件テーブル
DROP TABLE IF EXISTS `dynamic_question_conditions`;
CREATE TABLE `dynamic_question_conditions` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `rule_id` int unsigned NOT NULL,
  `condition_question` int unsigned NOT NULL,
  `condition_operator` enum('Y','N') COLLATE utf8mb4_unicode_ci NOT NULL,
  `logical_operator` enum('Y','N') COLLATE utf8mb4_unicode_ci NOT NULL,
  `condition_group` tinyint unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FK__dynamic_question_rules` (`rule_id`),
  CONSTRAINT `FK__dynamic_question_rules` FOREIGN KEY (`rule_id`) REFERENCES `dynamic_question_rules` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 動的設問条件値テーブル
DROP TABLE IF EXISTS `dynamic_question_condition_values`;
CREATE TABLE `dynamic_question_condition_values` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `condition_id` int unsigned NOT NULL,
  `value` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  KEY `FK__dynamic_question_conditions` (`condition_id`),
  CONSTRAINT `FK__dynamic_question_conditions` FOREIGN KEY (`condition_id`) REFERENCES `dynamic_question_conditions` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- セッションテーブル
DROP TABLE IF EXISTS `session`;
CREATE TABLE `session` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `project_id` int unsigned NOT NULL DEFAULT (0),
  `session_key` char(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `is_completed` tinyint unsigned NOT NULL DEFAULT (0),
  PRIMARY KEY (`id`),
  UNIQUE KEY `project_id` (`project_id`,`session_key`),
  CONSTRAINT `FK_session_project` FOREIGN KEY (`project_id`) REFERENCES `project` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 回答テーブル
DROP TABLE IF EXISTS `answer`;
CREATE TABLE `answer` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `session_id` int unsigned NOT NULL DEFAULT (0),
  `question_id` int unsigned NOT NULL DEFAULT (0),
  PRIMARY KEY (`id`),
  KEY `FK_answer_session` (`session_id`),
  KEY `FK_answer_question` (`question_id`),
  CONSTRAINT `FK_answer_question` FOREIGN KEY (`question_id`) REFERENCES `question` (`id`),
  CONSTRAINT `FK_answer_session` FOREIGN KEY (`session_id`) REFERENCES `session` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 回答値テーブル
DROP TABLE IF EXISTS `answer_values`;
CREATE TABLE `answer_values` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `answer_id` int unsigned NOT NULL DEFAULT (0),
  `value` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `answer_order` int unsigned NOT NULL DEFAULT (0),
  PRIMARY KEY (`id`),
  KEY `FK__answer` (`answer_id`),
  CONSTRAINT `FK__answer` FOREIGN KEY (`answer_id`) REFERENCES `answer` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ビュー構造テーブル
DROP TABLE IF EXISTS `view_structure`;
CREATE TABLE `view_structure` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ビュー構造表示テーブル
DROP TABLE IF EXISTS `view_structure_display`;
CREATE TABLE `view_structure_display` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `view_structure_id` int unsigned NOT NULL DEFAULT (0),
  `attribute_id` int unsigned NOT NULL DEFAULT (0),
  `is_visible` int unsigned NOT NULL DEFAULT (1),
  `show_label` tinyint unsigned NOT NULL DEFAULT (0),
  `is_selectable` tinyint unsigned NOT NULL DEFAULT (0),
  PRIMARY KEY (`id`),
  UNIQUE KEY `view_structure_id` (`view_structure_id`,`attribute_id`),
  KEY `attribute_id` (`attribute_id`),
  CONSTRAINT `FK_view_structure_display_view_structure` FOREIGN KEY (`view_structure_id`) REFERENCES `view_structure` (`id`),
  CONSTRAINT `view_structure_display_ibfk_1` FOREIGN KEY (`attribute_id`) REFERENCES `choice_attribute` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ビュー構造ポジションテーブル
DROP TABLE IF EXISTS `view_structure_potision`;
CREATE TABLE `view_structure_potision` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `view_structure_id` int unsigned NOT NULL,
  `attribute_id` int unsigned NOT NULL,
  `choice_id` int unsigned NOT NULL,
  `sort_order` int unsigned NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `view_structure_id` (`view_structure_id`,`attribute_id`,`choice_id`),
  KEY `FK__choice1` (`choice_id`),
  KEY `FK_view_structure_potision_view_structure_display` (`attribute_id`),
  CONSTRAINT `FK__choice1` FOREIGN KEY (`choice_id`) REFERENCES `choice` (`id`),
  CONSTRAINT `FK_view_structure_potision_view_structure_id` FOREIGN KEY (`view_structure_id`) REFERENCES `view_structure` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ビューカテゴリー属性階層テーブル
DROP TABLE IF EXISTS `view_category_attribute_hierarchy`;
CREATE TABLE `view_category_attribute_hierarchy` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `category_id` int unsigned NOT NULL DEFAULT '0',
  `attribute_id` int unsigned NOT NULL DEFAULT '0',
  `hierarchy_level` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `category_id` (`category_id`,`hierarchy_level`),
  KEY `FK_view_category_attribute_hierarchy_choice_attribute` (`attribute_id`),
  CONSTRAINT `FK_view_category_attribute_hierarchy_category` FOREIGN KEY (`category_id`) REFERENCES `choice_category` (`id`),
  CONSTRAINT `FK_view_category_attribute_hierarchy_choice_attribute` FOREIGN KEY (`attribute_id`) REFERENCES `choice_attribute` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 外部キーチェックを再度有効化
SET FOREIGN_KEY_CHECKS=1;
