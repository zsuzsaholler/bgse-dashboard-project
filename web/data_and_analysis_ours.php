<?php

	include 'functions_ours.php';
	$GLOBALS['graphid'] = 0;

	// Load libraries
	document_header();

	// Create connection
	$link = connect_to_db();
?>
	<div id="data" style="display: none">
	
	<h1>Data</h1>
	
	<p>We use the <b><a href="http://grouplens.org/datasets/hetrec-2011/" target="_blank">LAST.FM dataset</a></b> which contains information on approximately 18,000 artists, 1,900 users, 12,000 end-user tags, 13,000 connections among users and 93,000 user-artist connections with listen count information. The dataset used for the analysis was cleaned to make it easily accessible and managable. Note, that the dataset lacks time dimension for the listen count information, which makes the analysis challenging.</p>
	
<p>Our main variable of interest is the success of an artist measured by the overall number of listens to the given artist recorded in the Last.fm system. Let's see the top 20, most popular artists, based on their number of listens.</p>
	
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

<h2>Centrality</h2>
<p>Do the opinion of more central users matter more? Is it more likely to become succesful if more influential users listen to you music? Intuitively, the more central a user is, the more infuential he should be. We therefore expect the success of a particular artist to be directly linked with the centrality of his fans. We combine the information on social connecions of users and their listening history to define the artist level centrality measure used in the regression analysis.</p>
<p>The measure for user centrality which we chose is <b><a href="https://en.wikipedia.org/wiki/Centrality#Eigenvector_centrality" target="_blank">eigenvector centrality</a></b>. In this measure a certain user is not considered influential only if he has many friends in the dataset but also when his friends have many connections as well. Using this measure, each user has a centrality score between 0 and 1, where 1 is the most central.</p>
<p>Our final measure used in the regression analysis is the mean level of centrality of users listening to a given artist. The chart below shows the average centrality of listeners for each of the top 20 succesful artists.</p>
	
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

<h2>Tag Count</h2>
<p>Do the opinion of more active users affect more people? Is it more likely to become succesful if your fans are more active in the system? Number of tags assigned by a user is another aspect of the user's social behavior and is a measure of user activity. Similar to central users, we expect that more active users will be more influential and thus the artists they listen to to be more successful.</p>
<p>To define our final measure used in the regression analysis, first we count the number of tags created by each user (on all artists) and then aggregated this to artist level by taking the average number or tags created by an artist's listeners. The chart below shows the mean of the number of tags assigned by the listeners of the top 20 succesful artists.</p>

<?php
	// Average tag count measure for top 20 artists. 
	
	$query = "SELECT t1.artistName, round(avUserTagCount,1)
             FROM mydb.ArtistsFINAL t1 JOIN
	                (SELECT artistIDNEW, avUserTagCount
	                FROM mydb.Regression_Vars 
	                ORDER BY listen_count 
	                DESC LIMIT 20) as t2
            ON t1.artistIDNEW = t2.artistIDNEW";
	$title = "Average Tag Count of the Listeners for Top 20 Artists";
	query_and_print_graph($query,$title," ");
?>

	

</div>
	
<div id="analysis" style="display: none">
	<h1>Analysis</h1>

<h2>Tag Sentiment Analysis</h2>
<p>Can the opinions and feelings of users expressed in tags might help to predict the success of an artist? The first step in analysing whether users opinions and feelings could be indicative of an artist's popularity is to identify the sentiments embodied in each of the tags assigned by the users. The achieve this we used an <abbr title="Minqing Hu and Bing Liu. Mining and Summarizing Customer Reviews. Proceedings of the ACM SIGKDD International Conference on Knowledge Discovery and Data Mining (KDD-2004), Aug 22-25, 2004, Seattle, Washington, USA">exhaustive list</abbr> of words  classified from very positive to very negative and trained a <b><a href="https://en.wikipedia.org/wiki/Naive_Bayes_classifier" target="_blank">Naive Bayesian Classifier</a></b> to determine the overall sentiment of tags. After classifying all of the tags, we defined our final input variable used in the regression analysis; the ratio of positive to total number of tags assigned to a given artist.</p>

<p>Initially, we classified by hand a small subset of tags as positive, neutral or negative. Next, we counted the positive/neutral/negative words in these tags using the list of pre-classified words. Then, we trained the Naive Bayes classifier on a random subset of classified tags and tested the predicions on the remaining set of classified tags. The table below shows the predictive success of the classifier on our training and test data. It can be seen that the automatized classification is not pefect, but it serves our purposes since it found a fair amount of positive tags and more importantly it produce only a relatively small number of fake positive results. Finally, we the whole set of tags were classified using the Naive Bayes classifier.
</p>

<?php
	// Predicted and Actual pivot tables for tag sentiment on training set
	
	$query = "SELECT row_names as Sentiment, Negative, Neutral, Positive FROM mydb.Tag_Sentiment_Training";
	$title = "Actual vs Predicted Tag Sentiment - Training Set";
	query_and_print_table($query,$title," ");
	
	$query = "SELECT row_names as Sentiment, Negative, Neutral, Positive FROM mydb.Tag_Sentiment_Test";
	$title = "Actual vs Predicted Tag Sentiment - Test Set";
	query_and_print_table($query,$title," ");
?>

<h2>User network and tags cloud of top artists</h2>
<p> Before we turn to the regression analysis let's see a few examples! Please select an artist to see how the network of his or her users looks like! Check out the tags related to that artist as well! Let's see if we can identify any patterns or differences between artists? </p>

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
		
    <h2>Regression Analysis</h2>
<p>In the final setp of the analysis we run an artist level regression in order to explore the relationship between the characteristics of the audience of an artist and his/her success. Our regression is a simple linear regression with non-linear transformations to account for curvature and skewedness of the independent variables. We also control for the amount of time an artist has been present in the database by looking at the date they were first tagged.</p>
<p>We run a regression on the total sample or artists, as well as a subset which is made up of artists who only appeared in the database in the last 16 months and is therefore meant to represent "new and up and coming" artists. The table below shows the results of these two regressions.</p>
<p>We get statistically significant coefficient estimates for all our indepedant variables apart from those relating to tags in the new and up and coming subset which we put down to lack of tag data. As expected, both listener average tag count and the ratio of positive to total tags, positively affect artist listen count. We also find that listener mean centrality has a positive affect on artist success, however our regression fits poorely for artists with very high mean user centrality. </p>	
<?php
    
    $query = "SELECT row_names as Variables, 
                     round(Estimate,4) as Estimate, 
                     round(Std_Error,4) as StdError, 
                     round(t_Value,4) as tValue, 
                     round(Prob_gt_t,4) as pValue
              FROM mydb.Regression_Coefficients";
	$title = "Regression Coefficients - Total Sample";
	query_and_print_table($query,$title," ");
	
	$query = "SELECT row_names as Variables, 
                     round(Estimate,4) as Estimate, 
                     round(Std_Error,4) as StdError, 
                     round(t_Value,4) as tValue, 
                     round(Prob_gt_t,4) as pValue
              FROM mydb.Regression_Coefficients_Subset";
	$title = "Regression Coefficients - New Artist Subset";
	query_and_print_table($query,$title," ");
?>


		</div>
<?php
	// Close connection
	mysql_close($link);
?>
