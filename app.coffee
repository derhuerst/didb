#!/usr/bin/env coffee

basicAuth =   require 'basic-auth'
express =     require 'express'
bodyParser =  require 'body-parser'
fs =          require 'fs'
yargs =       require 'yargs'

config =      require './config'





auth = (req, res, cb) ->
	data = basicAuth req
	return cb null if data and data.pass is config.password
	res.status(401).header('WWW-Authenticate', 'Basic realm="backend"').send 'Passwort falsch.'

app = express()
app.use bodyParser.urlencoded extended: true

app.get '/',                 require './frontend'
app.get '/documents',  auth, require './list-documents'
app.post '/documents', auth, require './add-document'
app.get '/tags',       auth, require './list-tags'
app.post '/tags',      auth, require './add-tag'

app.use express.static __dirname
app.listen yargs.argv.port || 10000
