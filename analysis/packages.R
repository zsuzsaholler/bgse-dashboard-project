# Install R packages used by the application at runtime.
# This can require more memory than the smallest AWS instance provides.

install.packages("RMySQL", repos="http://cran.r-project.org")
install.packages("igraph", repos="http://cran.r-project.org")
install.packages("dplyr", repos="http://cran.r-project.org")
install.packages("stringr", repos="http://cran.r-project.org")
install.packages("e1071", repos="http://cran.r-project.org")
install.packages("sandwich", repos="http://cran.r-project.org")
install.packages("lmtest", repos="http://cran.r-project.org")
install.packages("wordcloud", repos="http://cran.r-project.org")