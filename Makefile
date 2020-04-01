BUILD_NAME?=$(shell grep -E '^version:' pubspec.yaml | sed -E 's/version:\s*([^+]+).*/\1/g')
BUILD_NUMBER?=$(shell grep -E '^version:' pubspec.yaml | sed -E 's/version:\s*[^+]+\+(.*)/\1/g')
STORE_FILE?=keystore.jks

all: lib/generated/keys.dart lib/generated/localization.dart lib/generated/pubspec.dart

.dart_tool/package_config.json: pubspec.yaml pubspec.lock
	sed -E "s/^version:.*/version: $(BUILD_NAME)+$(BUILD_NUMBER)/g" -i pubspec.yaml
	flutter pub get

lib/generated/keys.dart: keys.json .dart_tool/package_config.json
	flutter pub run pubspec_extract -s $< -d $@ -c Keys

lib/generated/localization.dart: $(shell find assets/intl/*.json) .dart_tool/package_config.json
	flutter pub run json_intl -d $@

lib/generated/pubspec.dart: pubspec.yaml .dart_tool/package_config.json
	flutter pub run pubspec_extract -s $< -d $@

build-android: lib/generated/keys.dart lib/generated/localization.dart lib/generated/pubspec.dart android/app/src/release/google-services.json android/app/$(STORE_FILE)
	flutter build appbundle --release --target-platform android-arm,android-arm64,android-x64
	cd android; bundle exec fastlane beta
