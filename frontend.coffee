#!/usr/bin/env coffee

common =    require './common'





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
	return '<p>Keine Schlagwörter.</p>' if tags.length is 0
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



listOfDocs = (tags, docs, selectedTags) ->
	return '<p>Keine Dokumente.</p>' if docs.length is 0
	if selectedTags.length > 0
		# compute nr of matched tags
		docs = docs
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

	docs
	.map (doc) -> "
<li class=\"document\">
	<h2>#{doc.title}</h2>
	<span class=\"document-author\">Autor: #{doc.author}</span>
	<img class=\"document-picture\" src=\"documents/#{doc.picture}\"/>
	<p class=\"document-description\">#{doc.description}</p>
	<ul class=\"document-tags\">
		#{listOfTags tagsOfDocument doc}
	</ul>
	<a class=\"button document-download\" href=\"./data/#{doc.file}\">Download</a>
</li>"
	.join ''



module.exports = (req, res) -> common.readDocsAndTags (err, docs, tags) ->
	return common.sendError res, err if err

	selectedTags = (req.query.tags ? '').split ','
		.filter (tag) -> tag.length > 0

	res.end common.header + "
<nav id=\"tags\" class=\"right-column\">
	<h2>Ausgewählte Schlagwörter</h2>
	<ul id=\"tags-selected\">
		#{listOfSelectedTags tags, selectedTags}
	</ul>
	<h2>Alle Schlagwörter</h2>
	<ul id=\"tags-all\">
		#{listOfAvailableTags tags, selectedTags}
	</ul>
</nav>
<main id=\"documents\" class=\"left-column\">
	<ul id=\"documents-list\">
		#{listOfDocs tags, docs, selectedTags}
	</ul>
</main>" + common.footer
