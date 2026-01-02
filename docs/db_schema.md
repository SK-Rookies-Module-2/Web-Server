```sql
-- MariaDB / MySQL용 (InnoDB, utf8mb4)
-- 실행 전: CREATE DATABASE lms_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci; 후 lms_db 선택
-- USE lms_db;

SET NAMES utf8mb4;
SET time_zone = '+09:00';

-- 기존 테이블 있으면 삭제(필요 시 주석 해제)
-- DROP TABLE IF EXISTS study_posts;
-- DROP TABLE IF EXISTS study_groups;
-- DROP TABLE IF EXISTS notices;
-- DROP TABLE IF EXISTS evaluations;
-- DROP TABLE IF EXISTS users;

CREATE TABLE IF NOT EXISTS evaluations (
  no           INT(11) NOT NULL AUTO_INCREMENT,
  status       VARCHAR(20) NULL,
  subject      VARCHAR(100) NULL,
  eval_name    VARCHAR(100) NULL,
  exam_date    VARCHAR(50) NULL,
  avg_score    INT(11) NULL,
  my_score     INT(11) NULL,
  has_feedback TINYINT(1) NULL,
  has_file     TINYINT(1) NULL,
  has_meeting  TINYINT(1) NULL,
  PRIMARY KEY (no)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS notices (
  no           INT(11) NOT NULL AUTO_INCREMENT,
  category     VARCHAR(50) NULL,
  title        VARCHAR(200) NULL,
  writer       VARCHAR(50) NULL,
  content      TEXT NULL,
  reg_date     VARCHAR(20) NULL,
  views        INT(11) NULL DEFAULT 0,
  is_important TINYINT(1) NULL DEFAULT 0,
  is_visible   TINYINT(1) NULL DEFAULT 1,
  PRIMARY KEY (no)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS study_groups (
  no          INT(11) NOT NULL AUTO_INCREMENT,
  title       VARCHAR(255) NOT NULL,
  writer      VARCHAR(50) NULL,
  content     TEXT NULL,
  frequency   VARCHAR(50) NULL,
  capacity    INT(11) NULL,
  pre_members VARCHAR(255) NULL,
  reg_date    DATE NULL,
  status      VARCHAR(20) NULL DEFAULT '모집중',
  views       INT(11) NULL DEFAULT 0,
  PRIMARY KEY (no)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS users (
  id          VARCHAR(50) NOT NULL,
  password    VARCHAR(100) NULL,
  name        VARCHAR(50) NULL,
  role        VARCHAR(20) NULL,
  phone       VARCHAR(20) NULL,
  email       VARCHAR(50) NULL,
  aws_account VARCHAR(12) NULL,
  iam_user    VARCHAR(50) NULL,
  aws_pw      VARCHAR(50) NULL,
  region      VARCHAR(50) NULL,
  PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS study_posts (
  post_no   INT(11) NOT NULL AUTO_INCREMENT,
  study_no  INT(11) NOT NULL,
  title     VARCHAR(255) NOT NULL,
  writer    VARCHAR(50) NOT NULL,
  content   TEXT NULL,
  file_name VARCHAR(255) NULL,
  reg_date  DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (post_no),
  KEY idx_study_posts_study_no (study_no),
  CONSTRAINT fk_study_posts_study_groups
    FOREIGN KEY (study_no) REFERENCES study_groups(no)
    ON UPDATE CASCADE
    ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- (선택) 조회/정렬이 잦다면 인덱스 추가 예시
-- CREATE INDEX idx_notices_reg_date ON notices(reg_date);
-- CREATE INDEX idx_study_groups_reg_date ON study_groups(reg_date);
-- CREATE INDEX idx_study_posts_reg_date ON study_posts(reg_date);

-- 확인
-- SHOW TABLES;
-- DESCRIBE evaluations;
```