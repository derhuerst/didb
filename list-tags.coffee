#!/usr/bin/env coffee

common = require './common'



js = "
<script>
'use strict';
Array.from(document.querySelectorAll('#delete-tags .tag-delete'))
.forEach((button) => button.addEventListener('click', function () {
	if (!button.waitingForConfirm) {
		button.innerHTML = '?';
		button.waitingForConfirm = true;
	} else deleteTag(button.getAttribute('data-id'), function (err) {
		if (err) button.innerHTML = '☹';
		else button.innerHTML = '✓';
	})
}));
</script>"



listOfTags = (tags) ->
	return '<p>Keine Schlagwörter.</p>' if tags.length is 0
	tags
	.map (tag) -> Object.assign {}, tag, link: "/?tags=#{tag.id}"
	.map (tag) -> "
<li>
	<a class=\"tag\" style=\"background-color: #{tag.color}\" href=\"#{tag.link}\">#{tag.title}</a>
	<button class=\"tag-delete\" data-id=\"#{tag.id}\" type=\"button\">✘</button>
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
	<ul>
		#{listOfTags tags}
	</ul>
</div>" + js + common.footer
