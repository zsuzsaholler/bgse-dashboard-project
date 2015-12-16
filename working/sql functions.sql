use mydb;

# Select top 20 artists
SELECT t1.artistName, t2.listen_count 
FROM ArtistsFINAL t1 JOIN
	(SELECT artistIDNEW, listen_count FROM Regression_Vars ORDER BY listen_count DESC LIMIT 20) as t2
    ON t1.artistIDNEW = t2.artistIDNEW;
    
# Select mean user centrality for top 20 artists
SELECT t1.artistName, round(t2.mean_user_central,2)
FROM ArtistsFINAL t1 JOIN
	(SELECT artistIDNEW, mean_user_central FROM Regression_Vars ORDER BY listen_count DESC LIMIT 20) as t2
    ON t1.artistIDNEW = t2.artistIDNEW;

