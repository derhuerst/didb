#!/usr/bin/env coffee

common = require './common'



listOfTags = (tags) ->
	return '<p>Keine Schlagwörter.</p>' if tags.length is 0
	tags
	.map (tag) -> Object.assign {}, tag, link: "/?tags=#{tag.id}"
	.map (tag) -> "
<li class=\"tag\">
	<a class=\"tag\" style=\"background-color: #{tag.color}\" href=\"#{tag.link}\">#{tag.title}</a>
	<form action=\"/tags/#{tag.id}\" method=\"delete\">
		<input type=\"submit\" value=\"✘\"/>
	</form>
</li>"
	.join ''



module.exports = (req, res) -> common.readTags (err, tags) ->
	return common.sendError res, err if err

	res.end common.header + '
<div class="right-column">
	<h2>Schlagwort hinzufügen</h2>
	<form action="./tags" method="post">
		<input type="text" name="title" value="" placeholder="Titel"/>
		<input type="text" name="color" value="" placeholder="Hex-Farbe, zb ab34e7"/>
		<input type="submit" value="Allet klar.">
	</form>
</div>' + "
<div id=\"delete-tags\" class=\"left-column\">
	<h2>Schlagwörter</h2>
	<ul id=\"tags\">
		#{listOfTags tags}
	</ul>
</div>" + common.footer
