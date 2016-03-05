#!/usr/bin/env coffee

fs =        require 'fs'
escape =    require 'slugg'





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
		.map (tag) -> escape tag.trim()
		.filter (tag) -> tag.length > 0
	addDocument document, (err) ->
		res.status(500).send err.message if err
		res.redirect './documents'
