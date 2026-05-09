/*
 Navicat Premium Data Transfer

 Source Server         : localhost
 Source Server Type    : MySQL
 Source Server Version : 50722
 Source Host           : localhost:3306
 Source Schema         : wy_db

 Target Server Type    : MySQL
 Target Server Version : 50722
 File Encoding         : 65001

 Date: 07/05/2026 11:18:57
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for custom_question
-- ----------------------------
DROP TABLE IF EXISTS `custom_question`;
CREATE TABLE `custom_question`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `topic_id` bigint(20) NOT NULL,
  `type` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'opening',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `sort_order` int(11) NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_topic_id`(`topic_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '鑷畾涔夐棶棰? ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of custom_question
-- ----------------------------

-- ----------------------------
-- Table structure for custom_scenario
-- ----------------------------
DROP TABLE IF EXISTS `custom_scenario`;
CREATE TABLE `custom_scenario`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NOT NULL,
  `title` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_user_id`(`user_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '鑷畾涔夊満鏅? ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of custom_scenario
-- ----------------------------

-- ----------------------------
-- Table structure for custom_topic
-- ----------------------------
DROP TABLE IF EXISTS `custom_topic`;
CREATE TABLE `custom_topic`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `scenario_id` bigint(20) NOT NULL,
  `title` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `title_sub` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `recommend` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL,
  `sort_order` int(11) NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_scenario_id`(`scenario_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '鑷畾涔夎瘽棰? ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of custom_topic
-- ----------------------------

-- ----------------------------
-- Table structure for family_member
-- ----------------------------
DROP TABLE IF EXISTS `family_member`;
CREATE TABLE `family_member`  (
  `id` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `user_id` bigint(20) NOT NULL COMMENT '鎵€灞濰5鐢ㄦ埛',
  `name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `role` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT 'parent',
  `avatar` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `sort_order` int(11) NULL DEFAULT 0,
  `linked_user_id` bigint(20) NULL DEFAULT NULL COMMENT '鍏宠仈鐨?H5 璐﹀彿 ID锛屽叧鑱斿悗鍙屾柟鍏变韩鑱婂ぉ瀹?,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '瀹跺涵鎴愬憳' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of family_member
-- ----------------------------
INSERT INTO `family_member` VALUES ('m1', 1, 'Grandpa', 'parent', '馃懘', 1, NULL);
INSERT INTO `family_member` VALUES ('m1063e7', 5, '123', 'parent', '馃懁', 1, 2);
INSERT INTO `family_member` VALUES ('m2', 1, 'Mom', 'parent', '馃懇', 2, NULL);
INSERT INTO `family_member` VALUES ('m3', 1, 'Me (You)', 'child', '馃', 3, NULL);

-- ----------------------------
-- Table structure for h5_user
-- ----------------------------
DROP TABLE IF EXISTS `h5_user`;
CREATE TABLE `h5_user`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '鏄电О',
  `email` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `password` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `identity` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'child' COMMENT 'parent/child',
  `status` tinyint(4) NOT NULL DEFAULT 1,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `email`(`email`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = 'H5鐢ㄦ埛' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of h5_user
-- ----------------------------
INSERT INTO `h5_user` VALUES (2, 'Little Ming', 'ming@example.com', 'pass1234', 'child', 1, '2026-04-20 14:27:25');
INSERT INTO `h5_user` VALUES (3, 'Dad', 'dad@example.com', 'pass1234', 'parent', 1, '2026-04-20 14:27:25');
INSERT INTO `h5_user` VALUES (4, '123123', '633333333@qq.com', '123456789', 'parent', 1, '2026-04-20 15:15:43');
INSERT INTO `h5_user` VALUES (5, '630155515@qq.com', '630155515@qq.com', '123456', 'child', 1, '2026-04-23 18:12:42');

-- ----------------------------
-- Table structure for mood_log
-- ----------------------------
DROP TABLE IF EXISTS `mood_log`;
CREATE TABLE `mood_log`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `member_id` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `user_id` bigint(20) NOT NULL,
  `mood_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `note` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `log_date` date NOT NULL,
  `log_time` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_member_date`(`member_id`, `log_date`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 19 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '蹇冩儏鎵撳崱' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of mood_log
-- ----------------------------
INSERT INTO `mood_log` VALUES (1, 'm1', 1, 'peaceful', 'Had a lovely morning walk today.', '2026-04-20', '08:30', '2026-04-20 14:27:25');
INSERT INTO `mood_log` VALUES (2, 'm2', 1, 'grateful', 'Feeling so blessed with everyone around.', '2026-04-20', '12:15', '2026-04-20 14:27:25');
INSERT INTO `mood_log` VALUES (3, 'm1', 1, 'peaceful', NULL, '2026-04-19', '09:00', '2026-04-20 14:27:25');
INSERT INTO `mood_log` VALUES (4, 'm1', 1, 'happy', NULL, '2026-04-18', '08:45', '2026-04-20 14:27:25');
INSERT INTO `mood_log` VALUES (5, 'm1', 1, 'tired', NULL, '2026-04-17', '21:00', '2026-04-20 14:27:25');
INSERT INTO `mood_log` VALUES (6, 'm1', 1, 'peaceful', NULL, '2026-04-16', '08:30', '2026-04-20 14:27:25');
INSERT INTO `mood_log` VALUES (7, 'm1', 1, 'grateful', NULL, '2026-04-15', '20:00', '2026-04-20 14:27:25');
INSERT INTO `mood_log` VALUES (8, 'm1', 1, 'happy', NULL, '2026-04-14', '09:15', '2026-04-20 14:27:25');
INSERT INTO `mood_log` VALUES (9, 'm2', 1, 'grateful', NULL, '2026-04-19', '12:00', '2026-04-20 14:27:25');
INSERT INTO `mood_log` VALUES (10, 'm2', 1, 'happy', NULL, '2026-04-18', '11:30', '2026-04-20 14:27:25');
INSERT INTO `mood_log` VALUES (11, 'm2', 1, 'anxious', NULL, '2026-04-17', '10:00', '2026-04-20 14:27:25');
INSERT INTO `mood_log` VALUES (12, 'm2', 1, 'peaceful', NULL, '2026-04-16', '12:30', '2026-04-20 14:27:25');
INSERT INTO `mood_log` VALUES (13, 'm2', 1, 'happy', NULL, '2026-04-15', '11:00', '2026-04-20 14:27:25');
INSERT INTO `mood_log` VALUES (14, 'm2', 1, 'excited', NULL, '2026-04-14', '14:00', '2026-04-20 14:27:25');
INSERT INTO `mood_log` VALUES (15, 'm3', 4, 'peaceful', '', '2026-04-20', '15:20', '2026-04-20 15:20:39');
INSERT INTO `mood_log` VALUES (16, 'm3', 4, 'happy', '123', '2026-04-20', '15:23', '2026-04-20 15:23:32');
INSERT INTO `mood_log` VALUES (17, 'm3', 4, 'happy', '123', '2026-04-20', '15:23', '2026-04-20 15:23:48');
INSERT INTO `mood_log` VALUES (18, 'm3', 5, 'anxious', '', '2026-04-23', '21:53', '2026-04-23 21:53:53');

-- ----------------------------
-- Table structure for mood_type
-- ----------------------------
DROP TABLE IF EXISTS `mood_type`;
CREATE TABLE `mood_type`  (
  `id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `emoji` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `label` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `color` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `tip` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '蹇冩儏绫诲瀷' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of mood_type
-- ----------------------------
INSERT INTO `mood_type` VALUES ('anxious', '馃槦', 'A Bit Worried', '#CFD8DC', 'Be gentle. Listen more, speak less. Just knowing you\'re there helps.');
INSERT INTO `mood_type` VALUES ('excited', '馃帀', 'Excited', '#FFE0B2', 'Match their energy! Ask what\'s got them excited and celebrate together.');
INSERT INTO `mood_type` VALUES ('grateful', '馃グ', 'Grateful', '#FCE4EC', 'They\'re feeling appreciative. Share something you\'re thankful for too.');
INSERT INTO `mood_type` VALUES ('happy', '馃槉', 'Happy', '#FFF9C4', 'Great time to share what made them smile 鈥?ask about the highlight of their day!');
INSERT INTO `mood_type` VALUES ('peaceful', '馃槍', 'Peaceful', '#B2EBF2', 'They\'re in a calm state. Perfect for a gentle, relaxed chat.');
INSERT INTO `mood_type` VALUES ('tired', '馃槾', 'Tired', '#D1C4E9', 'Give them space. A simple \"I\'m here\" or a quiet moment together goes a long way.');

-- ----------------------------
-- Table structure for report_timeline
-- ----------------------------
DROP TABLE IF EXISTS `report_timeline`;
CREATE TABLE `report_timeline`  (
  `id` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `user_id` bigint(20) NOT NULL,
  `event_date` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `place` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `title` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `detail` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL,
  `type` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'topic' COMMENT 'topic/browse/report',
  `sort_order` int(11) NOT NULL DEFAULT 0,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '鎶ュ憡鏃堕棿绾? ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of report_timeline
-- ----------------------------
INSERT INTO `report_timeline` VALUES ('r1', 1, '12 Apr 2026', 'Home 路 Dinner', 'Topic explored: Taste of Childhood', 'Completed 3 of 4 opening questions with a grandparent.', 'topic', 1, '2026-04-20 14:27:26');
INSERT INTO `report_timeline` VALUES ('r2', 1, '10 Apr 2026', 'Neighbourhood Walk', 'Browsed: Memories on the Road', 'Viewed scenario cards and topic suggestions.', 'browse', 2, '2026-04-20 14:27:26');
INSERT INTO `report_timeline` VALUES ('r3', 1, '6 Apr 2026', 'Online', 'Mood Board summary generated', 'Weekly mood report preview.', 'report', 3, '2026-04-20 14:27:26');
INSERT INTO `report_timeline` VALUES ('r4', 1, '28 Mar 2026', 'On the road', 'Topic saved: Snacks on the Road', 'Bookmarked 1 deep-dive question.', 'topic', 4, '2026-04-20 14:27:26');

-- ----------------------------
-- Table structure for scenario
-- ----------------------------
DROP TABLE IF EXISTS `scenario`;
CREATE TABLE `scenario`  (
  `id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `title` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `subtitle` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `icon` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `cover` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `topic_count` int(11) NOT NULL DEFAULT 0,
  `sort_order` int(11) NOT NULL DEFAULT 0,
  `enabled` tinyint(4) NOT NULL DEFAULT 1,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '鍦烘櫙' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of scenario
-- ----------------------------
INSERT INTO `scenario` VALUES ('cat-events', 'Events & Experiences', 'Relive and share life experiences together', '馃幆', 'https://images.unsplash.com/photo-1540575467063-178a50c2df87?w=800&q=80', 23, 10, 1, '2026-04-20 14:27:25');
INSERT INTO `scenario` VALUES ('cat-object', 'Objects & Interests', 'Share stories behind things that matter', '馃摝', 'https://images.unsplash.com/photo-1516483638261-f4dbaf036963?w=800&q=80', 16, 9, 1, '2026-04-20 14:27:25');
INSERT INTO `scenario` VALUES ('cat-people', 'People & Relationships', 'Discuss inspiring people in your lives', '馃懃', 'https://images.unsplash.com/photo-1529156069898-49953e39b3ac?w=800&q=80', 10, 7, 1, '2026-04-20 14:27:25');
INSERT INTO `scenario` VALUES ('cat-place', 'Places & Occasions', 'Explore memorable places and moments', '馃椇', 'https://images.unsplash.com/photo-1501854140801-50d01698950b?w=800&q=80', 4, 8, 1, '2026-04-20 14:27:25');
INSERT INTO `scenario` VALUES ('s1', 'Mealtime Together', 'Stories over shared food', '馃嵔', 'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=800&q=80', 3, 1, 1, '2026-04-20 14:27:25');
INSERT INTO `scenario` VALUES ('s2', 'Watching TV / Videos', 'Connecting through shows', '馃摵', 'https://images.unsplash.com/photo-1574375927938-d5a98e8ffe85?w=800&q=80', 3, 2, 1, '2026-04-20 14:27:25');
INSERT INTO `scenario` VALUES ('s3', 'Walking Outdoors', 'Conversations on the move', '馃尶', 'https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=800&q=80', 3, 3, 1, '2026-04-20 14:27:25');
INSERT INTO `scenario` VALUES ('s4', 'Car Rides & Travel', 'Stories from the journey', '馃殫', 'https://images.unsplash.com/photo-1469854523086-cc02fe5d8800?w=800&q=80', 3, 4, 1, '2026-04-20 14:27:25');
INSERT INTO `scenario` VALUES ('s5', 'Cooking & Chores', 'Bonding through daily tasks', '馃嵆', 'https://images.unsplash.com/photo-1556910103-1c02745aae4d?w=800&q=80', 3, 5, 1, '2026-04-20 14:27:25');
INSERT INTO `scenario` VALUES ('s6', 'Resting at Home', 'Quiet moments together', '馃彔', 'https://images.unsplash.com/photo-1586023492125-27b2c045efd7?w=800&q=80', 3, 6, 1, '2026-04-20 14:27:25');

-- ----------------------------
-- Table structure for topic
-- ----------------------------
DROP TABLE IF EXISTS `topic`;
CREATE TABLE `topic`  (
  `id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `scenario_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `title` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `title_sub` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `recommend` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL,
  `sort_order` int(11) NOT NULL DEFAULT 0,
  `enabled` tinyint(4) NOT NULL DEFAULT 1,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_scenario_id`(`scenario_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '璇濋' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of topic
-- ----------------------------
INSERT INTO `topic` VALUES ('ev-apology', 'cat-events', 'When Someone Apologised', 'Describe a time when someone apologised to you', 'Apologies are cultural and deeply personal 鈥?exploring how different generations handle \"sorry\" opens up rich emotional conversation.', 16, 1, '2026-04-20 14:27:25');
INSERT INTO `topic` VALUES ('ev-bad-concert', 'cat-events', 'A Music Event You Didn\'t Enjoy', 'Describe a music event that you didn\'t enjoy', 'Disagreements about music are fun and harmless 鈥?this topic leads to lively generational debates about taste.', 21, 1, '2026-04-20 14:27:25');
INSERT INTO `topic` VALUES ('ev-broke-something', 'cat-events', 'When You Broke Something', 'Describe a time when you broke something', 'Oops moments are universally relatable 鈥?comparing how generations handle breakage and repairs sparks laughter and wisdom.', 2, 1, '2026-04-20 14:27:25');
INSERT INTO `topic` VALUES ('ev-decision', 'cat-events', 'A Decision Made Together', 'Describe an important decision made with help from others', 'Decision-making is deeply personal yet shaped by community 鈥?sharing experiences reveals how generations approach life choices differently.', 3, 1, '2026-04-20 14:27:25');
INSERT INTO `topic` VALUES ('ev-exciting-first', 'cat-events', 'An Exciting First', 'Describe an exciting activity you tried for the first time', 'First-time experiences are unforgettable 鈥?sharing them sparks enthusiasm and builds connections across generations.', 6, 1, '2026-04-20 14:27:25');
INSERT INTO `topic` VALUES ('ev-family-dinner', 'cat-events', 'A Special Family Dinner', 'Describe a great dinner you enjoyed with friends or family', 'Family meals are at the heart of Chinese culture 鈥?this topic naturally bridges generations through food and togetherness.', 17, 1, '2026-04-20 14:27:25');
INSERT INTO `topic` VALUES ('ev-foreign-language', 'cat-events', 'Speaking a Foreign Language', 'Describe the first time you talked in a foreign language', 'Language learning experiences vary hugely across generations 鈥?sharing them reveals both the challenges and joys of communication.', 14, 1, '2026-04-20 14:27:25');
INSERT INTO `topic` VALUES ('ev-gave-advice', 'cat-events', 'When You Gave Advice', 'Describe a time when you gave advice to others', 'Advice-giving is a powerful act of trust 鈥?discussing when and how to give advice bridges generational wisdom beautifully.', 4, 1, '2026-04-20 14:27:25');
INSERT INTO `topic` VALUES ('ev-good-service', 'cat-events', 'Great Service', 'Describe a time when you received good service in a shop', 'Service experiences reflect social norms that have shifted dramatically across generations 鈥?a rich topic for storytelling.', 8, 1, '2026-04-20 14:27:25');
INSERT INTO `topic` VALUES ('ev-imagination', 'cat-events', 'When You Used Your Imagination', 'Describe a time you needed to use your imagination', 'Imagination is the root of creativity 鈥?comparing how different generations express and value imagination is always illuminating.', 23, 1, '2026-04-20 14:27:25');
INSERT INTO `topic` VALUES ('ev-long-journey', 'cat-events', 'A Long Journey', 'Describe a long journey you had and would like to take again', 'Travel stories are among the richest shared experiences 鈥?revisiting journeys reveals how they shaped us.', 1, 1, '2026-04-20 14:27:25');
INSERT INTO `topic` VALUES ('ev-lost-way', 'cat-events', 'Getting Lost', 'Describe an occasion when you lost your way', 'Getting lost is both stressful and memorable 鈥?comparing how different generations navigated (literally and metaphorically) is fascinating.', 15, 1, '2026-04-20 14:27:25');
INSERT INTO `topic` VALUES ('ev-movie', 'cat-events', 'A Film You Enjoyed', 'Describe a movie you watched and enjoyed recently', 'Movies are a universal language 鈥?comparing films across generations opens up rich conversations about values, heroes and culture.', 22, 1, '2026-04-20 14:27:25');
INSERT INTO `topic` VALUES ('ev-positive-change', 'cat-events', 'A Positive Change', 'Describe a positive change you made recently in your daily routine', 'Change and growth are lifelong processes 鈥?comparing how we evolve resonates deeply across all ages.', 7, 1, '2026-04-20 14:27:25');
INSERT INTO `topic` VALUES ('ev-power-cut', 'cat-events', 'When the Lights Went Out', 'Describe a time when the electricity suddenly went off', 'Power cuts are memorable events 鈥?comparing reactions across generations reveals how much (or little) we rely on electricity.', 5, 1, '2026-04-20 14:27:25');
INSERT INTO `topic` VALUES ('ev-proud-family', 'cat-events', 'Proud of a Family Member', 'Describe a time when you felt proud of a family member', 'Pride in family is universal and deeply meaningful 鈥?sharing these moments builds connection and affirms what we value most.', 19, 1, '2026-04-20 14:27:25');
INSERT INTO `topic` VALUES ('ev-social-media', 'cat-events', 'Something Interesting on Social Media', 'Describe a time you saw something interesting on social media', 'Social media is a generational dividing line 鈥?comparing experiences of it can be both enlightening and entertaining.', 12, 1, '2026-04-20 14:27:25');
INSERT INTO `topic` VALUES ('ev-speech', 'cat-events', 'A Speech You Gave', 'Describe a talk you gave to a group of people', 'Public speaking is a universal challenge 鈥?comparing how we communicate across generations uncovers shared vulnerabilities and growth.', 9, 1, '2026-04-20 14:27:25');
INSERT INTO `topic` VALUES ('ev-story-read', 'cat-events', 'A Story You Read Recently', 'Describe a story (fairy tale, etc.) you have read recently', 'Stories and storytelling are timeless 鈥?comparing the stories that shaped each generation is both revealing and touching.', 18, 1, '2026-04-20 14:27:25');
INSERT INTO `topic` VALUES ('ev-told-truth', 'cat-events', 'Telling an Important Truth', 'Describe a time when you told your friend an important truth', 'Honesty is a core value that generations sometimes define differently 鈥?this topic opens meaningful conversations about trust.', 13, 1, '2026-04-20 14:27:25');
INSERT INTO `topic` VALUES ('ev-unusual-meal', 'cat-events', 'An Unusual Meal', 'Describe an unusual meal you had', 'Food adventures connect us to culture and memory 鈥?sharing unusual meals often leads to funny and vivid stories.', 10, 1, '2026-04-20 14:27:25');
INSERT INTO `topic` VALUES ('ev-vehicle-trip', 'cat-events', 'A Vehicle Trip', 'Describe a bicycle / motorcycle / car trip you would like to go on', 'Road trips and vehicle journeys hold memories for every generation 鈥?this topic sparks stories of freedom, adventure and change.', 20, 1, '2026-04-20 14:27:25');
INSERT INTO `topic` VALUES ('ev-waiting', 'cat-events', 'Waiting for Something Special', 'Describe a time when you waited for something important', 'Patience and anticipation mean different things to different generations 鈥?this topic opens up conversations about values and expectations.', 11, 1, '2026-04-20 14:27:25');
INSERT INTO `topic` VALUES ('ob-app', 'cat-object', 'A Favourite App', 'Describe an app or program you use on your phone or computer', 'Apps are a generational dividing line 鈥?comparing how different family members use technology sparks lively and fun discussion.', 14, 1, '2026-04-20 14:27:25');
INSERT INTO `topic` VALUES ('ob-book', 'cat-object', 'A Useful Book', 'Describe a book you read that you found useful', 'Books have shaped every generation differently 鈥?sharing favourite reads opens wonderful conversations about knowledge and wisdom.', 3, 1, '2026-04-20 14:27:25');
INSERT INTO `topic` VALUES ('ob-building', 'cat-object', 'An Interesting Building', 'Describe an interesting building you saw during a trip', 'Architecture and travel connect personal history to culture 鈥?sharing discoveries from travels is naturally engaging across ages.', 9, 1, '2026-04-20 14:27:25');
INSERT INTO `topic` VALUES ('ob-dream-job', 'cat-object', 'Your Dream Job', 'Describe your perfect job', 'Career aspirations reveal generational shifts in values 鈥?comparing dreams across ages opens honest and meaningful conversations.', 12, 1, '2026-04-20 14:27:25');
INSERT INTO `topic` VALUES ('ob-family-thing', 'cat-object', 'Something Important to the Family', 'Describe something important your family has kept for a long time', 'Family treasures carry emotional weight 鈥?sharing their stories is a beautiful way to pass down family history.', 15, 1, '2026-04-20 14:27:25');
INSERT INTO `topic` VALUES ('ob-habit', 'cat-object', 'A Good Habit from a Friend', 'Describe a good habit your friend has that you want to develop', 'Habits shape character 鈥?discussing good habits is a gentle, positive way to share life lessons between generations.', 10, 1, '2026-04-20 14:27:25');
INSERT INTO `topic` VALUES ('ob-invention', 'cat-object', 'A Useful Invention', 'Describe an invention that is useful in your daily life', 'Comparing the inventions that shaped different eras is a fascinating way to appreciate change across generations.', 1, 1, '2026-04-20 14:27:25');
INSERT INTO `topic` VALUES ('ob-old-thing', 'cat-object', 'A Family Heirloom', 'Describe an important old thing your family has kept', 'Family heirlooms are living stories 鈥?every item holds history that bridges the gap between generations.', 5, 1, '2026-04-20 14:27:25');
INSERT INTO `topic` VALUES ('ob-overspend', 'cat-object', 'An Unexpected Expense', 'Describe an item on which you spent more than expected', 'Money habits differ greatly across generations 鈥?this topic opens honest conversations about spending, saving and values.', 16, 1, '2026-04-20 14:27:25');
INSERT INTO `topic` VALUES ('ob-science', 'cat-object', 'A Science Subject', 'Describe an area of science you are interested in', 'Science curiosity is ageless 鈥?exploring what each generation found fascinating reveals how knowledge and wonder evolve.', 4, 1, '2026-04-20 14:27:25');
INSERT INTO `topic` VALUES ('ob-story', 'cat-object', 'A Traditional Story', 'Describe an interesting traditional story', 'Traditional stories carry cultural values 鈥?comparing stories across generations reveals how values are passed down.', 6, 1, '2026-04-20 14:27:25');
INSERT INTO `topic` VALUES ('ob-talent', 'cat-object', 'A Talent to Improve', 'Describe a natural talent (sports, music鈥? you want to develop', 'Talking about talent and potential connects generations through shared dreams and experiences of growth.', 7, 1, '2026-04-20 14:27:25');
INSERT INTO `topic` VALUES ('ob-technology', 'cat-object', 'A Cool Technology', 'Describe a piece of technology (not a phone) you would like to own', 'Technology has transformed daily life across generations 鈥?comparing past and present tech is always eye-opening.', 13, 1, '2026-04-20 14:27:25');
INSERT INTO `topic` VALUES ('ob-toy', 'cat-object', 'A Childhood Toy', 'Describe a toy you liked in your childhood', 'Toys are portals to childhood 鈥?sharing toy memories often brings laughter and reveals the values of each era.', 2, 1, '2026-04-20 14:27:25');
INSERT INTO `topic` VALUES ('ob-water-sport', 'cat-object', 'A Water Sport', 'Describe a water sport you would like to try', 'Sports and water evoke summer memories and physical adventures 鈥?great for sharing playful childhood experiences.', 11, 1, '2026-04-20 14:27:25');
INSERT INTO `topic` VALUES ('ob-wild-animal', 'cat-object', 'A Wild Animal', 'Describe a wild animal you want to learn more about', 'Wildlife and nature connect us to the bigger world 鈥?this topic sparks conversations about values, environment and childhood wonder.', 8, 1, '2026-04-20 14:27:25');
INSERT INTO `topic` VALUES ('p-creative-person', 'cat-people', 'A Creative Person', 'Describe a creative person (artist, musician, architect鈥? you admire', 'Creativity means different things to different generations 鈥?this topic sparks rich discussion on art, inspiration and expression.', 3, 1, '2026-04-20 14:27:25');
INSERT INTO `topic` VALUES ('p-drawing-friend', 'cat-people', 'A Friend Who Loves Drawing', 'Describe a friend who loves drawing or painting', 'Art and drawing connect generations 鈥?sharing memories of drawing as a child often brings out touching stories.', 8, 1, '2026-04-20 14:27:25');
INSERT INTO `topic` VALUES ('p-famous-person', 'cat-people', 'A Famous Person to Meet', 'Describe a famous person you would like to meet', 'Imagining meeting a hero sparks wonderful storytelling and reveals what each generation truly values.', 6, 1, '2026-04-20 14:27:25');
INSERT INTO `topic` VALUES ('p-good-friend', 'cat-people', 'An Important Friend', 'Describe a good friend who is important to you', 'Friendship looks very different across generations 鈥?this topic bridges the gap between childhood bonds and adult relationships.', 4, 1, '2026-04-20 14:27:25');
INSERT INTO `topic` VALUES ('p-helpful-person', 'cat-people', 'A Helpful Person', 'Describe a person who often helps others', 'Stories about helping others are universal and cross all generations 鈥?this topic builds warmth and appreciation.', 10, 1, '2026-04-20 14:27:25');
INSERT INTO `topic` VALUES ('p-music-friend', 'cat-people', 'A Friend Who Loves Music', 'Describe a friend who is good at singing or music', 'Music preferences reveal generational gaps beautifully 鈥?this topic often leads to fun comparisons and shared memories.', 5, 1, '2026-04-20 14:27:25');
INSERT INTO `topic` VALUES ('p-nature-person', 'cat-people', 'Someone Who Loves Nature', 'Describe a person who encouraged you to protect nature', 'Environmental values are often passed between generations 鈥?this topic encourages reflection on our shared responsibilities.', 9, 1, '2026-04-20 14:27:25');
INSERT INTO `topic` VALUES ('p-planner', 'cat-people', 'A Great Planner', 'Describe a person who is good at planning', 'Planning habits differ greatly between generations 鈥?this topic opens up honest conversations about life decisions and the future.', 7, 1, '2026-04-20 14:27:25');
INSERT INTO `topic` VALUES ('p-popular-person', 'cat-people', 'A Popular Person', 'Describe a popular person you know', 'Talking about popular people opens discussions on values and social dynamics that span generations.', 1, 1, '2026-04-20 14:27:25');
INSERT INTO `topic` VALUES ('p-sportsperson', 'cat-people', 'An Inspiring Athlete', 'Describe a successful sportsperson you admire', 'Sports figures often inspire cross-generational admiration and spark lively debates about talent vs effort.', 2, 1, '2026-04-20 14:27:25');
INSERT INTO `topic` VALUES ('pl-natural', 'cat-place', 'A Natural Place', 'Describe a natural place (park, mountain鈥? you enjoy', 'Natural places mean different things to different generations 鈥?sharing these memories builds mutual understanding.', 2, 1, '2026-04-20 14:27:25');
INSERT INTO `topic` VALUES ('pl-no-phone', 'cat-place', 'No-Phone Moments', 'Describe an occasion when you were not allowed to use your phone', 'Mobile phone usage is a hot topic between generations 鈥?this leads to fascinating and sometimes funny debates.', 3, 1, '2026-04-20 14:27:25');
INSERT INTO `topic` VALUES ('pl-smiling', 'cat-place', 'When Everyone Was Smiling', 'Describe an occasion when many people were smiling', 'Revisiting joyful moments together is a simple but powerful way to strengthen family bonds.', 4, 1, '2026-04-20 14:27:25');
INSERT INTO `topic` VALUES ('pl-trees', 'cat-place', 'A Place Full of Trees', 'Describe a place with many trees you\'d like to visit', 'Nature and green spaces evoke nostalgia and wonder across ages 鈥?a great way to share childhood memories of the outdoors.', 1, 1, '2026-04-20 14:27:25');
INSERT INTO `topic` VALUES ('t-childhood-food', 's1', 'Taste of Childhood', 'Food memories across generations', 'Food is the most natural conversation starter at the table. Childhood flavours trigger powerful emotions and memories 鈥?and comparing eating habits across generations reveals fascinating differences.', 1, 1, '2026-04-20 14:27:25');
INSERT INTO `topic` VALUES ('t-food-habit', 's1', 'Tastes & Habits', 'Salt, spice, and the things we love', 'From sweet versus savoury to picky eating and wellness routines, generational differences often hold a few surprises.', 3, 1, '2026-04-20 14:27:25');
INSERT INTO `topic` VALUES ('t-show-share', 's2', 'What We Watch', 'Talking about shows and stories', 'Building on what is already on screen makes the conversation feel effortless rather than forced.', 1, 1, '2026-04-20 14:27:25');
INSERT INTO `topic` VALUES ('t-table-news', 's1', 'News at the Table', 'Lighthearted updates from the week', 'Sharing small recent moments is more inviting than formal questions, and makes for easy, warm conversation.', 2, 1, '2026-04-20 14:27:25');
INSERT INTO `topic` VALUES ('t-travel-snack', 's4', 'Snacks on the Road', 'Little bites and big journeys', 'Food and travel memories are a light, cheerful gateway into intergenerational conversation.', 1, 1, '2026-04-20 14:27:25');
INSERT INTO `topic` VALUES ('t-walk-memory', 's3', 'Memories on the Road', 'Places that hold a piece of your heart', 'Walking loosens the body and the mind. Talking about the scenery and old places comes naturally when you are already moving.', 1, 1, '2026-04-20 14:27:25');

-- ----------------------------
-- Table structure for topic_chat_message
-- ----------------------------
DROP TABLE IF EXISTS `topic_chat_message`;
CREATE TABLE `topic_chat_message`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NOT NULL COMMENT 'H5鐢ㄦ埛锛涙紨绀烘父瀹负1',
  `room_key` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '鍏变韩鑱婂ぉ瀹?key',
  `scenario_key` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '璺敱鍦烘櫙 id锛屽 s1銆乧ustom-1',
  `topic_key` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '璇濋 id锛屽唴缃垨鑷畾涔?,
  `sender_type` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'me | family',
  `member_id` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'sender=family 鏃跺搴?family_member.id',
  `sender_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_user_scenario_topic`(`user_id`, `scenario_key`(32), `topic_key`(32)) USING BTREE,
  INDEX `idx_room_key`(`room_key`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '璇濋涓嬪搴璇濇秷鎭? ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of topic_chat_message
-- ----------------------------
INSERT INTO `topic_chat_message` VALUES (1, 1, '1', 's1', 't-food-habit', 'family', 'm1', 'Grandma', 'I still remember when you were little 鈥?you would not touch anything green!', '2026-04-23 15:52:13');
INSERT INTO `topic_chat_message` VALUES (2, 1, '1', 's1', 't-food-habit', 'me', NULL, 'Me', 'Haha, I love greens now! Maybe my taste buds grew up with me.', '2026-04-23 16:52:13');
INSERT INTO `topic_chat_message` VALUES (3, 5, '5', 's1', 't-childhood-food', 'me', NULL, '630155515@qq.com', '123123', '2026-04-23 18:12:53');

-- ----------------------------
-- Table structure for topic_question
-- ----------------------------
DROP TABLE IF EXISTS `topic_question`;
CREATE TABLE `topic_question`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `topic_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `type` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'opening/deep',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `sort_order` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_topic_id`(`topic_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 310 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '璇濋闂' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of topic_question
-- ----------------------------
INSERT INTO `topic_question` VALUES (1, 't-childhood-food', 'opening', 'What was your all-time favourite dish as a child?', 1);
INSERT INTO `topic_question` VALUES (2, 't-childhood-food', 'opening', 'Is there one food that instantly takes you back to your childhood?', 2);
INSERT INTO `topic_question` VALUES (3, 't-childhood-food', 'opening', 'What was the first dish you ever tried to cook yourself?', 3);
INSERT INTO `topic_question` VALUES (4, 't-childhood-food', 'opening', 'What special dishes did the family always make for the New Year?', 4);
INSERT INTO `topic_question` VALUES (5, 't-childhood-food', 'deep', 'How did the quality of food and daily life compare to today?', 1);
INSERT INTO `topic_question` VALUES (6, 't-childhood-food', 'deep', 'Is there a special story behind one of those recipes?', 2);
INSERT INTO `topic_question` VALUES (7, 't-childhood-food', 'deep', 'Which family recipes do you hope will be passed down forever?', 3);
INSERT INTO `topic_question` VALUES (8, 't-table-news', 'opening', 'What was a small thing that made you smile this week?', 1);
INSERT INTO `topic_question` VALUES (9, 't-table-news', 'opening', 'Have you seen anything interesting on the news or online lately?', 2);
INSERT INTO `topic_question` VALUES (10, 't-table-news', 'opening', 'If you could share just one thing with the family right now, what would it be?', 3);
INSERT INTO `topic_question` VALUES (11, 't-table-news', 'deep', 'How has the feeling around family mealtimes changed over the years?', 1);
INSERT INTO `topic_question` VALUES (12, 't-table-news', 'deep', 'Is there something you have been meaning to tell the family but never found the right moment?', 2);
INSERT INTO `topic_question` VALUES (13, 't-food-habit', 'opening', 'Do you prefer rice or noodles?', 1);
INSERT INTO `topic_question` VALUES (14, 't-food-habit', 'opening', 'Is there a food you hated as a child but love now?', 2);
INSERT INTO `topic_question` VALUES (15, 't-food-habit', 'opening', 'Who in the family has the best instinct for seasoning?', 3);
INSERT INTO `topic_question` VALUES (16, 't-food-habit', 'deep', 'How do you balance \"healthy\" with \"delicious\"?', 1);
INSERT INTO `topic_question` VALUES (17, 't-food-habit', 'deep', 'Is there one dish that truly tastes like home to you?', 2);
INSERT INTO `topic_question` VALUES (18, 't-show-share', 'opening', 'Which moment in this show surprised you the most?', 1);
INSERT INTO `topic_question` VALUES (19, 't-show-share', 'opening', 'If you were in that situation, what would you have done?', 2);
INSERT INTO `topic_question` VALUES (20, 't-show-share', 'opening', 'Has anything like that ever happened in our own family?', 3);
INSERT INTO `topic_question` VALUES (21, 't-show-share', 'deep', 'What is the biggest difference between watching TV as a child and watching it today?', 1);
INSERT INTO `topic_question` VALUES (22, 't-show-share', 'deep', 'What does watching TV together as a family mean to you?', 2);
INSERT INTO `topic_question` VALUES (23, 't-walk-memory', 'opening', 'Does this street or path remind you of anything?', 1);
INSERT INTO `topic_question` VALUES (24, 't-walk-memory', 'opening', 'Where did you like to play or hang out as a child?', 2);
INSERT INTO `topic_question` VALUES (25, 't-walk-memory', 'opening', 'Which season do you enjoy walking in the most?', 3);
INSERT INTO `topic_question` VALUES (26, 't-walk-memory', 'deep', 'Is there a particular route that holds a special meaning for you?', 1);
INSERT INTO `topic_question` VALUES (27, 't-walk-memory', 'deep', 'If you could walk one road from your past again, who would you bring?', 2);
INSERT INTO `topic_question` VALUES (28, 't-travel-snack', 'opening', 'What snack do you always bring on a trip?', 1);
INSERT INTO `topic_question` VALUES (29, 't-travel-snack', 'opening', 'What is the most memorable journey you have ever taken?', 2);
INSERT INTO `topic_question` VALUES (30, 't-travel-snack', 'opening', 'Is the food at a service station better, or food packed from home?', 3);
INSERT INTO `topic_question` VALUES (31, 't-travel-snack', 'deep', 'On a trip, do you care more about the scenery or the people you are with?', 1);
INSERT INTO `topic_question` VALUES (32, 't-travel-snack', 'deep', 'Has a journey ever changed the way you see something?', 2);
INSERT INTO `topic_question` VALUES (33, 'p-popular-person', 'opening', 'Why are some students popular in school?', 1);
INSERT INTO `topic_question` VALUES (34, 'p-popular-person', 'opening', 'Is it important for a teacher to be popular?', 2);
INSERT INTO `topic_question` VALUES (35, 'p-popular-person', 'opening', 'Do you think good teachers are always popular among students?', 3);
INSERT INTO `topic_question` VALUES (36, 'p-popular-person', 'deep', 'What are the qualities of being a good teacher?', 1);
INSERT INTO `topic_question` VALUES (37, 'p-popular-person', 'deep', 'Is it easier to become popular nowadays?', 2);
INSERT INTO `topic_question` VALUES (38, 'p-popular-person', 'deep', 'Why do people want to be popular?', 3);
INSERT INTO `topic_question` VALUES (39, 'p-sportsperson', 'opening', 'Should students have physical education and do sports at school?', 1);
INSERT INTO `topic_question` VALUES (40, 'p-sportsperson', 'opening', 'What qualities should an athlete have?', 2);
INSERT INTO `topic_question` VALUES (41, 'p-sportsperson', 'opening', 'Is talent important in sports?', 3);
INSERT INTO `topic_question` VALUES (42, 'p-sportsperson', 'deep', 'Is it easy to identify children\'s talents?', 1);
INSERT INTO `topic_question` VALUES (43, 'p-sportsperson', 'deep', 'What is the most popular sport in your country?', 2);
INSERT INTO `topic_question` VALUES (44, 'p-sportsperson', 'deep', 'Why are there so few top athletes?', 3);
INSERT INTO `topic_question` VALUES (45, 'p-creative-person', 'opening', 'Do you think children should learn to play musical instruments?', 1);
INSERT INTO `topic_question` VALUES (46, 'p-creative-person', 'opening', 'How do artists acquire inspiration?', 2);
INSERT INTO `topic_question` VALUES (47, 'p-creative-person', 'opening', 'Do you think pictures and videos in news reports are important?', 3);
INSERT INTO `topic_question` VALUES (48, 'p-creative-person', 'deep', 'What can we do to help children stay creative?', 1);
INSERT INTO `topic_question` VALUES (49, 'p-creative-person', 'deep', 'How does drawing help to enhance children\'s creativity?', 2);
INSERT INTO `topic_question` VALUES (50, 'p-creative-person', 'deep', 'What kind of jobs require creativity?', 3);
INSERT INTO `topic_question` VALUES (51, 'p-good-friend', 'opening', 'How do children make friends at school?', 1);
INSERT INTO `topic_question` VALUES (52, 'p-good-friend', 'opening', 'How do children make friends when they are not at school?', 2);
INSERT INTO `topic_question` VALUES (53, 'p-good-friend', 'opening', 'Do you think it is better for children to have a few close friends or many casual friends?', 3);
INSERT INTO `topic_question` VALUES (54, 'p-good-friend', 'deep', 'Can a child\'s relationship with friends be replaced by that with parents or family?', 1);
INSERT INTO `topic_question` VALUES (55, 'p-good-friend', 'deep', 'What are the differences between friends made inside and outside the workplace?', 2);
INSERT INTO `topic_question` VALUES (56, 'p-good-friend', 'deep', 'Do you think it\'s possible for bosses and their employees to become friends?', 3);
INSERT INTO `topic_question` VALUES (57, 'p-music-friend', 'opening', 'What kind of music is popular in your country?', 1);
INSERT INTO `topic_question` VALUES (58, 'p-music-friend', 'opening', 'What kind of music do young people like?', 2);
INSERT INTO `topic_question` VALUES (59, 'p-music-friend', 'opening', 'What are the differences between young and older people\'s music preferences?', 3);
INSERT INTO `topic_question` VALUES (60, 'p-music-friend', 'deep', 'What are the benefits of children learning a musical instrument?', 1);
INSERT INTO `topic_question` VALUES (61, 'p-music-friend', 'deep', 'Do you know what kind of music children like today?', 2);
INSERT INTO `topic_question` VALUES (62, 'p-music-friend', 'deep', 'Do you think the government should invest more money in concerts?', 3);
INSERT INTO `topic_question` VALUES (63, 'p-famous-person', 'opening', 'What are the advantages and disadvantages of being a famous child?', 1);
INSERT INTO `topic_question` VALUES (64, 'p-famous-person', 'opening', 'What can today\'s children do to become famous?', 2);
INSERT INTO `topic_question` VALUES (65, 'p-famous-person', 'opening', 'What can children do with their fame?', 3);
INSERT INTO `topic_question` VALUES (66, 'p-famous-person', 'deep', 'Do people become famous because of their talent?', 1);
INSERT INTO `topic_question` VALUES (67, 'p-planner', 'opening', 'Do you think it\'s important to plan ahead?', 1);
INSERT INTO `topic_question` VALUES (68, 'p-planner', 'opening', 'What activities do we need to plan ahead?', 2);
INSERT INTO `topic_question` VALUES (69, 'p-planner', 'opening', 'Do you think children should plan their future careers?', 3);
INSERT INTO `topic_question` VALUES (70, 'p-planner', 'deep', 'Should children ask their teachers or parents for advice when making plans?', 1);
INSERT INTO `topic_question` VALUES (71, 'p-planner', 'deep', 'Is making study plans popular among young people?', 2);
INSERT INTO `topic_question` VALUES (72, 'p-planner', 'deep', 'Do you think choosing a college major is closely related to a person\'s future career?', 3);
INSERT INTO `topic_question` VALUES (73, 'p-drawing-friend', 'opening', 'What is the right age for a child to learn drawing?', 1);
INSERT INTO `topic_question` VALUES (74, 'p-drawing-friend', 'opening', 'Why do most children draw more often than adults do?', 2);
INSERT INTO `topic_question` VALUES (75, 'p-drawing-friend', 'opening', 'Why do some people visit galleries instead of viewing artworks online?', 3);
INSERT INTO `topic_question` VALUES (76, 'p-drawing-friend', 'deep', 'Do you think galleries and museums should be free of charge?', 1);
INSERT INTO `topic_question` VALUES (77, 'p-drawing-friend', 'deep', 'How do artworks inspire people?', 2);
INSERT INTO `topic_question` VALUES (78, 'p-nature-person', 'opening', 'How can parents teach their children to protect nature?', 1);
INSERT INTO `topic_question` VALUES (79, 'p-nature-person', 'opening', 'Should schools teach children to get close to nature?', 2);
INSERT INTO `topic_question` VALUES (80, 'p-nature-person', 'opening', 'Do you think there should be laws to protect nature?', 3);
INSERT INTO `topic_question` VALUES (81, 'p-helpful-person', 'opening', 'Should children help their parents with household chores?', 1);
INSERT INTO `topic_question` VALUES (82, 'p-helpful-person', 'opening', 'What kind of help do people need when looking for a new job?', 2);
INSERT INTO `topic_question` VALUES (83, 'p-helpful-person', 'opening', 'Who should people ask for help 鈥?colleagues or family members?', 3);
INSERT INTO `topic_question` VALUES (84, 'pl-trees', 'opening', 'Why do people like visiting places with trees or forests?', 1);
INSERT INTO `topic_question` VALUES (85, 'pl-trees', 'opening', 'Are natural views better than city views?', 2);
INSERT INTO `topic_question` VALUES (86, 'pl-trees', 'opening', 'Do all people need some connection with nature?', 3);
INSERT INTO `topic_question` VALUES (87, 'pl-trees', 'deep', 'Are people instinctively inclined to protect the environment?', 1);
INSERT INTO `topic_question` VALUES (88, 'pl-natural', 'opening', 'What kind of people like to visit natural places?', 1);
INSERT INTO `topic_question` VALUES (89, 'pl-natural', 'opening', 'What are the differences between a natural place and a city?', 2);
INSERT INTO `topic_question` VALUES (90, 'pl-natural', 'opening', 'Do you think going to the park is the only way to get close to nature?', 3);
INSERT INTO `topic_question` VALUES (91, 'pl-natural', 'deep', 'What can people gain from going to natural places?', 1);
INSERT INTO `topic_question` VALUES (92, 'pl-natural', 'deep', 'Are there any wild animals in the city?', 2);
INSERT INTO `topic_question` VALUES (93, 'pl-natural', 'deep', 'Do you think it is a good idea to let animals stay in local parks for people to see?', 3);
INSERT INTO `topic_question` VALUES (94, 'pl-no-phone', 'opening', 'How do young and old people use mobile phones differently?', 1);
INSERT INTO `topic_question` VALUES (95, 'pl-no-phone', 'opening', 'What positive and negative impact do mobile phones have on friendship?', 2);
INSERT INTO `topic_question` VALUES (96, 'pl-no-phone', 'opening', 'Is it a waste of time to take pictures with mobile phones?', 3);
INSERT INTO `topic_question` VALUES (97, 'pl-no-phone', 'deep', 'Do you think it is necessary to have laws on the use of mobile phones?', 1);
INSERT INTO `topic_question` VALUES (98, 'pl-smiling', 'opening', 'Do you think people who like to smile are more friendly?', 1);
INSERT INTO `topic_question` VALUES (99, 'pl-smiling', 'opening', 'Why do most people smile in photographs?', 2);
INSERT INTO `topic_question` VALUES (100, 'pl-smiling', 'opening', 'Do women smile more than men? Why?', 3);
INSERT INTO `topic_question` VALUES (101, 'pl-smiling', 'deep', 'Do people smile more when they are younger or older?', 1);
INSERT INTO `topic_question` VALUES (102, 'ob-invention', 'opening', 'What qualities do inventors have?', 1);
INSERT INTO `topic_question` VALUES (103, 'ob-invention', 'opening', 'Do you think only scientists can invent new things?', 2);
INSERT INTO `topic_question` VALUES (104, 'ob-invention', 'opening', 'What inventions do you think should be improved?', 3);
INSERT INTO `topic_question` VALUES (105, 'ob-invention', 'deep', 'Are there any other inventions that make the world better?', 1);
INSERT INTO `topic_question` VALUES (106, 'ob-invention', 'deep', 'Do all inventions bring benefits to our world?', 2);
INSERT INTO `topic_question` VALUES (107, 'ob-invention', 'deep', 'Who should support inventors 鈥?governments or private companies?', 3);
INSERT INTO `topic_question` VALUES (108, 'ob-toy', 'opening', 'How do advertisements influence children?', 1);
INSERT INTO `topic_question` VALUES (109, 'ob-toy', 'opening', 'Should advertising aimed at kids be prohibited?', 2);
INSERT INTO `topic_question` VALUES (110, 'ob-toy', 'opening', 'What\'s the difference between toys kids play with now and those in the past?', 3);
INSERT INTO `topic_question` VALUES (111, 'ob-toy', 'deep', 'Do you think parents should buy more toys or spend more time with their kids?', 1);
INSERT INTO `topic_question` VALUES (112, 'ob-toy', 'deep', 'What\'s the difference between toys boys and girls play with?', 2);
INSERT INTO `topic_question` VALUES (113, 'ob-toy', 'deep', 'What are the advantages and disadvantages of modern toys?', 3);
INSERT INTO `topic_question` VALUES (114, 'ob-book', 'opening', 'What are the types of books that young people like to read?', 1);
INSERT INTO `topic_question` VALUES (115, 'ob-book', 'opening', 'What should the government do to make libraries better?', 2);
INSERT INTO `topic_question` VALUES (116, 'ob-book', 'opening', 'Do you think old people spend more time reading than young people?', 3);
INSERT INTO `topic_question` VALUES (117, 'ob-book', 'deep', 'Which one is better, paper books or e-books?', 1);
INSERT INTO `topic_question` VALUES (118, 'ob-book', 'deep', 'Have libraries changed a lot with the development of the internet?', 2);
INSERT INTO `topic_question` VALUES (119, 'ob-book', 'deep', 'What should we do to prevent modern libraries from closing down?', 3);
INSERT INTO `topic_question` VALUES (120, 'ob-science', 'opening', 'Why do some children not like learning science at school?', 1);
INSERT INTO `topic_question` VALUES (121, 'ob-science', 'opening', 'Is it important to study science at school?', 2);
INSERT INTO `topic_question` VALUES (122, 'ob-science', 'opening', 'Which science subject is the most important for children to learn?', 3);
INSERT INTO `topic_question` VALUES (123, 'ob-science', 'deep', 'Should people continue to study science after graduating from school?', 1);
INSERT INTO `topic_question` VALUES (124, 'ob-science', 'deep', 'How do you get to know about scientific news?', 2);
INSERT INTO `topic_question` VALUES (125, 'ob-science', 'deep', 'Should scientists explain the research process to the public?', 3);
INSERT INTO `topic_question` VALUES (126, 'ob-old-thing', 'opening', 'What kind of old things do people in your country like to keep?', 1);
INSERT INTO `topic_question` VALUES (127, 'ob-old-thing', 'opening', 'Why do people keep old things?', 2);
INSERT INTO `topic_question` VALUES (128, 'ob-old-thing', 'opening', 'What are the differences between the things old and young people keep?', 3);
INSERT INTO `topic_question` VALUES (129, 'ob-old-thing', 'deep', 'What are the differences between the things people keep today versus in the past?', 1);
INSERT INTO `topic_question` VALUES (130, 'ob-old-thing', 'deep', 'What can we see in a museum?', 2);
INSERT INTO `topic_question` VALUES (131, 'ob-old-thing', 'deep', 'What can we learn from a museum?', 3);
INSERT INTO `topic_question` VALUES (132, 'ob-story', 'opening', 'What kind of stories do children like?', 1);
INSERT INTO `topic_question` VALUES (133, 'ob-story', 'opening', 'What are the benefits of bedtime stories for children?', 2);
INSERT INTO `topic_question` VALUES (134, 'ob-story', 'opening', 'Why do most children like listening to stories before bedtime?', 3);
INSERT INTO `topic_question` VALUES (135, 'ob-story', 'deep', 'What can children learn from stories?', 1);
INSERT INTO `topic_question` VALUES (136, 'ob-story', 'deep', 'Do all stories for children have happy endings?', 2);
INSERT INTO `topic_question` VALUES (137, 'ob-story', 'deep', 'Is a good storyline important for a movie?', 3);
INSERT INTO `topic_question` VALUES (138, 'ob-talent', 'opening', 'Do you think artists with talents should focus on their talents?', 1);
INSERT INTO `topic_question` VALUES (139, 'ob-talent', 'opening', 'Is it possible to know whether young children will become musicians or painters when they grow up?', 2);
INSERT INTO `topic_question` VALUES (140, 'ob-talent', 'opening', 'Why do people like to watch talent shows?', 3);
INSERT INTO `topic_question` VALUES (141, 'ob-talent', 'deep', 'Do you think it is more interesting to watch famous or ordinary people\'s shows?', 1);
INSERT INTO `topic_question` VALUES (142, 'ob-talent', 'deep', 'Do you think it\'s important to develop children\'s talents?', 2);
INSERT INTO `topic_question` VALUES (143, 'ob-talent', 'deep', 'Why do some people like to show their talents online?', 3);
INSERT INTO `topic_question` VALUES (144, 'ob-wild-animal', 'opening', 'Why should we protect wild animals?', 1);
INSERT INTO `topic_question` VALUES (145, 'ob-wild-animal', 'opening', 'Why are some people more willing to protect wild animals than others?', 2);
INSERT INTO `topic_question` VALUES (146, 'ob-wild-animal', 'opening', 'Do you think it\'s important to take children to the zoo to see animals?', 3);
INSERT INTO `topic_question` VALUES (147, 'ob-wild-animal', 'deep', 'Why do some people attach more importance to protecting rare animals?', 1);
INSERT INTO `topic_question` VALUES (148, 'ob-wild-animal', 'deep', 'Should people educate children to protect wild animals?', 2);
INSERT INTO `topic_question` VALUES (149, 'ob-wild-animal', 'deep', 'Is it more important to protect wild animals or the environment?', 3);
INSERT INTO `topic_question` VALUES (150, 'ob-building', 'opening', 'Should all scenic spots charge an entry fee?', 1);
INSERT INTO `topic_question` VALUES (151, 'ob-building', 'opening', 'Is visiting scenic spots the best choice while travelling?', 2);
INSERT INTO `topic_question` VALUES (152, 'ob-building', 'opening', 'Why do some people like to live in big cities?', 3);
INSERT INTO `topic_question` VALUES (153, 'ob-building', 'deep', 'Is it necessary for tourists to visit landmarks when travelling?', 1);
INSERT INTO `topic_question` VALUES (154, 'ob-building', 'deep', 'Which do most people prefer, living in a bungalow or in a tall building?', 2);
INSERT INTO `topic_question` VALUES (155, 'ob-habit', 'opening', 'What habits should children have?', 1);
INSERT INTO `topic_question` VALUES (156, 'ob-habit', 'opening', 'What should parents do to teach their children good habits?', 2);
INSERT INTO `topic_question` VALUES (157, 'ob-habit', 'opening', 'What influences do children with bad habits have on other children?', 3);
INSERT INTO `topic_question` VALUES (158, 'ob-habit', 'deep', 'Why do some habits change when people get older?', 1);
INSERT INTO `topic_question` VALUES (159, 'ob-habit', 'deep', 'How do we develop bad habits?', 2);
INSERT INTO `topic_question` VALUES (160, 'ob-habit', 'deep', 'What can we do to get rid of bad habits?', 3);
INSERT INTO `topic_question` VALUES (161, 'ob-water-sport', 'opening', 'Do you think it is good to teach swimming in school?', 1);
INSERT INTO `topic_question` VALUES (162, 'ob-water-sport', 'opening', 'What kinds of water sports are popular nowadays?', 2);
INSERT INTO `topic_question` VALUES (163, 'ob-water-sport', 'opening', 'Why do people like to live near water?', 3);
INSERT INTO `topic_question` VALUES (164, 'ob-water-sport', 'deep', 'What are the advantages of water transportation?', 1);
INSERT INTO `topic_question` VALUES (165, 'ob-water-sport', 'deep', 'What do you think of people who waste water?', 2);
INSERT INTO `topic_question` VALUES (166, 'ob-water-sport', 'deep', 'What are the characteristics of goods transported by water?', 3);
INSERT INTO `topic_question` VALUES (167, 'ob-dream-job', 'opening', 'What kind of job can be called a \"dream job\"?', 1);
INSERT INTO `topic_question` VALUES (168, 'ob-dream-job', 'opening', 'What jobs do children want to do when they grow up?', 2);
INSERT INTO `topic_question` VALUES (169, 'ob-dream-job', 'opening', 'Do people\'s ideal jobs change as they grow up?', 3);
INSERT INTO `topic_question` VALUES (170, 'ob-dream-job', 'deep', 'What should people consider when choosing jobs?', 1);
INSERT INTO `topic_question` VALUES (171, 'ob-dream-job', 'deep', 'Is salary the main reason why people choose a certain job?', 2);
INSERT INTO `topic_question` VALUES (172, 'ob-technology', 'opening', 'What are the differences between the technology of the past and that of today?', 1);
INSERT INTO `topic_question` VALUES (173, 'ob-technology', 'opening', 'What technology do young people like to use?', 2);
INSERT INTO `topic_question` VALUES (174, 'ob-technology', 'opening', 'What are the differences between online and face-to-face communication?', 3);
INSERT INTO `topic_question` VALUES (175, 'ob-app', 'opening', 'What are the differences between old and young people when using apps?', 1);
INSERT INTO `topic_question` VALUES (176, 'ob-app', 'opening', 'Why do some people not like using apps?', 2);
INSERT INTO `topic_question` VALUES (177, 'ob-app', 'opening', 'What apps are popular in your country? Why?', 3);
INSERT INTO `topic_question` VALUES (178, 'ob-app', 'deep', 'Should parents limit their children\'s use of computer games? Why and how?', 1);
INSERT INTO `topic_question` VALUES (179, 'ob-app', 'deep', 'Do you think young people are becoming more and more reliant on these programs?', 2);
INSERT INTO `topic_question` VALUES (180, 'ob-family-thing', 'opening', 'What things do families keep for a long time?', 1);
INSERT INTO `topic_question` VALUES (181, 'ob-family-thing', 'opening', 'What\'s the difference between things valued by people in the past and today?', 2);
INSERT INTO `topic_question` VALUES (182, 'ob-family-thing', 'opening', 'What kinds of things are kept in museums?', 3);
INSERT INTO `topic_question` VALUES (183, 'ob-family-thing', 'deep', 'What\'s the influence of technology on museums?', 1);
INSERT INTO `topic_question` VALUES (184, 'ob-overspend', 'opening', 'Do you often buy more than you expected?', 1);
INSERT INTO `topic_question` VALUES (185, 'ob-overspend', 'opening', 'What do you think young people spend most of their money on?', 2);
INSERT INTO `topic_question` VALUES (186, 'ob-overspend', 'opening', 'Do you think it is important to save money? Why?', 3);
INSERT INTO `topic_question` VALUES (187, 'ob-overspend', 'deep', 'Do people buy things they don\'t need?', 1);
INSERT INTO `topic_question` VALUES (188, 'ev-long-journey', 'opening', 'Do you think it is a good choice to travel by plane?', 1);
INSERT INTO `topic_question` VALUES (189, 'ev-long-journey', 'opening', 'What are the differences between group travelling and travelling alone?', 2);
INSERT INTO `topic_question` VALUES (190, 'ev-long-journey', 'opening', 'What do we need to prepare for a long journey?', 3);
INSERT INTO `topic_question` VALUES (191, 'ev-long-journey', 'deep', 'Why do some people like making long journeys?', 1);
INSERT INTO `topic_question` VALUES (192, 'ev-long-journey', 'deep', 'Why do some people prefer to travel in their own country?', 2);
INSERT INTO `topic_question` VALUES (193, 'ev-long-journey', 'deep', 'Why do some people prefer to travel abroad?', 3);
INSERT INTO `topic_question` VALUES (194, 'ev-broke-something', 'opening', 'What kind of things are most likely to be broken at home?', 1);
INSERT INTO `topic_question` VALUES (195, 'ev-broke-something', 'opening', 'What kind of people like to fix things by themselves?', 2);
INSERT INTO `topic_question` VALUES (196, 'ev-broke-something', 'opening', 'Do you think clothes produced in factories are better quality than handmade ones?', 3);
INSERT INTO `topic_question` VALUES (197, 'ev-broke-something', 'deep', 'Do you think handmade clothes are more valuable?', 1);
INSERT INTO `topic_question` VALUES (198, 'ev-broke-something', 'deep', 'Is the older generation better at fixing things?', 2);
INSERT INTO `topic_question` VALUES (199, 'ev-broke-something', 'deep', 'Do you think elderly people should teach young people how to fix things?', 3);
INSERT INTO `topic_question` VALUES (200, 'ev-decision', 'opening', 'What kind of decisions do you think are meaningful?', 1);
INSERT INTO `topic_question` VALUES (201, 'ev-decision', 'opening', 'What important decisions should be made by teenagers themselves?', 2);
INSERT INTO `topic_question` VALUES (202, 'ev-decision', 'opening', 'Why are some people unwilling to make quick decisions?', 3);
INSERT INTO `topic_question` VALUES (203, 'ev-decision', 'deep', 'Do people like to ask for advice more for their personal life or their work?', 1);
INSERT INTO `topic_question` VALUES (204, 'ev-decision', 'deep', 'Why do some people like to ask others for advice?', 2);
INSERT INTO `topic_question` VALUES (205, 'ev-gave-advice', 'opening', 'Should people prepare before giving advice?', 1);
INSERT INTO `topic_question` VALUES (206, 'ev-gave-advice', 'opening', 'Is it good to ask advice from strangers online?', 2);
INSERT INTO `topic_question` VALUES (207, 'ev-gave-advice', 'opening', 'What are the personalities of people whose job is to give advice?', 3);
INSERT INTO `topic_question` VALUES (208, 'ev-gave-advice', 'deep', 'What are the problems if you ask too many people for advice?', 1);
INSERT INTO `topic_question` VALUES (209, 'ev-power-cut', 'opening', 'Which is better, electric bicycles or ordinary bicycles?', 1);
INSERT INTO `topic_question` VALUES (210, 'ev-power-cut', 'opening', 'Which is better, electric cars or petrol cars?', 2);
INSERT INTO `topic_question` VALUES (211, 'ev-power-cut', 'opening', 'How did people manage to live without electricity in the ancient world?', 3);
INSERT INTO `topic_question` VALUES (212, 'ev-power-cut', 'deep', 'Do electric bicycles replace ordinary bicycles in the future?', 1);
INSERT INTO `topic_question` VALUES (213, 'ev-power-cut', 'deep', 'Is it difficult for the government to replace all petrol cars with electric ones?', 2);
INSERT INTO `topic_question` VALUES (214, 'ev-power-cut', 'deep', 'Do people use more electricity now than before?', 3);
INSERT INTO `topic_question` VALUES (215, 'ev-exciting-first', 'opening', 'Why are some people unwilling to try new things?', 1);
INSERT INTO `topic_question` VALUES (216, 'ev-exciting-first', 'opening', 'Do you think fear stops people from trying new things?', 2);
INSERT INTO `topic_question` VALUES (217, 'ev-exciting-first', 'opening', 'Why are some people keen on doing dangerous activities?', 3);
INSERT INTO `topic_question` VALUES (218, 'ev-exciting-first', 'deep', 'Do you think that children adapt to new things more easily than adults?', 1);
INSERT INTO `topic_question` VALUES (219, 'ev-exciting-first', 'deep', 'What can people learn from doing challenging activities?', 2);
INSERT INTO `topic_question` VALUES (220, 'ev-exciting-first', 'deep', 'What are the benefits of trying new things?', 3);
INSERT INTO `topic_question` VALUES (221, 'ev-positive-change', 'opening', 'What do people normally plan in their daily lives?', 1);
INSERT INTO `topic_question` VALUES (222, 'ev-positive-change', 'opening', 'Is time management very important in our daily lives?', 2);
INSERT INTO `topic_question` VALUES (223, 'ev-positive-change', 'opening', 'What changes would people often make?', 3);
INSERT INTO `topic_question` VALUES (224, 'ev-positive-change', 'deep', 'Do you think it is good to change jobs frequently?', 1);
INSERT INTO `topic_question` VALUES (225, 'ev-positive-change', 'deep', 'Who makes changes more often 鈥?young people or older people?', 2);
INSERT INTO `topic_question` VALUES (226, 'ev-positive-change', 'deep', 'Who should get more promotion opportunities, young or older people?', 3);
INSERT INTO `topic_question` VALUES (227, 'ev-good-service', 'opening', 'Why are shopping malls so popular in China?', 1);
INSERT INTO `topic_question` VALUES (228, 'ev-good-service', 'opening', 'What are the advantages and disadvantages of shopping in small shops?', 2);
INSERT INTO `topic_question` VALUES (229, 'ev-good-service', 'opening', 'Why do some people not like shopping in small shops?', 3);
INSERT INTO `topic_question` VALUES (230, 'ev-good-service', 'deep', 'What are the differences between online shopping and in-store shopping?', 1);
INSERT INTO `topic_question` VALUES (231, 'ev-good-service', 'deep', 'What are the advantages and disadvantages of shopping online?', 2);
INSERT INTO `topic_question` VALUES (232, 'ev-good-service', 'deep', 'Can consumption drive economic growth?', 3);
INSERT INTO `topic_question` VALUES (233, 'ev-speech', 'opening', 'What benefits does the internet bring to communication?', 1);
INSERT INTO `topic_question` VALUES (234, 'ev-speech', 'opening', 'Which one is better 鈥?being a communicator or a listener?', 2);
INSERT INTO `topic_question` VALUES (235, 'ev-speech', 'opening', 'What qualities does a person need to be a good communicator?', 3);
INSERT INTO `topic_question` VALUES (236, 'ev-speech', 'deep', 'What qualities do people need to speak in public?', 1);
INSERT INTO `topic_question` VALUES (237, 'ev-speech', 'deep', 'How important is it to be a good listener when communicating?', 2);
INSERT INTO `topic_question` VALUES (238, 'ev-speech', 'deep', 'What kinds of people often give speeches?', 3);
INSERT INTO `topic_question` VALUES (239, 'ev-unusual-meal', 'opening', 'What are the advantages and disadvantages of eating in restaurants?', 1);
INSERT INTO `topic_question` VALUES (240, 'ev-unusual-meal', 'opening', 'What fast food restaurants are there in your country?', 2);
INSERT INTO `topic_question` VALUES (241, 'ev-unusual-meal', 'opening', 'Do people eat fast food at home?', 3);
INSERT INTO `topic_question` VALUES (242, 'ev-unusual-meal', 'deep', 'Why do some people choose to eat out instead of ordering takeout?', 1);
INSERT INTO `topic_question` VALUES (243, 'ev-unusual-meal', 'deep', 'Do people in your country socialise in restaurants?', 2);
INSERT INTO `topic_question` VALUES (244, 'ev-unusual-meal', 'deep', 'Do people in your country value food culture?', 3);
INSERT INTO `topic_question` VALUES (245, 'ev-waiting', 'opening', 'On what occasions do people usually need to wait?', 1);
INSERT INTO `topic_question` VALUES (246, 'ev-waiting', 'opening', 'Who behaves better when waiting 鈥?children or adults?', 2);
INSERT INTO `topic_question` VALUES (247, 'ev-waiting', 'opening', 'Compared to the past, are people less patient now? Why?', 3);
INSERT INTO `topic_question` VALUES (248, 'ev-waiting', 'deep', 'What are the positive and negative effects of waiting on society?', 1);
INSERT INTO `topic_question` VALUES (249, 'ev-waiting', 'deep', 'Why are some people unwilling to wait?', 2);
INSERT INTO `topic_question` VALUES (250, 'ev-waiting', 'deep', 'Where do children learn to be patient 鈥?at home or at school?', 3);
INSERT INTO `topic_question` VALUES (251, 'ev-social-media', 'opening', 'Why do people like to use social media?', 1);
INSERT INTO `topic_question` VALUES (252, 'ev-social-media', 'opening', 'What kinds of things are popular on social media?', 2);
INSERT INTO `topic_question` VALUES (253, 'ev-social-media', 'opening', 'What are the advantages and disadvantages of using social media?', 3);
INSERT INTO `topic_question` VALUES (254, 'ev-social-media', 'deep', 'What do you think of making friends on social networks?', 1);
INSERT INTO `topic_question` VALUES (255, 'ev-social-media', 'deep', 'Are there any people who shouldn\'t use social media?', 2);
INSERT INTO `topic_question` VALUES (256, 'ev-social-media', 'deep', 'Do you think people spend too much time on social media?', 3);
INSERT INTO `topic_question` VALUES (257, 'ev-told-truth', 'opening', 'Do you think it\'s more important to win or to follow the rules in sports?', 1);
INSERT INTO `topic_question` VALUES (258, 'ev-told-truth', 'opening', 'Sometimes people should tell lies. Do you agree?', 2);
INSERT INTO `topic_question` VALUES (259, 'ev-told-truth', 'opening', 'How do you know when others are telling lies?', 3);
INSERT INTO `topic_question` VALUES (260, 'ev-told-truth', 'deep', 'Do you think we should tell the truth at all times?', 1);
INSERT INTO `topic_question` VALUES (261, 'ev-foreign-language', 'opening', 'At what age should children start learning a foreign language?', 1);
INSERT INTO `topic_question` VALUES (262, 'ev-foreign-language', 'opening', 'Which skill is more important 鈥?speaking or writing?', 2);
INSERT INTO `topic_question` VALUES (263, 'ev-foreign-language', 'opening', 'Does a person still need to learn other languages if they are good at English?', 3);
INSERT INTO `topic_question` VALUES (264, 'ev-foreign-language', 'deep', 'Do you think minority languages will disappear?', 1);
INSERT INTO `topic_question` VALUES (265, 'ev-foreign-language', 'deep', 'Does learning a foreign language help in finding a job?', 2);
INSERT INTO `topic_question` VALUES (266, 'ev-foreign-language', 'deep', 'Which stage of life is the best for learning a foreign language?', 3);
INSERT INTO `topic_question` VALUES (267, 'ev-lost-way', 'opening', 'Why do some people get lost more easily than others?', 1);
INSERT INTO `topic_question` VALUES (268, 'ev-lost-way', 'opening', 'Do you think it is important to be able to read a map?', 2);
INSERT INTO `topic_question` VALUES (269, 'ev-lost-way', 'opening', 'Do you think it is important to do some preparation before travelling to new places?', 3);
INSERT INTO `topic_question` VALUES (270, 'ev-lost-way', 'deep', 'How can people find their way when they are lost?', 1);
INSERT INTO `topic_question` VALUES (271, 'ev-lost-way', 'deep', 'Is a paper map still necessary?', 2);
INSERT INTO `topic_question` VALUES (272, 'ev-lost-way', 'deep', 'How do people react when they get lost?', 3);
INSERT INTO `topic_question` VALUES (273, 'ev-apology', 'opening', 'Do you think people should apologise for anything wrong they do?', 1);
INSERT INTO `topic_question` VALUES (274, 'ev-apology', 'opening', 'Do people in your country like to say \"sorry\"?', 2);
INSERT INTO `topic_question` VALUES (275, 'ev-apology', 'opening', 'On what occasions do people usually apologise to others?', 3);
INSERT INTO `topic_question` VALUES (276, 'ev-apology', 'deep', 'Why do some people refuse to say \"sorry\" to others?', 1);
INSERT INTO `topic_question` VALUES (277, 'ev-apology', 'deep', 'Do you think every \"sorry\" is truly from the heart?', 2);
INSERT INTO `topic_question` VALUES (278, 'ev-apology', 'deep', 'Are women better than men at recognising emotions?', 3);
INSERT INTO `topic_question` VALUES (279, 'ev-family-dinner', 'opening', 'Do people prefer to eat out or eat at home during the Spring Festival?', 1);
INSERT INTO `topic_question` VALUES (280, 'ev-family-dinner', 'opening', 'What food do you eat on special occasions like the Spring Festival or Mid-Autumn Festival?', 2);
INSERT INTO `topic_question` VALUES (281, 'ev-family-dinner', 'opening', 'Why do people like to have meals together during important festivals?', 3);
INSERT INTO `topic_question` VALUES (282, 'ev-family-dinner', 'deep', 'Is it a hassle to prepare a meal at home?', 1);
INSERT INTO `topic_question` VALUES (283, 'ev-family-dinner', 'deep', 'What do people often talk about during meals?', 2);
INSERT INTO `topic_question` VALUES (284, 'ev-family-dinner', 'deep', 'People are spending less time having meals with their families today. Is this good or bad?', 3);
INSERT INTO `topic_question` VALUES (285, 'ev-story-read', 'opening', 'Why do most children like listening to stories before bedtime?', 1);
INSERT INTO `topic_question` VALUES (286, 'ev-story-read', 'opening', 'Is a good storyline important for a movie?', 2);
INSERT INTO `topic_question` VALUES (287, 'ev-story-read', 'opening', 'Do you think films with many celebrities are more likely to be popular?', 3);
INSERT INTO `topic_question` VALUES (288, 'ev-story-read', 'deep', 'What films are popular in China right now?', 1);
INSERT INTO `topic_question` VALUES (289, 'ev-proud-family', 'opening', 'When would parents feel proud of their children?', 1);
INSERT INTO `topic_question` VALUES (290, 'ev-proud-family', 'opening', 'Should parents reward children? Why and how?', 2);
INSERT INTO `topic_question` VALUES (291, 'ev-proud-family', 'opening', 'Is it good to reward children too often? Why?', 3);
INSERT INTO `topic_question` VALUES (292, 'ev-proud-family', 'deep', 'On what occasions would adults feel proud of themselves?', 1);
INSERT INTO `topic_question` VALUES (293, 'ev-vehicle-trip', 'opening', 'Which form of vehicle is more popular in your country 鈥?bikes, cars or motorcycles?', 1);
INSERT INTO `topic_question` VALUES (294, 'ev-vehicle-trip', 'opening', 'Do you think air pollution comes mostly from vehicles?', 2);
INSERT INTO `topic_question` VALUES (295, 'ev-vehicle-trip', 'opening', 'Do you think people need to change their transport habits to protect the environment?', 3);
INSERT INTO `topic_question` VALUES (296, 'ev-vehicle-trip', 'deep', 'How are the transportation systems in urban and rural areas different?', 1);
INSERT INTO `topic_question` VALUES (297, 'ev-bad-concert', 'opening', 'What kind of music events do people like today?', 1);
INSERT INTO `topic_question` VALUES (298, 'ev-bad-concert', 'opening', 'What kind of music did people enjoy in the past?', 2);
INSERT INTO `topic_question` VALUES (299, 'ev-bad-concert', 'opening', 'What makes a music performance enjoyable?', 3);
INSERT INTO `topic_question` VALUES (300, 'ev-movie', 'opening', 'What kinds of movies are successful in your country?', 1);
INSERT INTO `topic_question` VALUES (301, 'ev-movie', 'opening', 'What are the factors that make a successful movie?', 2);
INSERT INTO `topic_question` VALUES (302, 'ev-movie', 'opening', 'Do people prefer to watch domestic movies or foreign movies?', 3);
INSERT INTO `topic_question` VALUES (303, 'ev-movie', 'deep', 'Do you think only well-known directors can create the best movies?', 1);
INSERT INTO `topic_question` VALUES (304, 'ev-movie', 'deep', 'Should successful movies have well-known actors in leading roles?', 2);
INSERT INTO `topic_question` VALUES (305, 'ev-movie', 'deep', 'Why do people prefer to watch movies in the cinema?', 3);
INSERT INTO `topic_question` VALUES (306, 'ev-imagination', 'opening', 'Do you think adults can have lots of imagination?', 1);
INSERT INTO `topic_question` VALUES (307, 'ev-imagination', 'opening', 'Do you think imagination is essential for scientists?', 2);
INSERT INTO `topic_question` VALUES (308, 'ev-imagination', 'opening', 'What kinds of jobs need imagination?', 3);
INSERT INTO `topic_question` VALUES (309, 'ev-imagination', 'deep', 'What subjects are helpful for children\'s imagination?', 1);

SET FOREIGN_KEY_CHECKS = 1;
