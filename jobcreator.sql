-- Job Creator Database Schema
-- This file is for reference only. Tables are created automatically by the script.

-- Jobs Table
CREATE TABLE IF NOT EXISTS `jobcreator_jobs` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(50) NOT NULL UNIQUE,
    `label` VARCHAR(100) NOT NULL,
    `whitelisted` TINYINT(1) DEFAULT 0,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Grades Table
CREATE TABLE IF NOT EXISTS `jobcreator_grades` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `job_name` VARCHAR(50) NOT NULL,
    `grade` INT NOT NULL,
    `name` VARCHAR(50) NOT NULL,
    `label` VARCHAR(100) NOT NULL,
    `salary` INT DEFAULT 0,
    `skin_male` LONGTEXT,
    `skin_female` LONGTEXT,
    PRIMARY KEY (`id`),
    UNIQUE KEY `job_grade_unique` (`job_name`, `grade`),
    FOREIGN KEY (`job_name`) REFERENCES `jobcreator_jobs`(`name`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Markers Table
CREATE TABLE IF NOT EXISTS `jobcreator_markers` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `job_name` VARCHAR(50) NOT NULL,
    `type` VARCHAR(50) NOT NULL,
    `label` VARCHAR(100) NOT NULL,
    `x` FLOAT NOT NULL,
    `y` FLOAT NOT NULL,
    `z` FLOAT NOT NULL,
    `marker_type` INT DEFAULT 1,
    `marker_size` FLOAT DEFAULT 1.5,
    `marker_color` VARCHAR(20) DEFAULT '255,0,0',
    `data` LONGTEXT,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    FOREIGN KEY (`job_name`) REFERENCES `jobcreator_jobs`(`name`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Whitelist Table
CREATE TABLE IF NOT EXISTS `jobcreator_whitelist` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `job_name` VARCHAR(50) NOT NULL,
    `identifier` VARCHAR(100) NOT NULL,
    `added_by` VARCHAR(100),
    `added_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE KEY `job_identifier_unique` (`job_name`, `identifier`),
    FOREIGN KEY (`job_name`) REFERENCES `jobcreator_jobs`(`name`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Statistics Table
CREATE TABLE IF NOT EXISTS `jobcreator_statistics` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `job_name` VARCHAR(50) NOT NULL,
    `player_count` INT DEFAULT 0,
    `total_salary` BIGINT DEFAULT 0,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE KEY `job_unique` (`job_name`),
    FOREIGN KEY (`job_name`) REFERENCES `jobcreator_jobs`(`name`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
