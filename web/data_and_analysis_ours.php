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
	
	<p>The challenge of our project is to predict the future success of artists based on the distinct characteristics of their fans. We use the <b><a href="http://grouplens.org/datasets/hetrec-2011/" target="_blank">LAST.FM dataset</a></b> which contains approximately 18,000 distinct artists, 1,900 Users, 12,000 Tags(made by users), 13,000 Connections among Users and 93,000 Connections between Users and Artists. Particularly, given the dataset of the <b><a href="http://www.last.fm/" target="_blank">LAST.FM</a></b> we are trying to analyze various aspects of the social behavior of users and based on that to infer whether there is a relation between success and fan quality. Success of an artist is measured by the listen counts. Moreover, a certain challenge is imposed because our dataset has absence of time dimension and also contains duplicate artists names, tags with special characters or ambiguous meaning.</p>
	
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

	<p> Please select an artist to see how the network of his or her users looks like! Check out the tags related to that artist as well! </p>


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

<div id="289" style="display:none; text-align: center" >
<img src="289.png" style="width: 44%"> <img src="289_wc.svg" style="width: 46%">
</div>
<div id="72" style="display:none; text-align: center" >
<img src="72.png" style="width: 44%"> <img src="72_wc.svg" style="width: 46%">
</div>
<div id="89" style="display:none; text-align: center" >
<img src="89.png" style="width: 44%"> <img src="89_wc.svg" style="width: 46%">
</div>
<div id="292" style="display:none; text-align: center" >
<img src="292.png" style="width: 44%"> <img src="292_wc.svg" style="width: 46%">
</div>
<div id="498" style="display:none; text-align: center" >
<img src="498.png" style="width: 44%"> <img src="498_wc.svg" style="width: 46%">
</div>
<div id="67" style="display:none; text-align: center" >
<img src="67.png" style="width: 44%"> <img src="67_wc.svg" style="width: 46%">
</div>
<div id="288" style="display:none; text-align: center" >
<img src="288.png" style="width: 44%"> <img src="288_wc.svg" style="width: 46%">
</div>
<div id="701" style="display:none; text-align: center" >
<img src="701.png" style="width: 44%"> <img src="701_wc.svg" style="width: 46%">
</div>
<div id="227" style="display:none; text-align: center" >
<img src="227.png" style="width: 44%"> <img src="227_wc.svg" style="width: 46%">
</div>
<div id="300" style="display:none; text-align: center" >
<img src="300.png" style="width: 44%"> <img src="300_wc.svg" style="width: 46%">
</div>
<div id="333" style="display:none; text-align: center" >
<img src="333.png" style="width: 44%"> <img src="333_wc.svg" style="width: 46%">
</div>
<div id="344" style="display:none; text-align: center" >
<img src="344.png" style="width: 44%"> <img src="344_wc.svg" style="width: 46%">
</div>
<div id="378" style="display:none; text-align: center" >
<img src="378.png" style="width: 44%"> <img src="378_wc.svg" style="width: 46%">
</div>
<div id="679" style="display:none; text-align: center" >
<img src="679.png" style="width: 44%"> <img src="679_wc.svg" style="width: 46%">
</div>
<div id="295" style="display:none; text-align: center" >
<img src="295.png" style="width: 44%"> <img src="295_wc.svg" style="width: 46%">
</div>
<div id="511" style="display:none; text-align: center" >
<img src="511.png"style="width: 44%"> <img src="511_wc.svg" style="width: 46%">
</div>
<div id="461" style="display:none; text-align: center" >
<img src="461.png" style="width: 44%"> <img src="461_wc.svg" style="width: 46%">
</div>
<div id="486" style="display:none; text-align: center" >
<img src="486.png" style="width: 44%"> <img src="486_wc.svg" style="width: 46%">
</div>
<div id="190" style="display:none; text-align: center" >
<img src="190.png" style="width: 44%"> <img src="190_wc.svg" style="width: 46%">
</div>
<div id="163" style="display:none; text-align: center" >
<img src="163.png" style="width: 44%"> <img src="163_wc.svg" style="width: 46%">
</div>

	</div>
	<div id="analysis" style="display: none">
	<h2>Analysis</h2>
	
	<p>The variable analysis consists of three main parts:
				<ul style="list-style-type:circle">
					<li>Tag Sentiment Analysis. 
The notion behind this measure is to examine whether users opinions and feelings could be indicative of an artist's popularity.
Initially, we classified by hand a small subset of tags 1,0,-1 as positive,neutral,negative respectively. Next, we counted the positive/neutral/negative words in given tag using an exhaustive list of words classified from -5 to 5 as very negative to very positive respectively. Finally, we trained the Naive Bayesian Classifier using a random subset of classified tags in order to predict the sentiment of the tags.  </li>
					<li>Centrality.
The idea behind this measure is to take advantage of the actual connections between users in the database. Intuitively, the more central a user is the more infuential he becomes. Therefore the success of a particular artist is directly linked with the centrality of his fans. 
The measure for centrality which we chose is the eigenvector centrality. In this measure a certain user is not considered influential only if he has many friends in the dataset but also when his friends have many connections as well.</li>
					<li>Tag Count.
This is another aspect of the users' social behavior and measures user activity. The intuition is that the opinion of active users will affect more people. We simply aggregated the number of counts for each user and then computed the average number of tags for each artist.</li>
				</ul>
</p>
		
    <h2>Regression Analysis:</h2>
<p>We run an artist level regression in order to explore the relationship between the characteristics of the audience of an artist and his/her success. Our regression is a simple linear regression with non-linear transformations to account for curvature and skewedness. Then we control for the first appearence of an artist in the LAST.FM database to check if our results change or are significantly different.
In our findings we see that centrality plays a significant role for the success of an artist in both the regression on the total sample as well as when we control for the first appearence of an artist.</p>	
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
