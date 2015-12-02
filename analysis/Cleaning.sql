use mydb;

-- Create Function to remove accents
DROP FUNCTION IF EXISTS remove_accents;

DELIMITER //
CREATE FUNCTION remove_accents(`str` VARCHAR(114))
    RETURNS VARCHAR(115)
    -- LANGUAGE SQL
    DETERMINISTIC
	-- NO SQL
    -- SQL SECURITY INVOKER
    -- COMMENT ''
BEGIN
    SET str = REPLACE(str,'Š','S');
    SET str = REPLACE(str,'š','s');
    SET str = REPLACE(str,'Ð','Dj');
    SET str = REPLACE(str,'Ž','Z');
    SET str = REPLACE(str,'ž','z');
    SET str = REPLACE(str,'À','A');
    SET str = REPLACE(str,'Á','A');
    SET str = REPLACE(str,'Â','A');
    SET str = REPLACE(str,'Ã','A');
    SET str = REPLACE(str,'Ä','A');
    SET str = REPLACE(str,'Å','A');
    SET str = REPLACE(str,'Æ','A');
    SET str = REPLACE(str,'Ç','C');
    SET str = REPLACE(str,'È','E');
    SET str = REPLACE(str,'É','E');
    SET str = REPLACE(str,'Ê','E');
    SET str = REPLACE(str,'Ë','E');
    SET str = REPLACE(str,'Ì','I');
    SET str = REPLACE(str,'Í','I');
    SET str = REPLACE(str,'Î','I');
    SET str = REPLACE(str,'Ï','I');
    SET str = REPLACE(str,'Ñ','N');
    SET str = REPLACE(str,'Ò','O');
    SET str = REPLACE(str,'Ó','O');
    SET str = REPLACE(str,'Ô','O');
    SET str = REPLACE(str,'Õ','O');
    SET str = REPLACE(str,'Ö','O');
    SET str = REPLACE(str,'Ø','O');
    SET str = REPLACE(str,'Ù','U');
    SET str = REPLACE(str,'Ú','U');
    SET str = REPLACE(str,'Û','U');
    SET str = REPLACE(str,'Ü','U');
    SET str = REPLACE(str,'Ý','Y');
    SET str = REPLACE(str,'Þ','B');
    SET str = REPLACE(str,'ß','Ss');
    SET str = REPLACE(str,'à','a');
    SET str = REPLACE(str,'á','a');
    SET str = REPLACE(str,'â','a');
    SET str = REPLACE(str,'ã','a');
    SET str = REPLACE(str,'ä','a');
    SET str = REPLACE(str,'å','a');
    SET str = REPLACE(str,'æ','a');
    SET str = REPLACE(str,'ç','c');
    SET str = REPLACE(str,'ć','c');
    SET str = REPLACE(str,'è','e');
    SET str = REPLACE(str,'é','e');
    SET str = REPLACE(str,'ê','e');
    SET str = REPLACE(str,'ë','e');
    SET str = REPLACE(str,'ì','i');
    SET str = REPLACE(str,'í','i');
    SET str = REPLACE(str,'î','i');
    SET str = REPLACE(str,'ï','i');
    SET str = REPLACE(str,'ð','o');
    SET str = REPLACE(str,'ñ','n');
    SET str = REPLACE(str,'ń','n');
    SET str = REPLACE(str,'ò','o');
    SET str = REPLACE(str,'ó','o');
    SET str = REPLACE(str,'ô','o');
    SET str = REPLACE(str,'õ','o');
    SET str = REPLACE(str,'ö','o');
    SET str = REPLACE(str,'ø','o');
    SET str = REPLACE(str,'ù','u');
    SET str = REPLACE(str,'ú','u');
    SET str = REPLACE(str,'û','u');
    SET str = REPLACE(str,'ü','u');
    SET str = REPLACE(str,'ý','y');
    SET str = REPLACE(str,'ý','y');
    SET str = REPLACE(str,'þ','b');
    SET str = REPLACE(str,'ÿ','y');
    SET str = REPLACE(str,'ƒ','f');
    SET str = REPLACE(str,'ż','z');
    SET str = REPLACE(str,';',',');
    RETURN str;
END
//
DELIMITER ;


-- Create new column in table Artists artistNameNorm
ALTER TABLE Artists ADD COLUMN artistNameNorm VARCHAR(115);
SET SQL_SAFE_UPDATES=0;
UPDATE Artists SET artistNameNorm = remove_accents(artistName);
SET SQL_SAFE_UPDATES=1;

-- Update a few records manually
UPDATE `mydb`.`Artists` SET `artistNameNorm`='Blink 182' WHERE `artistID`='7778';
UPDATE `mydb`.`Artists` SET `artistNameNorm`='Blink 182' WHERE `artistID`='7778';
UPDATE `mydb`.`Artists` SET `artistNameNorm`='James Blunt' WHERE `artistID`='8032';
UPDATE `mydb`.`Artists` SET `artistNameNorm`='James Blunt' WHERE `artistID`='8037';
UPDATE `mydb`.`Artists` SET `artistNameNorm`='Glee' WHERE `artistID`='9373';
UPDATE `mydb`.`Artists` SET `artistNameNorm`='Britney Spears' WHERE `artistID`='9374';
UPDATE `mydb`.`Artists` SET `artistNameNorm`='Britney Spears' WHERE `artistID`='9375';
UPDATE `mydb`.`Artists` SET `artistNameNorm`='Rihanna' WHERE `artistID`='9378';
UPDATE `mydb`.`Artists` SET `artistNameNorm`='Britney Spears' WHERE `artistID`='9380';
UPDATE `mydb`.`Artists` SET `artistNameNorm`='EMINEM' WHERE `artistID`='9385';
UPDATE `mydb`.`Artists` SET `artistNameNorm`='Korn' WHERE `artistID`='9473';
UPDATE `mydb`.`Artists` SET `artistNameNorm`='Beyonce' WHERE `artistID`='10821';
UPDATE `mydb`.`Artists` SET `artistNameNorm`='Panic! At the Disco' WHERE `artistID`='10986';
UPDATE `mydb`.`Artists` SET `artistNameNorm`='All Time Low' WHERE `artistID`='11273';
UPDATE `mydb`.`Artists` SET `artistNameNorm`='All Time Low' WHERE `artistID`='11274';
UPDATE `mydb`.`Artists` SET `artistNameNorm`='SoundGarden' WHERE `artistID`='13060';
UPDATE `mydb`.`Artists` SET `artistNameNorm`='Ayo' WHERE `artistID`='13715';
UPDATE `mydb`.`Artists` SET `artistNameNorm`='Beyonce' WHERE `artistID`='14335';
UPDATE `mydb`.`Artists` SET `artistNameNorm`='Boppin\' B' WHERE `artistID`='14496';
UPDATE `mydb`.`Artists` SET `artistNameNorm`='Katy Perry' WHERE `artistID`='14557';
UPDATE `mydb`.`Artists` SET `artistNameNorm`='Nicole Scherzinger' WHERE `artistID`='15470';
UPDATE `mydb`.`Artists` SET `artistNameNorm`='Chris Brown' WHERE `artistID`='15471';
UPDATE `mydb`.`Artists` SET `artistNameNorm`='Paramore' WHERE `artistID`='15929';
UPDATE `mydb`.`Artists` SET `artistNameNorm`='YOU THE ROCK' WHERE `artistID`='16168';
UPDATE `mydb`.`Artists` SET `artistNameNorm`='buried cable' WHERE `artistID`='18277';
UPDATE `mydb`.`Artists` SET `artistNameNorm`='Lindsay Lohan' WHERE `artistID`='18194'; 

-- Remove rows with unusual characters
DROP TABLE IF EXISTS ArtistsNEW;
CREATE TABLE ArtistsNEW AS
	(SELECT artistID, artistNameNorm AS artistName
    FROM Artists
    WHERE artistNameNorm REGEXP "^[A-Za-z0-9 !.,'&?$+:/\"()*-]+$");
    
-- Add column for unique artistID's (artistIDNEW)
DROP TABLE IF EXISTS ArtistsFINAL;
CREATE TABLE ArtistsFINAL AS
	(SELECT t1.artistID, 
			t2.wantedid AS artistIDNEW,
			t1.artistName
	FROM ArtistsNEW AS t1
	LEFT JOIN 
		(SELECT MIN(artistID) AS wantedid, artistName
		FROM ArtistsNEW
		GROUP BY artistName) AS t2
     ON t1.artistName = t2.artistName
     );

-- Add new artist ID's to User_Artists table
DROP TABLE IF EXISTS User_ArtistsFINAL;
CREATE TABLE User_ArtistsFINAL AS
	(SELECT t3.userID 		AS userID, 
            t4.artistIDNEW 	AS artistIDNEW,
            sum(t3.listens) AS listens
    FROM User_Artists t3 
		JOIN ArtistsFINAL t4 
        ON t3.artistID = t4.artistID
        GROUP BY userID, artistIDNEW
	);

-- Add new artist ID's to User_Tags table
DROP TABLE IF EXISTS User_TagsFINAL;
CREATE TABLE User_TagsFINAL AS
	(SELECT t5.userID 		AS userID, 
			t6.artistIDNEW 	AS artistIDNEW,
            t5.tagID		AS tagID,
            t5.day			AS day,
            t5.month		AS month,
            t5.year			AS year
    FROM User_Tags t5 
		JOIN ArtistsFINAL t6 
        ON t5.artistID = t6.artistID
	);

DROP TABLE ArtistsNEW;

