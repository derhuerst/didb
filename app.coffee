express =   require 'express'
fs =        require 'fs'

documents = require './documents.json'
tags =      require './tags.json'

tpl =       require './index.tpl'



app = express()

app.get '/', (req, res) -> res.end tpl req, tags, documents

app.use express.static __dirname
app.listen 10000
