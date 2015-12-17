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

<?php
$isPost = ($_SERVER['REQUEST_METHOD'] == 'POST');
#Take linux timestamp and gets some info from that
$t = explode(' ', microtime());
$t = ltrim($t[0] + $t[1]);
$rEngine = "/usr/bin/Rscript";
$rScript = "/home/ubuntu/projects//bgse-dashboard-project/analysis/graphs.R";
$rCharts = "/var/www/html/MyApp/charts/" . $t;
$selected_artist_id = $_POST["ddlAreas"];
?>

	<p> Interactive part goes here. </p>
	
	<select id="ddlArtist" name="ddlArtist">
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
            
<?php
            if ($isPost && $selected_area_id != -1 && $selected_category_id != -1)
            {
                $cmd = sprintf("%s %s %s %d", $rEngine, $rScript, $rCharts, #  >&1 2>&1
                    $selected_artist_id);
                $result = system($cmd);
                $files = $rCharts . ".*";
                foreach(glob($files) as $file)
                {
                    echo("<tr><td>&nbsp;</td></tr>");
                    echo("<tr><td style='width:100%; text-align:center; align:center'><img style='min-width:800px' src='charts/"
                    . basename($file) . "'/></td></tr>");
                }
            }
?>
	
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
