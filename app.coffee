#!/usr/bin/env coffee

express =     require 'express'
forceSSL = require('express-force-ssl')
yargs =       require 'yargs'
cfg = require 'config'
https = require 'https'
http = require 'http'

fs = require 'fs'
ssl =
	key:  fs.readFileSync cfg.key
	cert: fs.readFileSync cfg.cert
	ca:   fs.readFileSync cfg.ca



app = express()
app.set 'forceSSLOptions', httpsPort: cfg.ports.https
app.use forceSSL
app.get '/', require './routes/frontend'
app.use express.static __dirname

secure = https.createServer(ssl, app)
secure.listen cfg.ports.https
insecure = http.createServer(app)
insecure.listen cfg.ports.http
