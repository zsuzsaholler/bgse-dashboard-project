setwd("~/Desktop/BGSE/DataWarehousing_BusinessIntelligence/Project")

#readLines("user_taggedartists-timestamps.dat", n=5)
user.artist.tag.timestamp <- read.table("user_taggedartists-timestamps.dat", header=TRUE, sep= "\t", stringsAsFactors=FALSE)
head(user.artist.tag.timestamp, 5)
dim(user.artist.tag.timestamp) # 186,479 x 4
min(user.artist.tag.timestamp[,4])
max(user.artist.tag.timestamp[,4])

#readLines("user_taggedartists.dat", n=5)
user.artist.tag.date <- read.table("user_taggedartists.dat", header=TRUE, sep= "\t", stringsAsFactors=FALSE)
head(user.artist.tag.date)
dim(user.artist.tag.date) # 186,479 x 6


# Count total tags per artist
max(user.artist.tag.date[,2]) # 18744
min(user.artist.tag.date[,2]) # 1
tag.count <- rep(0,18744)
for (i in 1:186479) {
    artist <- user.artist.tag.date[i,2]
    tag.count[artist] <- tag.count[artist] + 1
}
max(tag.count) #931
min(tag.count) #0

plot(1:18744,tag.count, xlab= "artists", ylab= "no. of tags", main= "No of tags per artist")

# Count total tags per user
max(user.artist.tag.date[,1]) # 2100
min(user.artist.tag.date[,1]) # 2
tag.count.user <- rep(0,2100)
for (i in 1:186479) {
    user <- user.artist.tag.date[i,1]
    tag.count.user[user] <- tag.count.user[user] + 1
}
max(tag.count.user) #2609
min(tag.count) #0

plot(1:2100,tag.count.user, xlab= "users", ylab= "no. of tags", main= "No of tags per user")
