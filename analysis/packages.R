# Install R packages used by the application at runtime.
# This can require more memory than the smallest AWS instance provides.

install.packages("RMySQL", repos="http://cran.r-project.org", lib="/home/ubuntu/projects/Rlibs/")