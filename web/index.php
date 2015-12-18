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
	<div id="header"><h1>THE LAST.FM NETWORK AND ARTIST POPULARITY</h1></div>

	<div id="menu">
		<a id="home_link" href="#" class="active" onclick="show_content('home'); return false;">Home</a> &middot;
		<a id="data_link" href="#" onclick="show_content('data'); update_data_charts(); return false;">Data</a> &middot;
		<a id="analysis_link" href="#" onclick="show_content('analysis'); return false;">Analysis</a> 
	</div>

	<div id="main">

		<div id="home">
			<h2>Home</h2>
			<h3>The challenge</h3>
			
			<p>The challenge of our project is to predict the future success of artists based on the distinct characteristics of their fans. Particularly, given the dataset of the <b><a href="http://www.last.fm/" target="_blank">LAST.FM</a></b> we are trying to analyze various aspects of the social behavior of users and based on that to infer whether there is a relation between success and fan quality.</p>

			<h3>The solution</h3>
				
			<p>Initially, we had to clean the data (get rid of duplicate names, clean the tags etc) so we could easily access and manage them. Next, we tried to identify the independent and dependent variables as well as to find ways to compute their coefficients from clever data manipulation. SQL played an important role with </p>

						
		</div>	

                <?php include 'data_and_analysis_ours.php' ?>
	
	</div>

	<div id="footer">Project team: Anneke Speijers, Nikitas Nikitas, Zsuzsa Holler</div>

</body>
</html>
<?php ?>
