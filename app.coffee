#!/usr/bin/env coffee

express =     require 'express'
http = require 'http'

port = process.env.PORT || 3000
hostname = process.env.HOSTNAME || ''

app = express()
app.get '/', require './routes/frontend'
app.use express.static __dirname

http.createServer(app)
.listen port, (err) ->
	if err
		console.error err
		process.exit 1
	console.info "Listening on #{hostname}:#{port}."
