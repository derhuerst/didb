#!/usr/bin/env coffee

fs =        require 'fs'
escape =    require 'slugg'





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
		res.redirect './tags'
