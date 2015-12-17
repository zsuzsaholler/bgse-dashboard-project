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
    if (artist == "0") {
    0.style.display='inline-block';
    } 
    else{
    0.style.display='none';
    }
  }

</script>
<body>
	<div id="header"><h1>GROUP 2 HACKED THIS WEBSITE YEAHHHHH</h1></div>

	<div id="menu">
		<a id="home_link" href="#" class="active" onclick="show_content('home'); return false;">Home</a> &middot;
		<a id="data_link" href="#" onclick="show_content('data'); update_data_charts(); return false;">Data</a> &middot;
		<a id="analysis_link" href="#" onclick="show_content('analysis'); return false;">Analysis</a> 
	</div>

	<div id="main">

		<div id="home">
			<h2>Home</h2>
			<h3>The challenge</h3>
			
			<p>Text about challenge goes here.</p>
			
			<ul style="list-style-type:circle">
  				<li>  </li>
			</ul>
			
			<h3>The solution</h3>
						
			<p>Test about the solution goes here.</p>
				<ul style="list-style-type:circle">
					<li>  <b><a href="http://www.wikipedia.org/wiki/Apriori_algorithm" target="_blank">Apriori algorithm.</a></b></li>
				</ul>
						
		</div>	

                <?php include 'data_and_analysis_ours.php' ?>
	
	</div>

	<div id="footer">Project team: Anneke Speijers, Nikitas Nikitas, Zsuzsa Holler</div>

</body>
</html>
<?php ?>
