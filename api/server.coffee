express = require 'express'
https = require 'https'
httpProxy = require 'http-proxy'
path = require 'path'

app = express()
proxy = httpProxy.createProxyServer()

proxyFunc = (request, response) ->
  request.url = request.url.replace '/athletable', ''
  request.url = "#{request.url}?api_key=#{process.env.ATHLETABLE_KEY}"
  console.log request.url
  proxyObj = proxy.web request, response,
    port: 443
    target: 'https://athletable.com'
    agent: https.globalAgent
    headers:
      host: 'athletable.com'
  return proxyObj

# forwards to athletable
app.get '/athletable/*', proxyFunc
app.post '/athletable/*', proxyFunc
app.delete '/athletable/*', proxyFunc

# serves all static files from current dir.
app.use '/', express.static path.join(process.cwd(), 'app')

app.listen process.env.PORT || 8090
