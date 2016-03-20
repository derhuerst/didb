#!/usr/bin/env coffee

escape = require 'slugg'

common = require './common'





addDocument = (doc, cb) ->
	common.readDocs (err, docs) ->
		return cb err if err
		common.writeDocs docs.concat(doc), cb

module.exports = (req, res) ->
	document = req.body
	common.readTags (err, tags) ->
		document.tags = common.parseTags tags, document.tags
		document.id = escape document.title
		addDocument document, (err) ->
			return common.sendError res, err if err
			res.redirect './documents'
