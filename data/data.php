<?php

include 'functions.php';

$GLOBALS['graphid'] = 0;

// Load libraries
document_header();
// Create connection
$link = connect_to_db();



// Page body. Write here your queries
$query = "SELECT * FROM onlinestore.Customer";
$title = "Customer list";
query_and_print_table($query,$title);
echo "Comment 1";

$query = "SELECT * FROM onlinestore.Product LIMIT 5";
$title = "Product list (10 elements)";
query_and_print_table($query,$title);
echo "Comment 2";

// query_and_print_graph: Needs two columns: the first one with labels, the second one with values of the graph
$query = "SELECT productname, currentunitprice FROM onlinestore.Product ORDER BY currentunitprice DESC LIMIT 10";
$title = "Top products";
query_and_print_graph($query,$title,"Euros");
echo "Comment 3";

$query = "SELECT productname, currentunitprice FROM onlinestore.Product ORDER BY currentunitprice ASC LIMIT 10";
$title = "Top cheap products";
query_and_print_graph($query,$title,"Euros");
echo "Comment 4";



// Close connection
mysql_close($link);
?>
