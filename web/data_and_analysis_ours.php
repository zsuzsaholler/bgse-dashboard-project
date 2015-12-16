<?php

	include 'functions_ours.php';
	$GLOBALS['graphid'] = 0;

	// Load libraries
	document_header();

	// Create connection
	$link = connect_to_db();
?>
	<div id="data" style="display: none">
	
	<h2>Data</h2>
	
	<p>Data description goes here.</p>
	
	<p> Here are the bar charts.</p>

<?php
    // Total Revenue by product
    
   // $query = "SELECT ProductName, Revenue FROM ecommerce.ProductsVsCustomers_Pivot ORDER BY Revenue DESC limit 10";
   // $title = "Products by revenues";
   // query_and_print_graph($query,$title,"Euros");
?>

	<p> Interactive part goes here. </p>
	
	<center><img src="categories_network.png" style="width: 40%"></center>


	</div>
	<div id="analysis" style="display: none">
	<h2>Analysis</h2>
	
	<p>Description of analysis part goes here</p>
			
<?php

//	$query = "SELECT * FROM ecommerce.apriori";
//	$title = "Recommendation rules";
//	query_and_print_table($query,$title);
//	echo "";
?>


		</div>
<?php
	// Close connection
	mysql_close($link);
?>
