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
	
	<p> The chart below shows the top 20, most popular artists, based on number their number of listens.</p>

<?php
    // Top 20 Artists
    
   $query = "SELECT t1.artistName, round(t2.listen_count/1000)
             FROM mydb.ArtistsFINAL t1 JOIN
	                (SELECT artistIDNEW, listen_count 
	                FROM mydb.Regression_Vars 
	                ORDER BY listen_count 
	                DESC LIMIT 20) as t2
            ON t1.artistIDNEW = t2.artistIDNEW";
   $title = "Top 20 Artists";
   query_and_print_graph($query,$title,"Listen Count (1000's)");
?>

<p>The chart below shows the average centrality of the people listening to each of the artists shown in the above graph.</p>
	
<?php
	// Mean centrality measure for top 20 artists. 
	
	$query = "SELECT t1.artistName, round(t2.mean_user_central,2)
	          FROM mydb.ArtistsFINAL t1 JOIN
	                (SELECT artistIDNEW, mean_user_central 
	                FROM mydb.Regression_Vars 
	                ORDER BY listen_count 
	                DESC LIMIT 20) as t2
              ON t1.artistIDNEW = t2.artistIDNEW";
	$title = "Mean Centrality for Top 20 Artists";
	query_and_print_graph($query,$title," ");
?>

	<p> Interactive part goes here. </p>


<div>
 <form>
    <p>
	<select id="dropdown" name="dropdown" onchange="java_script_:showgraph(this.options[this.selectedIndex].value)">
		<option value="-1">[Artist]</option>
		<option value="0">Britney Spears</option>
		<option value="1">Depeche Mode</option>
		<option value="2">Lady Gaga</option>
		<option value="3">Christina Aguilera</option>
		<option value="4">Paramore</option>
		<option value="5">Madonna</option>
		<option value="6">Rihanna</option>
		<option value="7">Shakira</option>
		<option value="8">The Beatles</option>
		<option value="9">Katy Perry</option>
		<option value="10">Avril Lavigne</option>
	</select>
    </p>
 </form>
</div>

 
<div id="0" style="display:none" >
<center><img src="categories_network.png" style="width: 40%"></center>
</div>


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
