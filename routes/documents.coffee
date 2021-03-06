#!/usr/bin/env coffee

common = require './common'



js = "
<script>
'use strict';
Array.from(document.querySelectorAll('#delete-documents .document-delete'))
.forEach((button) => button.addEventListener('click', function () {
	if (!button.waitingForConfirm) {
		button.innerHTML = '?';
		button.waitingForConfirm = true;
	} else deleteDoc(button.getAttribute('data-id'), function (err) {
		if (err) button.innerHTML = '☹';
		else button.innerHTML = '✓';
	})
}));
</script>"



listOfDocs = (docs) ->
	return '<p>Keine Dokumente.</p>' if docs.length is 0
	docs
	.map (doc) -> "
<li class=\"document\">
	<span>#{doc.title}</span>
	<a class=\"button\" href=\"/documents/#{doc.id}\">✎</a>
	<button class=\"document-delete\" data-id=\"#{doc.id}\" type=\"button\">✘</button>
</li>"
	.join ''



module.exports = (req, res) -> common.readDocs (err, docs) ->
	return common.sendError res, err if err

	res.send common.header + '
<div id=\"body\">
<div class="right-column">
	<h2>Dokument hinzufügen</h2>
	<form action="./documents" method="post">
		<input type="text" name="title" value="" placeholder="Titel"/>
		<input type="text" name="author-name" value="" placeholder="Name d. Autor_in"/>
		<input type="text" name="author-link" value="" placeholder="Link z. Autor_in"/>
		<textarea type="text" name="description" value="" placeholder="Beschreibung"></textarea>
		<input type="text" name="tags" value="" placeholder="Tags, getrennt mit Komma"/>
		<input type="text" name="file" value="" placeholder="Dateiname des Dokuments"/>
		<input type="text" name="picture" value="" placeholder="Dateiname des Bildes"/>
		<input type="submit" value="Allet klar.">
	</form>
</div>' + "
<div id=\"delete-documents\" class=\"left-column\">
	<h2>Dokumente</h2>
	<ul>
		#{listOfDocs docs}
	</ul>
</div>
</div>" + js + common.footer
