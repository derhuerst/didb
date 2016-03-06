#!/usr/bin/env coffee

fs =     require 'fs'
escape = require 'slugg'

common = require './common'





module.exports = (req, res) -> common.readTags (err, tags) ->
	return common.sendError res, err if err
	tags = tags.filter (tag) -> tag.id isnt req.params.id
	common.writeTags tags, (err) ->
		return common.sendError res, err if err
		res.end 'ok'
