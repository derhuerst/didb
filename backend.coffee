#!/usr/bin/env coffee

basicAuth =   require 'basic-auth'
express =     require 'express'
busboy =      require 'express-busboy'
cfg = require 'config'
http = require 'http'

password = process.env.PASSWORD
port = process.env.PORT || 3000
hostname = process.env.HOSTNAME || ''
if not password
	console.error('Missing password.')
	process.exit(1)

auth = (req, res, cb) ->
	data = basicAuth req
	return cb null if data and data.pass is password
	res.status(401).header('WWW-Authenticate', 'Basic realm="backend"').send 'Passwort falsch.'

app = express()
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

http.createServer(app)
.listen port, (err) ->
	if err
		console.error err
		process.exit 1
	console.info "Listening on #{hostname}:#{port}."
