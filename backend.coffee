#!/usr/bin/env coffee

fs =        require 'fs'





head = "
<!DOCTYPE HTML>
<html>
<head>
	<meta charset=\"utf-8\"/>
	<title>didb</title>
	<meta name=\"description\" content=\"Sammlung von Lehrmaterialien nach Schlagwörter sortiert.\"/>
	<meta name=\"keywords\" content=\"todo\"/>
	<meta name=\"viewport\" content=\"width=device-width,initial-scale=1\"/>
	<link rel=\"stylesheet\" href=\"./styles.css\"/>
</head>
<body>
	<img id=\"logo\" src=\"./logo.png\"/>
	<h1>Deutschkurs in der Box</h1>"

footer = "
</body>
</html>"




module.exports = (req, res) ->
	res.send head + "
<div id=\"add-document\">
	<form action=\"/add-document\" method=\"post\">
		<input type=\"text\" name=\"title\" value=\"\" placeholder=\"Titel\"/>
		<input type=\"text\" name=\"author\" value=\"\" placeholder=\"Autor_in\"/>
		<textarea type=\"text\" name=\"description\" value=\"\" placeholder=\"Beschreibung\"></textarea>
		<input type=\"text\" name=\"tags\" value=\"\" placeholder=\"Tags, getrennt mit Komma\"/>
		<input type=\"text\" name=\"file\" value=\"\" placeholder=\"Dateiname des Dokuments\"/>
		<input type=\"text\" name=\"picture\" value=\"\" placeholder=\"Dateiname des Bildes\"/>
		<input type=\"submit\" value=\"Allet klar.\">
	</form>
</div>" + footer
