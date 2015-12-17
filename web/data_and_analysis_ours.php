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
		<option value="289">Britney Spears</option>
		<option value="72">Depeche Mode</option>
		<option value="89">Lady Gaga</option>
		<option value="292">Christina Aguilera</option>
		<option value="498">Paramore</option>
		<option value="67">Madonna</option>
		<option value="288">Rihanna</option>
		<option value="701">Shakira</option>
		<option value="227">The Beatles</option>
		<option value="300">Katy Perry</option>
		<option value="333">Avril Lavigne</option>
		<option value="344">Taylor Swift</option>
		<option value="378">Evanescence</option>
		<option value="679">Glee Cast</option>
		<option value="295">Beyonce</option>
		<option value="511">U2</option>
		<option value="461">Miley Cyrus</option>
		<option value="486">30 Seconds to Mars</option>
		<option value="190">Muse</option>
		<option value="163">Pink Floyd</option>
	</select>
    </p>
 </form>
</div>

<div id="289" style="display:none" >
<center><img src="289.png" style="width: 40%"></center>
</div>
<div id="72" style="display:none" >
<center><img src="72.png" style="width: 40%"></center>
</div>
<div id="89" style="display:none" >
<center><img src="89.png" style="width: 40%"></center>
</div>
<div id="292" style="display:none" >
<center><img src="292.png" style="width: 40%"></center>
</div>
<div id="498" style="display:none" >
<center><img src="498.png" style="width: 40%"></center>
</div>
<div id="67" style="display:none" >
<center><img src="67.png" style="width: 40%"></center>
</div>
<div id="288" style="display:none" >
<center><img src="288.png" style="width: 40%"></center>
</div>
<div id="701" style="display:none" >
<center><img src="701.png" style="width: 40%"></center>
</div>
<div id="227" style="display:none" >
<center><img src="227.png" style="width: 40%"></center>
</div>
<div id="300" style="display:none" >
<center><img src="300.png" style="width: 40%"></center>
</div>
<div id="333" style="display:none" >
<center><img src="333.png" style="width: 40%"></center>
</div>
<div id="344" style="display:none" >
<center><img src="344.png" style="width: 40%"></center>
</div>
<div id="378" style="display:none" >
<center><img src="378.png" style="width: 40%"></center>
</div>
<div id="679" style="display:none" >
<center><img src="679.png" style="width: 40%"></center>
</div>
<div id="295" style="display:none" >
<center><img src="295.png" style="width: 40%"></center>
</div>
<div id="511" style="display:none" >
<center><img src="511.png" style="width: 40%"></center>
</div>
<div id="461" style="display:none" >
<center><img src="461.png" style="width: 40%"></center>
</div>
<div id="486" style="display:none" >
<center><img src="486.png" style="width: 40%"></center>
</div>
<div id="190" style="display:none" >
<center><img src="190.png" style="width: 40%"></center>
</div>
<div id="163" style="display:none" >
<center><img src="163.png" style="width: 40%"></center>
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
