setwd("~/Desktop/BGSE/DataWarehousing_BusinessIntelligence/Project")

#readLines("user_artists.dat", n=5)
user.artists <- read.table("user_artists.dat", header=TRUE, sep = "\t" )
head(user.artists)
View(user.artists)
dim(user.artists) # 92834 x 3
max(user.artists[,2]) #highest ID number of artists: 18745
min(user.artists[,2]) #lowest ID number of artists: 1
max(user.artists[,1]) #highest ID number of users: 2100
min(user.artists[,1]) #min ID number of users: 2

# Count total listens per artist
listen.count <- rep(0,18745)
for (i in 1:92834) {
    artist <- user.artists[i,2]
    listen.count[artist] <- listen.count[artist] + user.artists[i,3]
}

plot(1:18745,listen.count, xlab = "artists", ylab = "listen count", main = "Listen count for artists")
max(listen.count)

#This is the best one.
log.listen.count <- log(listen.count)
plot(1:18745,log.listen.count, xlab = "artists", ylab = " log-listen count", main = "Log-listen count for artists")
hist(log.listen.count, 100, freq=FALSE)
mean <- mean(log.listen.count)
std <- sd(log.listen.count)
curve(dnorm(x, mean=mean, sd=std), col="darkblue", lwd=2, add=TRUE, yaxt="n")

sqrt.listen.count <- sqrt(listen.count)
plot(1:18745,sqrt.listen.count, xlab = "artists", ylab = "sqrt of listen count", main = "Sqrt of listen count for artists")
hist(sqrt.listen.count, 50, freq=FALSE)


#check how many artists have zero listens
sum(listen.count == 0) #1113 = 18745 - 17632

# Count total listens per user
listen.count.users <- rep(0,2100)
for (i in 1:92834) {
    user <- user.artists[i,1]
    listen.count.users[user] <- listen.count.users[user] + user.artists[i,3]
}
plot(1:2100,listen.count.users, xlab = "users", ylab = "listen count", main = "Listen count for users")
abline(100000,0, col = "red")

#check how many users have zero listens
sum(listen.count.users == 0) #208 = 2100 - 1892

# look at users listening to artist 289 (Britney Spears)
listens289 <- as.vector(NULL)
for (i in 1:92834) {
    if (user.artists[i,2] == 289) {
        #user <- user.artists[i,1]
        listens289 <- c(listens289,user.artists[i,3])
    }
}

length(listens289) #522
sample.mean <- 1/length(listens289) * sum(listens289) #4584
sample.var <- 1/(length(listens289)-1) * sum((listens289-sample.mean)^2) # std dev = 12,200
plot(1:522,listens289, xlab="users who listen to Britney Spears", ylab="no. of listens", main="listening distribution for Britney Spears")
abline(4584,0)

readLines("artists.dat", n =5)
artist.ids <- read.table("artists.dat", header=TRUE, sep = "\t")

