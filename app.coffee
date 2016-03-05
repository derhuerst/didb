#!/usr/bin/env coffee

express =   require 'express'
fs =        require 'fs'
yargs =     require 'yargs'

frontend =  require './frontend'





app = express()

app.get '/', frontend

app.use express.static __dirname
app.listen yargs.argv.port || 10000
