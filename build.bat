del /F /A /Q build\app\outputs\flutter-apk\*
del /F /A /Q build\app\outputs\apk\release\*
flutter build apk --split-per-abi && pause

