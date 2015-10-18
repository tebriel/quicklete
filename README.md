Quicklete
=========

App for quickly entering a score into [Athletable](https://athletable.com/)

Development
===========

Set your API Key to the environment variable `ATHLETABLE_KEY`
Set your sport key to the environment variable `PING_PONG_KEY`

Run the app with `coffee api/server.coffee`

When changing the code run `grunt watch` to change the app.js

Docker
======

`docker run -p 9000:9000 -e PORT=9000 -e PING_PONG_KEY=<SPORT_KEY> -e ATHLETABLE_KEY=<ATH_KEY> --name quicklete cmoultrie/quicklete`
