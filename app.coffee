#!/usr/bin/env coffee

express =   require 'express'
yargs =     require 'yargs'

documents = require './documents.json'
tags =      require './tags.json'





head = "
<!DOCTYPE HTML>
<html>
<head>
	<meta charset=\"utf-8\"/>
	<title>didb</title>
	<meta name=\"description\" content=\"todo\"/>
	<meta name=\"keywords\" content=\"todo\"/>
	<meta name=\"viewport\" content=\"width=device-width,initial-scale=1\"/>
	<link rel=\"stylesheet\" href=\"./styles.css\"/>
</head>
<body>
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
<li class=\"tag\" style=\"background-color: #{tag.color}\">
	<a href=\"#{tag.link}\">#{tag.title}</a>
</li>"
	.join ''

listOfAvailableTags = (tags, selectedTags) ->
	listOfTags (tags
		.filter (tag) -> not (tag.title in selectedTags)
		.map (tag) -> Object.assign {}, tag, link: linkWithTag selectedTags, tag.id
	), selectedTags

listOfSelectedTags = (tags, selectedTags) ->
	'<p>No tags selected.</p>' if selectedTags.length is 0
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
					matches: selectedTags.filter((tag) -> tag in doc.tags).length
			.filter (doc) -> doc.matches > 0
			.sort (a, b) -> b.matches - a.matches

	tagsOfDocument = (doc) ->
		tags
		.filter (tag) -> tag.id in doc.tags
		.map (tag) -> Object.assign {}, tag, link: linkWithTag selectedTags, tag.id

	documents
	.map (doc) -> "
<li class=\"document\">
	<h2>#{doc.title}</h2>
	<span class=\"document-author\">by #{doc.author}</span>
	<img class=\"document-picture\" src=\"documents/#{doc.picture}\"/>
	<p class=\"document-description\">#{doc.description}</p>
	<ul class=\"document-tags\">
		#{listOfTags tagsOfDocument doc}
	</ul>
	<a class=\"button document-download\" href=\"./documents/#{doc.file}\">Download</a>
</li>"
	.join ''



tpl = (req, tags, documents) ->
	selectedTags = (req.query.tags ? '').split ','
		.filter (tag) -> tag.length > 0

	head + "
<div id=\"body\">
	<nav id=\"tags\">
		<h2>Selected Tags</h2>
		<ul id=\"tags-selected\">
			#{listOfSelectedTags tags, selectedTags}
		</ul>
		<h2>All Tags</h2>
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






app = express()

app.get '/', (req, res) -> res.end tpl req, tags, documents

app.use express.static __dirname
app.listen yargs.argv.port || 10000
