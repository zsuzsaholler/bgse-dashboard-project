-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `mydb` ;

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `mydb` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci ;
SHOW WARNINGS;
USE `mydb` ;

-- -----------------------------------------------------
-- Table `mydb`.`Users`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`Users` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `mydb`.`Users` (
  `userID` INT NOT NULL COMMENT '',
  PRIMARY KEY (`userID`)  COMMENT '')
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `mydb`.`Artists`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`Artists` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `mydb`.`Artists` (
  `artistID` INT NOT NULL COMMENT '',
  `artistName` VARCHAR(114) NULL COMMENT '',
  PRIMARY KEY (`artistID`)  COMMENT '')
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `mydb`.`Tags`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`Tags` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `mydb`.`Tags` (
  `tagID` INT NOT NULL COMMENT '',
  `tagValue` VARCHAR(500) NULL COMMENT '',
  PRIMARY KEY (`tagID`)  COMMENT '')
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `mydb`.`User_Artists`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`User_Artists` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `mydb`.`User_Artists` (
  `userID` INT NOT NULL COMMENT '',
  `artistID` INT NOT NULL COMMENT '',
  `listens` INT NULL COMMENT '',
  PRIMARY KEY (`userID`, `artistID`)  COMMENT '',
  CONSTRAINT `fk_User_Artists_Users`
    FOREIGN KEY (`userID`)
    REFERENCES `mydb`.`Users` (`userID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_User_Artists_Artists1`
    FOREIGN KEY (`artistID`)
    REFERENCES `mydb`.`Artists` (`artistID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

SHOW WARNINGS;
CREATE INDEX `fk_User_Artists_Artists1_idx` ON `mydb`.`User_Artists` (`artistID` ASC)  COMMENT '';

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `mydb`.`User_Friends`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`User_Friends` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `mydb`.`User_Friends` (
  `userID` INT NOT NULL COMMENT '',
  `friendID` INT NOT NULL COMMENT '',
  PRIMARY KEY (`userID`, `friendID`)  COMMENT '',
  CONSTRAINT `fk_User_Friends_Users1`
    FOREIGN KEY (`userID`)
    REFERENCES `mydb`.`Users` (`userID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_User_Friends_Users2`
    FOREIGN KEY (`friendID`)
    REFERENCES `mydb`.`Users` (`userID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

SHOW WARNINGS;
CREATE INDEX `fk_User_Friends_Users2_idx` ON `mydb`.`User_Friends` (`friendID` ASC)  COMMENT '';

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `mydb`.`User_Tags`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`User_Tags` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `mydb`.`User_Tags` (
  `userID` INT NOT NULL COMMENT '',
  `artistID` INT NOT NULL COMMENT '',
  `tagID` INT NOT NULL COMMENT '',
  `day` INT NULL COMMENT '',
  `month` INT NULL COMMENT '',
  `year` INT NULL COMMENT '',
  PRIMARY KEY (`userID`, `artistID`, `tagID`)  COMMENT '',
  CONSTRAINT `fk_User_Tags_Users1`
    FOREIGN KEY (`userID`)
    REFERENCES `mydb`.`Users` (`userID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  #CONSTRAINT `fk_User_Tags_Artists1`
    #FOREIGN KEY (`artistID`)
    #REFERENCES `mydb`.`Artists` (`artistID`)
    #ON DELETE NO ACTION
    #ON UPDATE NO ACTION,
  CONSTRAINT `fk_User_Tags_Tags1`
    FOREIGN KEY (`tagID`)
    REFERENCES `mydb`.`Tags` (`tagID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

SHOW WARNINGS;
CREATE INDEX `fk_User_Tags_Artists1_idx` ON `mydb`.`User_Tags` (`artistID` ASC)  COMMENT '';

SHOW WARNINGS;
CREATE INDEX `fk_User_Tags_Tags1_idx` ON `mydb`.`User_Tags` (`tagID` ASC)  COMMENT '';

SHOW WARNINGS;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;


-- LOAD DATA INTO TABLES
USE mydb;

LOAD DATA LOCAL INFILE '/Users/annekespeijers/Desktop/BGSE/DataWarehousing_BusinessIntelligence/Project/user_friends.dat' 
INTO TABLE Users
FIELDS TERMINATED BY '\t' 
LINES TERMINATED BY '\n' 
IGNORE 1 LINES
(userID, @dummy);
SHOW WARNINGS;

LOAD DATA LOCAL INFILE '/Users/annekespeijers/Desktop/BGSE/DataWarehousing_BusinessIntelligence/Project/artists.dat' 
INTO TABLE Artists
FIELDS TERMINATED BY '\t' 
LINES TERMINATED BY '\n' 
IGNORE 1 LINES
(artistID, artistName, @dummy, @dummy);
#SET max_error_count=220, sql_mode='';
SHOW WARNINGS; 

LOAD DATA LOCAL INFILE '/Users/annekespeijers/Desktop/BGSE/DataWarehousing_BusinessIntelligence/Project/tags.dat' 
INTO TABLE Tags
FIELDS TERMINATED BY '\t' 
LINES TERMINATED BY '\n' 
IGNORE 1 LINES;
SHOW WARNINGS;

LOAD DATA LOCAL INFILE '/Users/annekespeijers/Desktop/BGSE/DataWarehousing_BusinessIntelligence/Project/user_taggedartists.dat' 
INTO TABLE User_Tags
FIELDS TERMINATED BY '\t' 
LINES TERMINATED BY '\n' 
IGNORE 1 LINES;
SHOW ERRORS;

LOAD DATA LOCAL INFILE '/Users/annekespeijers/Desktop/BGSE/DataWarehousing_BusinessIntelligence/Project/user_artists.dat' 
INTO TABLE User_Artists
FIELDS TERMINATED BY '\t' 
LINES TERMINATED BY '\n' 
IGNORE 1 LINES;

LOAD DATA LOCAL INFILE '/Users/annekespeijers/Desktop/BGSE/DataWarehousing_BusinessIntelligence/Project/user_friends.dat' 
INTO TABLE User_Friends
FIELDS TERMINATED BY '\t' 
LINES TERMINATED BY '\n' 
IGNORE 1 LINES;

#SELECT DISTINCT(User_Tags.artistID) FROM User_Tags 
#LEFT OUTER JOIN Artists ON User_Tags.artistID = Artists.artistID
#WHERE Artists.artistID IS NULL;

DROP TABLE IF EXISTS `mydb`.`User_Tags1` ;

CREATE TABLE IF NOT EXISTS `mydb`.`User_Tags1` AS
	SELECT * FROM User_Tags
	WHERE User_Tags.artistID IN (SELECT artistID FROM Artists);

ALTER TABLE `mydb`.`User_Tags1` 	
ADD PRIMARY KEY (`userID`, `artistID`, `tagID`)  COMMENT '',
  ADD CONSTRAINT `fk_User_Tags1_Users1`
    FOREIGN KEY (`userID`)
    REFERENCES `mydb`.`Users` (`userID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_User_Tags1_Artists1`
    FOREIGN KEY (`artistID`)
    REFERENCES `mydb`.`Artists` (`artistID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_User_Tags1_Tags1`
    FOREIGN KEY (`tagID`)
    REFERENCES `mydb`.`Tags` (`tagID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;



