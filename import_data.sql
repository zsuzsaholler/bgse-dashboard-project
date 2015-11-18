-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `importdb` ;

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `importdb` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci ;
SHOW WARNINGS;
USE `importdb` ;

-- -----------------------------------------------------
-- Table `mydb`.`User_Friends`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `importdb`.`User_Friends` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `importdb`.`User_Friends` (
  `userID` INT NOT NULL COMMENT '',
  `friendID` INT NOT NULL COMMENT '',
  PRIMARY KEY (`userID`, `friendID`)  COMMENT '');
SHOW WARNINGS;


LOAD DATA LOCAL INFILE '/home/zsuzsa/Documents/project/data/user_friends.dat' 
INTO TABLE User_Friends
FIELDS TERMINATED BY '\t' 
LINES TERMINATED BY '\n' 
IGNORE 1 LINES;
SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `mydb`.`Users`
-- -----------------------------------------------------

DROP TABLE IF EXISTS `importdb`.`Users` ;

CREATE TABLE IF NOT EXISTS `importdb`.`Users` AS
	SELECT DISTINCT(userID) FROM User_Friends;

SHOW WARNINGS;


-- -----------------------------------------------------
-- Table `mydb`.`Artists`
-- -----------------------------------------------------

DROP TABLE IF EXISTS `importdb`.`Artists` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `importdb`.`Artists` (
  `artistID` INT NOT NULL COMMENT '',
  `artistName` VARCHAR(114) NULL COMMENT '',
  PRIMARY KEY (`artistID`)  COMMENT '')
ENGINE = InnoDB;

SHOW WARNINGS;

LOAD DATA LOCAL INFILE '/home/zsuzsa/Documents/project/data/artists.dat' 
INTO TABLE Artists
FIELDS TERMINATED BY '\t' 
LINES TERMINATED BY '\n' 
IGNORE 1 LINES
(artistID, artistName, @dummy, @dummy);

-- -----------------------------------------------------
-- Table `mydb`.`Tags`
-- -----------------------------------------------------

DROP TABLE IF EXISTS `importdb`.`Tags` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `importdb`.`Tags` (
  `tagID` INT NOT NULL COMMENT '',
  `tagValue` VARCHAR(500) NULL COMMENT '',
  PRIMARY KEY (`tagID`)  COMMENT '')
ENGINE = InnoDB;

SHOW WARNINGS;

LOAD DATA LOCAL INFILE '/home/zsuzsa/Documents/project/data/tags.dat' 
INTO TABLE Tags
FIELDS TERMINATED BY '\t' 
LINES TERMINATED BY '\n' 
IGNORE 1 LINES;
SHOW WARNINGS;

select * from Tags limit 2813,1;
select * from Tags limit 4454,1;
select * from Tags limit 4723,1;
select * from Tags limit 5292,1;
select * from Tags limit 7643,1;
select * from Tags limit 8595,1;
select * from Tags limit 10632,1;
select * from Tags limit 11046,1;

-- -----------------------------------------------------
-- Table `mydb`.`User_Artists`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `importdb`.`User_Artists` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `importdb`.`User_Artists` (
  `userID` INT NOT NULL COMMENT '',
  `artistID` INT NOT NULL COMMENT '',
  `listens` INT NULL COMMENT '',
  PRIMARY KEY (`userID`, `artistID`)  COMMENT '');

SHOW WARNINGS;

LOAD DATA LOCAL INFILE '/home/zsuzsa/Documents/project/data/user_artists.dat' 
INTO TABLE User_Artists
FIELDS TERMINATED BY '\t' 
LINES TERMINATED BY '\n' 
IGNORE 1 LINES;

-- -----------------------------------------------------
-- Table `mydb`.`User_Tags`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `importdb`.`User_Tags_full` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `importdb`.`User_Tags_full` (
  `userID` INT NOT NULL COMMENT '',
  `artistID` INT NOT NULL COMMENT '',
  `tagID` INT NOT NULL COMMENT '',
  `day` INT NULL COMMENT '',
  `month` INT NULL COMMENT '',
  `year` INT NULL COMMENT '',
  PRIMARY KEY (`userID`, `artistID`, `tagID`)  COMMENT '');

CREATE INDEX `fk_User_Tags_Artists1_idx` ON `importdb`.`User_Tags_full` (`artistID` ASC)  COMMENT '';

LOAD DATA LOCAL INFILE '/home/zsuzsa/Documents/project/data/user_taggedartists.dat' 
INTO TABLE User_Tags_full
FIELDS TERMINATED BY '\t' 
LINES TERMINATED BY '\n' 
IGNORE 1 LINES;
SHOW ERRORS;

DROP TABLE IF EXISTS `importdb`.`User_Tags` ;

CREATE TABLE IF NOT EXISTS `importdb`.`User_Tags` AS
	SELECT * FROM User_Tags_full
	WHERE User_Tags_full.artistID IN (SELECT artistID FROM Artists);