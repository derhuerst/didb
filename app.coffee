#!/usr/bin/env coffee

express =     require 'express'
bodyParser =  require 'body-parser'
fs =          require 'fs'
yargs =       require 'yargs'

frontend =    require './frontend'
backend =     require './backend'
addDocument = require './add-document'
addTag =      require './add-tag'





app = express()
app.use bodyParser.urlencoded extended: true

app.get '/',              frontend
app.get '/backend',       backend
app.post '/add-document', addDocument
app.post '/add-tag',      addTag

app.use express.static __dirname
app.listen yargs.argv.port || 10000
