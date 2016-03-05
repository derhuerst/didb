#!/usr/bin/env coffee

fs =        require 'fs'





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




addDocument = (doc, cb) ->
	fs.readFile './documents.json', (err, data) ->
		return cb err if err
		documents = JSON.parse data
		documents.push doc
		fs.writeFile './documents.json', JSON.stringify(documents), (err) ->
			cb err ? null

module.exports = (req, res) ->
	document = req.body
	document.tags = document.tags
		.split ','
		.map (tag) -> tag.trim()
		.filter (tag) -> tag.length > 0
	addDocument document, (err) ->
		res.status(500).send err.message if err
		res.redirect '/backend'
