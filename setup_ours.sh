#!/bin/bash

# installion script

cmd=$1

user=`grep dbuser service.conf | cut -f2 -d' '`
pswd=`grep dbpswd service.conf | cut -f2 -d' '`

case $cmd in

install)
	echo "Installing"
	mysql -u $user -p$pswd < db/Schema_creation.sql
	mysql -u $user -p$pswd < data/dump.sql
	mysql -u $user -p$pswd < data/Cleaning.sql

	mkdir -p "/var/www/html/MyApp"
	cp -rf web/* "/var/www/html/MyApp"

	echo "done!"
	;;

uninstall)
	echo "Uninstalling"
	
	mysql -u $user -p$pswd -e "DROP DATABASE mydb;" 
	rm -rf "/var/www/html/MyApp"

	echo "done!"
	;;

run)
	echo "Running"
	mysql -u $user -p$pswd < data/TagCount.sql
	echo "Installing R packages"
	sudo Rscript analysis/packages.R 
	echo "Running the analysis"
	sudo Rscript analysis/analysis.R 
	cat analysis.Rout
	rm analysis.Rout

	;;

*)
	echo "Unknown Command!"

esac
