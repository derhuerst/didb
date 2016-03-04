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

linkWithoutTag = (tags, oldTag) ->
	'./?tags=' + tags.filter((tag) -> tag isnt oldTag).join ','



listOfAllTags = (tags, selectedTags) ->
	tags
	.filter (tag) -> not (tag.title in selectedTags)
	.map (tag) -> "
<li class=\"tag\">
	<a href=\"#{linkWithTag selectedTags, tag.title}\">#{tag.title}</a>
</li>"
	.join ''



listOfSelectedTags = (tags, selectedTags) ->
	'<p>No tags selected.</p>' if selectedTags.length is 0

	tags
	.filter (tag) -> tag.title in selectedTags
	.map (tag) -> "
<li class=\"tag\">
	<a href=\"#{linkWithoutTag selectedTags, tag.title}\" alt=\"remove the tag #{tag.title}\">#{tag.title} x</a>
</li>"
	.join ''



listOfDocuments = (documents, selectedTags) ->
	if selectedTags.length > 0
		documents = documents.filter (doc) -> selectedTags.some (tag) -> tag in doc.tags

	documents
	.map (document) -> "
<li class=\"document\">
	<h2>#{document.title}</h2>
	<span class=\"author\">by #{document.author}</span>
	<img class=\"picture\" src=\"#{document.picture}\"/>
	<p class=\"description\">#{document.description}</p>
	<a class=\"button download\" href=\"./documents/#{document.file}\">Download</a>
</li>"
	.join ''



module.exports = (req, tags, documents) ->
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
			#{listOfAllTags tags, selectedTags}
		</ul>
	</nav>
	<main id=\"documents\">
		<ul id=\"documents-list\">
			#{listOfDocuments documents, selectedTags}
		</ul>
	</main>
</div>" + footer
