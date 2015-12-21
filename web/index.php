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
			
			<p><b><a href="http://www.last.fm/" target="_blank">LAST.FM</a></b> is a music website providing a recommendation system based on the listening history and the social connections of users. Our dataset contains information on a subset of users in 2011; what artists they listen to, how they are connected to each other and tag information. The common setting in databases which include artists, users and frequency of listens is that they are user-centered. Music streaming software such as Spotify and Last.fm attempt to identify the music needs of their users and make suggestions for their future listening. In our project we would like to extend this notion in a different direction: Provide an artist-centered tool. For an artist the most essential element, besides his music, that defines and makes him successful is his audience. The challenge of our project is to predict the future success of artists based on the distinct characteristics of their fans. Given our particular dataset, we try to analyze various aspects of the social behavior of users and from that, infer whether there is a relationship between artist success and fan quality. Our main goal is to be able to predict the success of an artist by looking at the social behaviour (activity, popularity) of his fans.</p>

			<h2>The solution</h2>
				
			<p>In order to predict success of an artist we define three main independent variables based on the social characteristics of the artist's audience. We then regress these variables on the number of listen counts, our dependent variable and our measure of success, to examine whether and to what extend these characteristics can define the success of a certain artist.</p>
			
			<p>The process involved cleaning the data (remove non-recognisable characters, combine entries for duplicate artists) to be able to easily access and manage them. The creation of the independent variables, before running the regression, was not straight forward and required clever data manipulation, described in detail on the Analysis page. MySQL queries played an important role enabling us to combine, aggregate and gain insights on the LAST.FM data.</p>
						
		</div>	

                <?php include 'data_and_analysis_ours.php' ?>
	
	</div>

	<div id="footer">Project team: Anneke Speijers, Nikitas Nikitas, Zsuzsa Holler</div>

</body>
</html>
<?php ?>
