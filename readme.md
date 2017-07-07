### Purpose

Tiny sinatra app for mirroring post requests in order to test webhooks.  Comes with a get route that allows you to wake it up manually if running on a dev instance.

GET '/' \# => Wakes up the app
POST \/.*\/ \# => Accepts a post to any route
