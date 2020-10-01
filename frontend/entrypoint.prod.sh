#!/bin/ash
ln -s /save/node_modules/* ./node_modules/.
ln -s /save/public/* ./public/.
# gatsby build
gatsby serve -H 0.0.0.0 -p 8080
