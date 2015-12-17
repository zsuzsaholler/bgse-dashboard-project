library(RMySQL)
library(igraph)
library(dplyr)
library("stringr")
library(e1071)
library("sandwich")
library("lmtest")


#connect to db
con <- dbConnect(RMySQL::MySQL(), 
                 username = "root",
                 password = "root",
                 host = "localhost",
                 port = 3306,
                 dbname = "mydb")

#Show tables
#dbListTables(con, mydb)

########## Dependent Variable - Listen Counts per Artists
user_artists <- dbReadTable(con, "User_ArtistsFINAL")
by_artist <- group_by(user_artists, artistIDNEW)
X0 <- as.data.frame(summarise(by_artist, listen_count = sum(listens)))

########## Centrality
user_friends <- dbReadTable(con, "User_Friends")
graph <- graph.data.frame(user_friends)

s641_social_undirected <- as.undirected(graph, mode='collapse')
ev_obj_social <- evcent(s641_social_undirected)
eigen_social <- ev_obj_social$vector
user_centrality <- data.frame(as.numeric(V(graph)$name),eigen_social)
colnames(user_centrality) <- c("userID", "centrality")

user_artists_centrality <- merge(user_artists, user_centrality, by.x="userID", by.y="userID")
by_artist <- group_by(user_artists_centrality, artistIDNEW)
X1 <- as.data.frame(summarise(by_artist, mean_user_central = mean(centrality)))

########## Tag sentiment analysis
tags <- dbReadTable(con, "Tags")

#Loading in tag sample with sentiments assigned
tags.classified <- dbReadTable(con, "Tags_Classified")
tags.classified[3] = as.factor(tags.classified[,3])

afin_list <- dbReadTable(con, "Afin_Words")
names(afin_list) <- c('word', 'score')

afin_list$word <- tolower(afin_list$word)
#Split word list by sentiment
afin_list_split = split(afin_list,afin_list[,"score"])
afin_list_split = afin_list_split[-6]

#Function to count number of words in each tag matching the elements of a word list 
sentimentScore <- function(sentences, terms){
    final_scores <- matrix('', 0, 3)
    sentences = as.matrix(sentences)
    terms = unlist(terms)
    scores <- apply(sentences,1, function(sentence, terms){
        initial_sentence <- sentence
        sentence <- sentence[2]
        #remove unnecessary characters and split up by word 
        sentence <- gsub("-"," ",sentence)
        sentence <- gsub("[^A-Za-z ]","",sentence)
        sentence <- gsub('[[:punct:]]', '', sentence)
        sentence <- gsub('[[:cntrl:]]', '', sentence)
        sentence <- gsub('\\d+', '', sentence)
        sentence <- tolower(sentence)
        wordList <- str_split(sentence, '\\s+')
        words <- unlist(wordList)
        #build vector with matches between sentence and each category
        Matches <- match(words, terms)
        #sum up number of words in each category
        Matches <- sum(!is.na(Matches))
        #add row to scores table
        #newrow <- c(initial_sentence, Matches)
        return(Matches)
    }, terms)
    return(data.frame(sentences,scores))
}

#Training Naive Bayes classifier
##Run sentimentScore function on tag sample
scores.classification = tags.classified
i=0
for (elements in afin_list_split) {
    i=i+1
    sentiment = elements[1,2]
    scores.classification = cbind(scores.classification, sentimentScore(tags.classified[,1:2],elements[,1])[,3])
    names(scores.classification)[i+3] = sentiment
}

scores.classification[,4:13] = scores.classification[,4:13] > 0
scores.classification[,4:13] = lapply(scores.classification[,4:13],function(x){factor(x,levels=c("TRUE","FALSE"))})

##Split sample data to training and test set 
train.sample = sample(unlist(scores.classification[,1]),200)
train.sample = scores.classification$tagID %in% train.sample
scores.classification.train = scores.classification[train.sample,]
scores.classification.test = scores.classification[!train.sample,]
##run the naive bayes algorithm using 10 categories of words from (-5 to 5)
##and sentiments positive-neutral-negative (1 0 -1) for tags
classifier <- naiveBayes(scores.classification.train[,4:13], unlist(scores.classification.train[,3]))
scores.classification = cbind(scores.classification , predicted = predict(classifier, scores.classification[,4:13]))
##display the confusion table for the classification ran on training and test data
confTable.train <- table(predict(classifier, scores.classification.train[,4:13]), unlist(scores.classification.train[,3]),
                         dnn=list('predicted','actual'))
confTable.test <- table(predict(classifier, scores.classification.test[,4:13]), unlist(scores.classification.test[,3]),
                        dnn=list('predicted','actual'))
#ideas to make it better: remove band names and genres, add words from the classified set
table.train = confTable.train
table.test = confTable.test

#Run classification on all of the tags
scores.all = tags
i=0
for (elements in afin_list_split) {
    i=i+1
    sentiment = elements[1,2]
    scores.all = cbind(scores.all, sentimentScore(tags,elements[,1])[,3])
    names(scores.all)[i+2] = sentiment
}

scores.all[,3:12] = scores.all[,3:12] > 0
scores.all[,3:12] = lapply(scores.all[,3:12],function(x){factor(x,levels=c("TRUE","FALSE"))})

scores.all = cbind(scores.all , predicted = predict(classifier, scores.all[,3:12]))

user_tags <- dbReadTable(con, "User_TagsFINAL")
user_tags_sentiment <- merge(user_tags, scores.all, by.x="tagID", by.y="tagID")
by_artist <- group_by(user_tags_sentiment, artistIDNEW)
X2 <- as.data.frame(summarise(by_artist, positive_tags = sum(predicted %in% 1), positive_to_total_tags = positive_tags/sum(predicted %in% c(-1,0,1))))

########## Tag count of users
X3 <- dbGetQuery(con, "SELECT * FROM Users_of_artists_tag_activity")


########## Time of first tag
Dates <- paste(sprintf("%02d", user_tags$day), sprintf("%02d",user_tags$month), user_tags$year, sep="/")
user_tags$Dates <- as.Date(Dates, "%d/%m/%Y")
by_artist <- group_by(user_tags, artistIDNEW)
artist_first_tag <- as.data.frame(summarise(by_artist, first_tag=min(Dates) ))
artist_first_tag[artist_first_tag$first_tag < "2005-08-01","first_tag"] = "2005-08-01"
artist_first_tag$year_month = factor(format(artist_first_tag$first_tag, format = "%Y %B"))
X4 <- artist_first_tag

RegressionVars = data.frame()
RegressionVars <- merge(X2, X3, by.x="artistIDNEW", by.y="artistIDNEW")
RegressionVars <- merge(X1, RegressionVars, by.x="artistIDNEW", by.y="artistIDNEW")
RegressionVars <- merge(X0, RegressionVars, by.x="artistIDNEW", by.y="artistIDNEW")
RegressionVars <- merge(X4, RegressionVars, by.x="artistIDNEW", by.y="artistIDNEW")


##### REGRESSION
RegressionVars$log_listen_count = log(RegressionVars$listen_count)
RegressionVars$log_positive_to_total_tags = log(1 + RegressionVars$positive_to_total_tags)
RegressionVars$log_mean_user_central = log(1 + RegressionVars$mean_user_central)
RegressionVars$sq_mean_user_central = RegressionVars$mean_user_central**2
RegressionVars$cub_mean_user_central = RegressionVars$mean_user_central**3
RegressionVars$log_avg_tag_count = log(RegressionVars$avUserTagCount)

#####Definition of input and output variables
output = "log_listen_count"
input = c("mean_user_central","log_avg_tag_count"
          ,"log_positive_to_total_tags")
input_transf= c("sq_mean_user_central","year_month")
expr = paste( output , "~", paste(input,collapse= " + " ), "+" ,  paste(input_transf,collapse= " + " ))

#####Some descriptives
#png(file="/home/zsuzsa/Documents/project/bgse-dashboard-project/pairwise.png", width=800, height=800 )
#dev.off()

######Define subset
subset = RegressionVars[RegressionVars$first_tag > "2010-01-01",]

#Fit regression on total sample
fit = lm(expr, data = RegressionVars)
###Heteroskedasticity robust (White) se estimator
fit$newse = vcovHC(fit,type="HC")
fit.results = coeftest(fit,fit$newse)

#Fit regression on subsample
fit.subset = lm(expr, data = subset)
fit.subset$newse = vcovHC(fit.subset,type="HC")
fit.subset.results = coeftest(fit.subset,fit.subset$newse)



#Exporting SQL table
dbSendQuery(con,"DROP TABLE IF EXISTS Regression_Vars")
dbWriteTable(con, "Regression_Vars", RegressionVars, row.names=FALSE)

##########################GRAPHS#############################
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
  filename = paste("/var/www/html/MyApp/",artist,".png",sep="")
  png(file= filename , width=800, height=800 )
  plot(net, vertex.color="orange", edge.color="grey50", edge.curved=0, main=title )
  dev.off()
}
