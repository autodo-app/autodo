#!/bin/ash
ln -s /save/node_modules/* ./node_modules/. > /dev/null 2>/dev/nullq
gatsby develop -H 0.0.0.0 -p 8080
