express = require 'express'
spawn = require('child_process').spawn


app = express();

app.get '/', (req,res)->
	zipIOS = spawn './helper/zip.sh'
	zipIOS.on 'exit',(code,signal)->
		res.download './IOS.zip','IOS.zip'

server = app.listen 7461,->
	host = server.address().address
	port = server.address().port

	console.log('Example app listening at http://%s:%s', host, port)
