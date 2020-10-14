#!/bin/sh
# runs docker and flutter with a connection to the api through ngrok

docker-compose up -d
while ! nc -z localhost 4040; do   
  sleep 0.5 # wait for 1/10 of the second before check again
done

echo "ngrok started"

cd mobile
API_URL=$(curl --silent --show-error localhost:4040/api/tunnels | sed -nE 's/.*public_url":"https:..([^"]*).*/\1/p')
echo "{'api-url': '$API_URL'}" > ./flutter-env.json
flutter pub get
flutter pub run pubspec_extract -s flutter-env.json -d lib/generated/env.dart -c Env
flutter run