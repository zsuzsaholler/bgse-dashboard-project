#!/bin/bash

# installion script

cmd=$1

user=`grep dbuser service.conf | cut -f2 -d' '`
pswd=`grep dbpswd service.conf | cut -f2 -d' '`

case $cmd in

install)
	echo "Installing"

	mysql -u $user < db/ecommerce.sql
	mysql -u $user < data/ecommerce-dump.sql

	mkdir -p "$HOME/public_html/MyApp"
	cp -rf web/* "$HOME/public_html/MyApp"

	echo "done!"
	;;

uninstall)
	echo "Uninstalling"
	
	mysql -u $user -e "DROP DATABASE ecommerce;" 
	rm -rf "$HOME/public_html/MyApp"

	echo "done!"
	;;

*)
	echo "Unknown Command!"

esac
