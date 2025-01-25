CREATE TABLE IF NOT EXISTS `sayer_zones` (
  `id` varchar(50) DEFAULT NULL,
  `owner` varchar(50) DEFAULT NULL,
  `rep` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `owner` (`owner`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `sayer_gangs` (
  `citizenid` varchar(50) DEFAULT NULL,
  `data` TEXT DEFAULT NULL,
  PRIMARY KEY (`citizenid`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;