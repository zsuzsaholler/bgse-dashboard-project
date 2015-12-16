USE mydb;

DROP VIEW IF EXISTS tags_per_user;
CREATE VIEW tags_per_user AS
(SELECT userID,count(tagID) AS userTagCount
FROM User_TagsFINAL 
GROUP BY userID);

DROP VIEW IF EXISTS Users_of_artists_tag_activity;
CREATE VIEW Users_of_artists_tag_activity AS
	(SELECT t1.artistIDNEW, AVG(t2.userTagCount) AS avUserTagCount
	FROM User_ArtistsFINAL t1 
	INNER JOIN tags_per_user t2 ON t1.userID=t2.userID
	GROUP BY artistIDNEW
	);
