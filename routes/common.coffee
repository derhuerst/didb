fs =   require 'fs'
path = require 'path'



module.exports =

	readJSON: (file, cb) ->
		fs.readFile path.join(__dirname, file), (err, data) ->
			return cb err if err
			try
				data = JSON.parse data
			catch err
				return cb err
			cb null, data

	readDocs: (cb) -> @readJSON '../data/documents.json', cb
	readTags: (cb) -> @readJSON '../data/tags.json', cb
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
		fs.writeFile path.join(__dirname, file), data, cb

	writeDocs: (d, cb) -> @writeJSON '../data/documents.json', d, cb
	writeTags: (d, cb) -> @writeJSON '../data/tags.json', d, cb



	sendError: (res, err) ->
		console.error err
		res.status(500).send err.message



	header: '
<!DOCTYPE HTML>
<html>
<head>
	<meta charset="utf-8"/>
	<title>didb</title>
	<meta name="description" content="Arbeitsblattsammlung für den ehrenamtlichen Deutschunterricht, versehen mit Schlagwörtern."/>
	<meta name="keywords" content="material, unterricht, deutsch, german, ehrenamtlich, geflüchtete, flüchtlinge, refugees, tags, berlin"/>
	<meta name="author" content="Lucia Fc"/>
	<meta name="viewport" content="width=device-width,initial-scale=1"/>
	<link rel="stylesheet" href="/assets/styles.css"/>
	<script src="/assets/main.js"></script>
</head>
<body>
<img id="logo" src="/assets/logo.png"/>
<h1>Arbeits- und Übungsblätter für den ehrenamtlichen Deutschunterricht</h1>
<p>Im Projekt <em>Deutschkurs in der Box</em> sind wir auf mehrere wertvolle Arbeitsblätter gestoßen, die wir hier gesammelt und mit Schlagwörtern versehen haben für eine bessere Übersicht des vorhandenen verfügbaren Angebots.</p>
<div id="body">'

	footer: '
</div>
</body>
</html>'
