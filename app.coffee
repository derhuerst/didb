#!/usr/bin/env coffee

express =     require 'express'
yargs =       require 'yargs'

app = express()
app.get '/', require './frontend'
app.use express.static __dirname
app.listen yargs.argv.port || 80
