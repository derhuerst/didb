#!/usr/bin/env coffee

common = require './common'



module.exports = (req, res) -> common.readDocsAndTags (err, docs, tags) ->
	return common.sendError res, err if err
	doc = docs.find (doc) -> doc.id is req.params.id
	if doc is undefined then return res.status(400).end 'no such document.'

	data = req.body
	doc.tags = common.parseTags tags, data.tags if data.hasOwnProperty 'tags'
	for prop in ['title', 'author-name', 'author-link', 'description', 'file', 'picture']
		doc[prop] = data[prop] if data.hasOwnProperty prop

	common.writeDocs docs, (err) ->
		return common.sendError res, err if err
		res.type('text').end 'ok'
