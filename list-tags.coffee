#!/usr/bin/env coffee

common = require './common'

module.exports = (req, res) -> res.send common.header + '
<div class="right-column">
	<h2>Schlagwort hinzufügen</h2>
	<form action="./tags" method="post">
		<input type="text" name="title" value="" placeholder="Titel"/>
		<input type="text" name="color" value="" placeholder="Hex-Farbe, zb ab34e7"/>
		<input type="submit" value="Allet klar.">
	</form>
</div>
<div class="left-column">
	<h2>Schlagwörter</h2>
	todo
</div>' + common.footer
