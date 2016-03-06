fs =   require 'fs'
path = require 'path'



module.exports =

	readJSON: (file, cb) ->
		fs.readFile path.join('.', file), (err, data) ->
			return cb err if err
			try
				data = JSON.parse data
			catch err
				return cb err
			cb null, data

	readDocs: (cb) -> @readJSON './documents.json', cb
	readTags: (cb) -> @readJSON './tags.json', cb
	readDocsAndTags: (cb) ->
		docs = null; tags = null
		@readDocs (err, data) ->
			return cb err if err
			docs = data
			cb null, docs, tags if tags
		@readTags (err, data) ->
			return cb err if err
			tags = data
			cb null, docs, tags if docs
		null



	writeJSON: (file, data, cb) ->
		try
			data = JSON.stringify data
		catch err
			return cb err
		fs.writeFile path.join('.', file), data, cb

	writeDocs: (d, cb) -> @writeJSON './documents.json', d, cb
	writeTags: (d, cb) -> @writeJSON './tags.json', d, cb



	sendError: (res, err) ->
		console.error err
		res.status(500).send err.message



	header: '
<!DOCTYPE HTML>
<html>
<head>
	<meta charset="utf-8"/>
	<title>didb</title>
	<meta name="description" content="Sammlung von Lehrmaterialien nach Schlagwörter sortiert."/>
	<meta name="keywords" content="todo"/>
	<meta name="viewport" content="width=device-width,initial-scale=1"/>
	<link rel="stylesheet" href="/styles.css"/>
</head>
<body>
<img id="logo" src="/logo.png"/>
<h1>Deutschkurs in der Box</h1>
<div id="body">'

	footer: '
</div>
</body>
</html>'
