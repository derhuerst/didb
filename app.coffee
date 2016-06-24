#!/usr/bin/env coffee

express =     require 'express'
yargs =       require 'yargs'
cfg = require 'config'

app = express()
app.get '/', require './routes/frontend'
app.use express.static __dirname
app.listen(cfg.ports.http)
