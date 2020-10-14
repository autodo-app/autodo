#!/bin/sh
while ! nc -z ngrok 4040; do   
  sleep 0.5 # wait for 1/10 of the second before check again
done

echo "ngrok started"

API_URL=$(curl --silent --show-error ngrok:4040/api/tunnels | sed -nE 's/.*public_url":"https:..([^"]*).*/\1/p')
echo "{'api-url': $API_URL}" > ./flutter-env.json
flutter pub get
flutter pub run pubspec_extract -s flutter-env.json -d lib/generated/env.dart -c Env