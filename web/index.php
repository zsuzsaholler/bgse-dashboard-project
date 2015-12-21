<?php ?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
<html>
<head>
	<title>MyApp</title>    
	<link rel="stylesheet" type="text/css" href="style.css" />
</head>
<script>
/**
 * Given an element, or an element ID, blank its style's display
 * property (return it to default)
 */
function show(element) {
    if (typeof(element) != "object")	{
	element = document.getElementById(element);
    }
    
    if (typeof(element) == "object") {
	element.style.display = '';
    }
}

/**
 * Given an element, or an element ID, set its style's display property
 * to 'none'
 */
function hide(element) {
    if (typeof(element) != "object")	{
	element = document.getElementById(element);
    }
    
    if (typeof(element) == "object") {
	element.style.display = 'none';
    }
}

function show_content(optionsId) {
	var ids = new Array('home','data','analysis');
	show(optionsId);
	document.getElementById(optionsId + '_link').className = 'active';

	for (var i = 0; i < ids.length; i++)
	{
	    if (ids[i] == optionsId) continue;
	    hide(ids[i]);
	    document.getElementById(ids[i] + '_link').className = '';
	}
}


function showgraph(artist) {
	var ids = new Array("289","72","89","292","498","67","288","701","227","300","333","344","378","679","295","511","461","486","190","163");
	document.getElementById(artist).style.display='block';

	for (var i = 0; i < ids.length; i++)
	{
		if (ids[i] == artist) continue;
		document.getElementById( ids[i] ).style.display='none';
	}
}

</script>
<body>
	<div id="header"><h1>THE LAST.FM NETWORK</h1>
					<h2>Social behaviour of users and artist popularity</h2></div>

	<div id="menu">
		<a id="home_link" href="#" class="active" onclick="show_content('home'); return false;">Home</a> &middot;
		<a id="data_link" href="#" onclick="show_content('data'); update_data_charts(); return false;">Data</a> &middot;
		<a id="analysis_link" href="#" onclick="show_content('analysis'); return false;">Analysis</a> 
	</div>

	<div id="main">

		<div id="home">
			<h1>Home</h1>
			<h2>The challenge</h2>
			
			<p><b><a href="http://www.last.fm/" target="_blank">LAST.FM</a></b> is a music website providing personalized recommendations and offering various social networking and collaborative features for its users. The recommendation system attempts to identify the music needs of its users and makes suggestions for their future listening based on the users' listening history and their social connections.</p>

<p>In our project we exploit the information collected on users but instead of focusing on the users' needs we provide an artist-centered tool. For an artist the most essential element, besides his music, that defines and makes him successful is his audience. Our aim is to explore the relationship between the success of a musician and the distinct characteristics of his fans. We believe that the social connections and social activity of an artist's audience carries useful information on his current and future success. Also, an automatized analysis of the sentiments embodied in the tags and labels given by the users might reveal interesting aspects of the attitude of the audience towards an artist.</p>

			<h2>The solution</h2>
				
			<p>Our dataset contains information on a subset of users in 2011; what artists they listen to, how they are connected to each other and tag information.</p> 

<p>In order to predict success of an artist we define three main independent variables describing the social characteristics and behavior of the artist's audience. In particular, we measure the users' <b>centrality</b> in the social network and their <b>level of activity</b> and then we create artist level variables summarizing these characteristics of the artists' audience. We also quantify the attitude of users towards the artist by performing <b>sentiment analysis</b> on the tags assigned to the artist. Finally we perform <b>linear regression analysis</b>. We regress the overall number of listens to the artist, our dependent variable and our measure of success, on these variables to examine whether and to what extent these characteristics can define the success of a certain artist.</p>
						
		</div>	

                <?php include 'data_and_analysis_ours.php' ?>
	
	</div>

	<div id="footer">Project team: Anneke Speijers, Nikitas Nikitas, Zsuzsa Holler</div>

</body>
</html>
<?php ?>
