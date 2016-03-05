#!/usr/bin/env coffee

express =     require 'express'
bodyParser =  require 'body-parser'
fs =          require 'fs'
yargs =       require 'yargs'





app = express()
app.use bodyParser.urlencoded extended: true

app.get '/',           require './frontend'
app.get '/documents',  require './list-documents'
app.post '/documents', require './add-document'
app.get '/tags',       require './list-tags'
app.post '/tags',      require './add-tag'

app.use express.static __dirname
app.listen yargs.argv.port || 10000
