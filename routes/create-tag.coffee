#!/usr/bin/env coffee

escape = require 'slugg'

common = require './common'





addTag = (tag, cb) ->
	common.readTags (err, tags) ->
		return cb err if err
		common.writeTags tags.concat(tag), cb

module.exports = (req, res) ->
	tag = req.body
	id = escape tag.title
	if id.length is 0
		return common.sendError res, new Error 'Tag can\'t be empty.'
	Object.assign tag, {id}
	addTag tag, (err) ->
		return common.sendError res, err if err
		res.redirect './tags'
