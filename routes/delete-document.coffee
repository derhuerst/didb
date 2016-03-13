#!/usr/bin/env coffee

common = require './common'





module.exports = (req, res) -> common.readDocs (err, docs) ->
	return common.sendError res, err if err
	docs = docs.filter (doc) -> doc.id isnt req.params.id
	common.writeDocs docs, (err) ->
		return common.sendError res, err if err
		res.type('text').end 'ok'
