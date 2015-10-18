express = require 'express'
https = require 'https'
httpProxy = require 'http-proxy'
path = require 'path'

process.on 'uncaughtException', (err) ->
    # This is disgusting, but it's a one-off, so whatever.
    console.log err

app = express()
proxy = httpProxy.createProxyServer()

PING_PONG_KEY = process.env.PING_PONG_KEY
ATHLETABLE_KEY = process.env.ATHLETABLE_KEY

proxyFunc = (request, response) ->
  request.url = request.url.replace '/athletable', ''
  request.url = request.url.replace 'PING_PONG', PING_PONG_KEY
  request.url = "#{request.url}?api_key=#{ATHLETABLE_KEY}"
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

console.log("Listening on #{process.env.PORT || 8090}.");
console.log(PING_PONG_KEY, ATHLETABLE_KEY);
app.listen process.env.PORT || 8090
