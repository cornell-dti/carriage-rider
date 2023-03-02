# The Complete Mobile Setup Guide

## First-time Setup

-   If you don't have Xcode, you'll first need that.
-   Download Android Studio and install
    -   also download the cmdline version, following the steps here: https://developer.android.com/studio/command-line/sdkmanager
        after following all 4 steps, copy the entire cmdline-tools folder into where Android Studio installed your SDK (probably ~/Library/Android/sdk/)
-   Follow the steps here: https://docs.flutter.dev/get-started/install/macos
    -   and here: https://docs.flutter.dev/get-started/install/macos#update-your-path
-   When you run `flutter doctor`, look for the errors it gives and correct them, if any
    -   for instance, cocoapods is often out of date. Run `sudo gem install cocoapods`

## First Time Run

Open Android Studio
0. Install the Flutter plugin if you haven’t already
1. Tools > Device Manager
2. You should already have a Pixel device (or some other Android of some sort)
   a. If you don’t … uh, we need to get you an emulator!
3. Hit the Edit button, Advanced Settings, and increase internal storage (5gb at least)
4. Configure the buttons along the top row of the screen to have selected the Pixel device as emulator, and main.dart as the code to run
5. Run the following command: `keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android`
   and then send the SHA1 key to your TPM to add it to the Google Firebase list of allowed fingerprints
6. Your TPM should then download the generated google-services.json and replace the current one under android/app/google-services.json with the new one and push
7. Go checkout the TPM’s new changes from Git
8. Hit Run (play button) on the device in the Device Manager
9. If Heroku (or your respective backend) is down, logging in won’t work. Make sure Heroku is up

## Future Runs

1. Tools > Device Manager
2. Hit the Play button on the Pixel device
3. Hit the Run button in the top bar in Android Studio

## Bug Fixing

If you get a Ruby Bus Error, try running `sudo gem uninstall ffi && sudo gem install ffi -- --enable-libffi-alloc` in your Terminal

If the emulator won't connect to VSCode (connection times out), see if the emulator is closed but not actually quitted (is it still in your Dock?) If so, open it again and hit Cmd+Q to quit it properly. Then, try running it again.

If you get 'Error: Member not Found' try:
`flutter channel stable
flutter upgrade
flutter pub upgrade`