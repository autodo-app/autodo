#!/bin/ash
ln -s /save/node_modules/* ./node_modules/.
gatsby develop -H 0.0.0.0 -p 8080
