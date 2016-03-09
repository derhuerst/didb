#!/usr/bin/env coffee

basicAuth =   require 'basic-auth'
https =       require 'https'
fs =          require 'fs'
express =     require 'express'
bodyParser =  require 'body-parser'
yargs =       require 'yargs'

config =      require './config'





auth = (req, res, cb) ->
	data = basicAuth req
	return cb null if data and data.pass is config.password
	res.status(401).header('WWW-Authenticate', 'Basic realm="backend"').send 'Passwort falsch.'

app = express server
app.use bodyParser.urlencoded extended: true
app.use auth
server = https.createServer {
	cert: fs.readFileSync './self-signed.crt'
	key:  fs.readFileSync './.self-signed.key'
}, app

app.get '/documents',        require './list-documents'
app.post '/documents',       require './add-document'
app.delete '/documents/:id', require './delete-document'
app.get '/tags',             require './list-tags'
app.post '/tags',            require './add-tag'
app.delete '/tags/:id',      require './delete-tag'

app.use express.static __dirname
server.listen yargs.argv.port || 8000
