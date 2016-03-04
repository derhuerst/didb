tagsFromQuery = (query) -> (query.tags ? '').split(',').filter (tag) -> tag.length > 0

linkWithTag = (currentTags) -> (additionalTag) ->
	return currentTags if additionalTag in currentTags
	'./?tags=' + currentTags.concat(additionalTag).join ','

linkWithoutTag = (currentTags) -> (obsoleteTag) ->
	'./?tags=' + currentTags
		.filter (tag) -> tag isnt obsoleteTag
		.join ','



tagsList = (req, tags, documents) ->
	tagLink = linkWithTag tagsFromQuery req.query
	tags
	.map (tag) -> "
<li><a href=\"#{tagLink tag}\">#{tag}</a></li>"
	.join ''



selectedTagsList = (req, tags, documents) ->
	tagLink = linkWithoutTag tagsFromQuery req.query
	tagsFromQuery req.query
	.map (tag) -> "
<li>#{tag} <a href=\"#{tagLink tag}\">remove</a></li>"
	.join ''



documentsList = (req, tags, documents) ->
	currentTags = tagsFromQuery req.query

	if currentTags.length > 0
		documents = documents.filter (doc) -> currentTags.some (tag) -> tag in doc.tags

	documents
	.map (document) -> "
<h2>#{document.title}</h2>
<span class=\"author\">#{document.author}</span>
<p class=\"description\">#{document.description}</p>
<img class=\"picture\" src=\"#{document.picture}\"/>
<a class=\"download\" href=\"/#{document.file}\">Download</a>"
	.join ''



module.exports = (req, tags, documents) ->
	"
<!DOCTYPE HTML>

<html>
<head>
	<meta charset=\"utf-8\">
	<title>didb</title>
	<meta name=\"description\" content=\"todo\">
	<meta name=\"keywords\" content=\"todo\">
	<meta name=\"viewport\" content=\"width=device-width,initial-scale=1\">
	<style>
	</style>
</head>
<body>
	<h1>Deutschkurs in a Box</h1>
	<img src=\"./logo.png\" id=\"logo\"/>
	<h2>Selected Tags</h2>
	<ul id=\"selectedTags\">#{selectedTagsList req, tags, documents}</ul>
	<h2>All Tags</h2>
	<ul id=\"tags\">#{tagsList req, tags, documents}</ul>
	<h2>Documents</h2>
	<ul id=\"documents\">#{documentsList req, tags, documents}</ul>
</body>
</html>"
