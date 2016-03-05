#!/usr/bin/env coffee

module.exports = (req, res) -> res.send '
<!DOCTYPE HTML>
<html>
<head>
	<meta charset="utf-8"/>
	<title>didb</title>
	<meta name="description" content="Sammlung von Lehrmaterialien nach Schlagwörter sortiert."/>
	<meta name="keywords" content="todo"/>
	<meta name="viewport" content="width=device-width,initial-scale=1"/>
	<link rel="stylesheet" href="./styles.css"/>
</head>
<body>
	<img id="logo" src="./logo.png"/>
	<h1>Deutschkurs in der Box</h1>
	<h2>Tags hinzufügen</h2>
	<form action="./tags" method="post">
		<input type="text" name="title" value="" placeholder="Titel"/>
		<input type="text" name="color" value="" placeholder="Hex-Farbe, zb ab34e7"/>
		<input type="submit" value="Allet klar.">
	</form>
</div>
</body>
</html>'
