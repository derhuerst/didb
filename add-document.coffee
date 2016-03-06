#!/usr/bin/env coffee

fs =     require 'fs'
escape = require 'slugg'

common = require './common'





addDocument = (doc, cb) ->
	common.readDocs (err, docs) ->
		return cb err if err
		common.writeDocs docs.concat(doc), cb

module.exports = (req, res) ->
	document = req.body
	document.tags = document.tags
		.split ','
		.map (tag) -> escape tag.trim()
		.filter (tag) -> tag.length > 0
	addDocument document, (err) ->
		return common.sendError res, err if err
		res.redirect './documents'
