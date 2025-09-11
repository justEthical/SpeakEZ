to generate apk
java -jar bundletool.jar build-apks \
  --bundle=/Users/ash/47/SpeakEZ/build/app/outputs/bundle/release/app-release.aab \
  --output=/Users/ash/47/SpeakEZ/app.apks \
  --connected-device

to install
java -jar bundletool.jar install-apks --apks=/Users/ash/47/SpeakEZ/app.apks

to listen to logs 
adb logcat | grep com.english.learning.speakez.ai
