#!/usr/bin/env coffee

escape = require 'slugg'

common = require './common'





addTag = (tag, cb) ->
	common.readTags (err, tags) ->
		return cb err if err
		common.writeTags tags.concat(tag), cb

module.exports = (req, res) ->
	tag = req.body
	Object.assign tag, id: escape tag.title
	addTag tag, (err) ->
		return common.sendError res, err if err
		res.redirect './tags'
