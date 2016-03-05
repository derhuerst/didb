#!/usr/bin/env coffee

fs =        require 'fs'

readData = (cb) ->
	fs.readFile './documents.json', (err, data) ->
		return cb err if err
		documents = JSON.parse data
		fs.readFile './tags.json', (err, data) ->
			return cb err if err
			tags = JSON.parse data
			cb null, tags, documents





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



linkWithTag = (selectedTags, newTag) ->
	selectedTags = selectedTags.concat newTag if not (newTag in selectedTags)
	'./?tags=' + selectedTags.join ','

linkWithoutTag = (selectedTags, oldTag) ->
	selectedTags = selectedTags.filter (tag) -> tag isnt oldTag
	return './' if selectedTags.length is 0
	'./?tags=' + selectedTags.join ','



listOfTags = (tags, selectedTags) ->
	tags
	.map (tag) -> "
<li>
	<a class=\"tag\" style=\"background-color: #{tag.color}\" href=\"#{tag.link}\">#{tag.title}</a>
</li>"
	.join ''

listOfAvailableTags = (tags, selectedTags) ->
	listOfTags (tags
		.filter (tag) -> not (tag.id in selectedTags)
		.map (tag) -> Object.assign {}, tag, link: linkWithTag selectedTags, tag.id
	), selectedTags

listOfSelectedTags = (tags, selectedTags) ->
	return '<p>Du hast keine Schlagwörter ausgewählt.</p>' if selectedTags.length is 0
	listOfTags (tags
		.filter (tag) -> tag.id in selectedTags
		.map (tag) -> Object.assign {}, tag,
			title: tag.title + ' ✘'
			link: linkWithoutTag selectedTags, tag.id
	), selectedTags



listOfDocuments = (tags, documents, selectedTags) ->
	if selectedTags.length > 0
		# compute nr of matched tags
		documents = documents
			.map (doc) ->
				Object.assign {}, doc,
					relevance: selectedTags.filter((tag) -> tag in doc.tags).length / doc.tags.length
			.filter (doc) -> doc.relevance > 0
			.sort (a, b) -> b.relevance - a.relevance

	tagsOfDocument = (doc) ->
		tags
		.filter (tag) -> tag.id in doc.tags
		.map (tag) ->
			Object.assign {}, tag, link: linkWithTag selectedTags, tag.id
		.map (tag) ->
			tag.title += ' ✓' if tag.id in selectedTags
			return tag

	documents
	.map (doc) -> "
<li class=\"document\">
	<h2>#{doc.title}</h2>
	<span class=\"document-author\">Autor: #{doc.author}</span>
	<img class=\"document-picture\" src=\"documents/#{doc.picture}\"/>
	<p class=\"document-description\">#{doc.description}</p>
	<ul class=\"document-tags\">
		#{listOfTags tagsOfDocument doc}
	</ul>
	<a class=\"button document-download\" href=\"./documents/#{doc.file}\">Download</a>
</li>"
	.join ''



module.exports = (req, res) ->
	readData (err, tags, documents) ->
		return res.status(500).send err.message if err

		selectedTags = (req.query.tags ? '').split ','
			.filter (tag) -> tag.length > 0

		res.send head + "
	<div id=\"body\">
		<nav id=\"tags\">
			<h2>Ausgewählte Schlagwörter</h2>
			<ul id=\"tags-selected\">
				#{listOfSelectedTags tags, selectedTags}
			</ul>
			<h2>Alle Schlagwörter</h2>
			<ul id=\"tags-all\">
				#{listOfAvailableTags tags, selectedTags}
			</ul>
		</nav>
		<main id=\"documents\">
			<ul id=\"documents-list\">
				#{listOfDocuments tags, documents, selectedTags}
			</ul>
		</main>
	</div>" + footer
