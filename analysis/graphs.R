graphartists <- dbGetQuery(con, "SELECT t1.artistIDNEW, t1.artistName
	          FROM mydb.ArtistsFINAL t1 JOIN
	                (SELECT artistIDNEW, mean_user_central 
	                FROM mydb.Regression_Vars 
	                ORDER BY listen_count 
	                DESC LIMIT 20) as t2
              ON t1.artistIDNEW = t2.artistIDNEW")

for (artist in graphartists$artistIDNEW) {
  graphdata <- user_artists_centrality[user_artists_centrality$artistIDNEW==artist,]
  rownames(graphdata) <- NULL
  
  #edges
  aaa<- merge(graphdata, user_friends, by.x="userID", by.y="userID")
  edges <- aaa[aaa$friendID %in% graphdata$userID, c(1,5)]
  
  net <- graph.data.frame(edges, graphdata, directed=FALSE)
  V(net)$size <- sqrt(V(net)$centrality)*15 #set size of node corresponds to centrality
  V(net)$label <- NA #get rid of node labels
  #graph_layout <- layout.fruchterman.reingold(net)
  title = graphartists[graphartists$artistIDNEW == artist, "artistName"]
  filename = paste("/home/zsuzsa/Documents/project/bgse-dashboard-project/web/",artist,".png",sep="")
  png(file= filename , width=800, height=800 )
  plot(net, vertex.color="orange", edge.color="grey50", edge.curved=0, main=title )
  dev.off()
}
