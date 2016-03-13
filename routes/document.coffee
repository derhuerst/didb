#!/usr/bin/env coffee

common = require './common'



js = "
<script>
'use strict';
var form = document.querySelector('#update');
var button = document.querySelector('#update input[type=\"submit\"]');
console.log(button);
form.addEventListener('submit', function (e) {
	e.preventDefault();
	updateDoc(form.getAttribute('data-id'), new FormData(form), function (err) {
		if (err) button.value = '☹';
		else button.value = '✓';
	});
});
</script>"



module.exports = (req, res) -> common.readDocsAndTags (err, docs, tags) ->
	return common.sendError res, err if err
	doc = docs.find (doc) -> doc.id is req.params.id
	if doc is undefined then return res.status(400).end 'no such document.'
	readableTags = common.stringifyTags tags, doc.tags

	res.send common.header + "
<h2>Dokument bearbeiten</h2>
<form id=\"update\" data-id=\"#{doc.id}\" action=\"/documents/#{doc.id}\" method=\"patch\">
	<input type=\"hidden\" name=\"id\" value=\"#{doc.id}\"/>
	<input type=\"text\" name=\"title\" value=\"#{doc.title}\" placeholder=\"Titel\"/>
	<input type=\"text\" name=\"author\" value=\"#{doc.author}\" placeholder=\"Autor_in\"/>
	<textarea type=\"text\" name=\"description\" placeholder=\"Beschreibung\">#{doc.description}</textarea>
	<input type=\"text\" name=\"tags\" value=\"#{readableTags}\" placeholder=\"Tags, getrennt mit Komma\"/>
	<input type=\"text\" name=\"file\" value=\"#{doc.file}\" placeholder=\"Dateiname des Dokuments\"/>
	<input type=\"text\" name=\"picture\" value=\"#{doc.picture}\" placeholder=\"Dateiname des Bildes\"/>
	<input type=\"submit\" value=\"Allet klar.\">
</form>" + js + common.footer
