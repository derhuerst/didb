#!/usr/bin/env coffee

basicAuth =   require 'basic-auth'
express =     require 'express'
busboy =      require 'express-busboy'
cfg = require 'config'
https = require 'https'

fs = require 'fs'
ssl =
	key:  fs.readFileSync cfg.key
	cert: fs.readFileSync cfg.cert
	ca:   fs.readFileSync cfg.ca



auth = (req, res, cb) ->
	data = basicAuth req
	return cb null if data and data.pass is cfg.password
	res.status(401).header('WWW-Authenticate', 'Basic realm="backend"').send 'Passwort falsch.'

app = express server
busboy.extend app
app.use auth

app.get '/documents',        require './routes/documents'
app.post '/documents',       require './routes/create-document'
app.get '/documents/:id',    require './routes/document'
app.patch '/documents/:id',  require './routes/update-document'
app.delete '/documents/:id', require './routes/delete-document'
app.get '/tags',             require './routes/tags'
app.post '/tags',            require './routes/create-tag'
app.delete '/tags/:id',      require './routes/delete-tag'

app.use express.static __dirname

server = https.createServer ssl, app
server.listen cfg.ports.backend
