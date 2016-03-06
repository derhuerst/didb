#!/usr/bin/env coffee

common = require './common'

module.exports = (req, res) -> res.send common.header + '
<div class=\"right-column\">
	<h2>Dokument hinzufügen</h2>
	<form action="./documents" method="post">
		<input type="text" name="title" value="" placeholder="Titel"/>
		<input type="text" name="author" value="" placeholder="Autor_in"/>
		<textarea type="text" name="description" value="" placeholder="Beschreibung"></textarea>
		<input type="text" name="tags" value="" placeholder="Tags, getrennt mit Komma"/>
		<input type="text" name="file" value="" placeholder="Dateiname des Dokuments"/>
		<input type="text" name="picture" value="" placeholder="Dateiname des Bildes"/>
		<input type="submit" value="Allet klar.">
	</form>
</div>
<div class="left-column">
	<h2>Dokumente</h2>
	todo
</div>' + common.footer
