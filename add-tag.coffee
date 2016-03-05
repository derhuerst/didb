#!/usr/bin/env coffee

fs =        require 'fs'
escape =    require 'slugg'





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




addTag = (tag, cb) ->
	fs.readFile './tags.json', (err, data) ->
		return cb err if err
		tags = JSON.parse data
		tags.push tag
		fs.writeFile './tags.json', JSON.stringify(tags), (err) ->
			cb err ? null

module.exports = (req, res) ->
	tag = req.body
	Object.assign tag, id: escape tag.title
	addTag tag, (err) ->
		res.status(500).send err.message if err
		res.redirect '/backend'
