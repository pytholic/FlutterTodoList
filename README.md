# Todo List App

A cross-platform **Todo List App** created using `Dart` and `Flutter`. I followed the tutorials by [Johannes Mike](https://github.com/JohannesMilke) for personal learning. Then started tinkering with the app to customize it and learn more about Flutter.

---
## Flutter Setup
* [Tutorial link](https://www.youtube.com/watch?v=5FEY5-1m1cs&t=899s)

### Steps
Follow the instructions on [offical website](https://docs.flutter.dev/get-started/install/windows), depending on your operating system. In my case I am using **Windows**.
* Download and install `JDK` from the [link](https://www.oracle.com/java/technologies/downloads/)
* Install [Git](https://git-scm.com/download/win)
* Download the latest stable release of the **Flutter SDK**
* Extract the zip file and place the contained flutter in the desired installation location for the Flutter SDK.
*   **Warning:** Do not install Flutter in a directory like `C:\Program Files\` that requires elevated privileges.
* Add `flutter\bin` to your `PATH` environment variable
* Download and install **Android Studio** and **VS Code**
* Install ``Android SDK Tools`` and ``Google usb driver`` from Android Studo's **SDK Mnagaer**
* Install `FLutter` and `Dart` extensions in VS Code.
* Setup an emulator in `AVD Manager` inside Android Studio to run your apps in a virtual device. Alternatively, you can also use a real device.

## Firebase Setup
### Steps for android
* Create a new `project` on you firebase account
* Then create an android app
* Find `package name` at `android/app/main/src/build.gradle` and look for `applicationID`
* Register the app
* Add the Firebase Android configuration file to your app:
*   Click Download `google-services.json` to obtain your Firebase Android config file.
*   Move your config file into the module (app-level) directory of your app. 
* In your root-level (`project-level`) Gradle file (`build.gradle`), add rules to include the Google Services Gradle plugin. Check that you have Google's Maven repository, as well.
```
dependencies {
    // ...

    // Add the following line:
    classpath 'com.google.gms:google-services:4.3.10'  // Google Services plugin
  }
}
```
* In your module (`app-level`) Gradle file (usually `app/build.gradle`), apply the Google Services Gradle plugin:
```
apply plugin: 'com.android.application'
// Add the following line:
apply plugin: 'com.google.gms.google-services'  // Google Services plugin

android {
  // ...
}
```
* Declare the dependencies for the **Firebase** products that you want to use in your app. Declare them in your module (`app-level`) Gradle file (usually `app/build.gradle`).
```
dependencies {
  // ...
  // Declare the dependency for the Firebase SDK for Google Analytics
  implementation 'com.google.firebase:firebase-analytics'
}
```

* [Tutorial link](https://www.youtube.com/watch?v=LKLLcrisa6M&t=839s)
* [iOS](https://firebase.google.com/docs/ios/setup)
* [Android](https://firebase.google.com/docs/android/setup)
* 
---
## App functionality
* Add, Edit and Delete tasks
* Colorful widgets
* Local plus cloud storage using `firebase`

## Resolving Issues
In case you run into some build issues after copying your project among different devices or after some package updates, try the following steps before anything else.
Run following command in `root` directory.
```console
flutter clean
flutter pub get
flutter run
```

### Unsound safety check
Some packages give **unsound safety check** issue if you have older versions of `firebase plugins`. Reolve this by adding \
--no-sound-safety-check argument to your run command.
```console
flutter run --no-sound-safety-check
```

### Running on iOS
* iOS run needs `Podile`. It will be generated automatically after Flutter run.
* If `xcode` doesn't work (in general or in copied project), remove `ios/Podfile` (lockfile and pods as well)

Then run in the `root` project directory.
```console
flutter clean
flutter pub get
flutter run
```

### IO.GRPC Error
If you see the error `"issue: I/Process ( 5084): Sending signal. PID: 5084 SIG: 9"`, then do the following to resolve it.
* Open `android/app/build.gradle`
* Inside `dependies` list, add `implementation "io.grpc:grpc-okhttp:1.32.2"`

```yaml
dependencies {
    .
    .
    implementation "io.grpc:grpc-okhttp:1.32.2"
}
```

### Version Issue
**'IPHONEOS_DEPLOYMENT_TARGET'** version error
* ADD to Podfile:

```
post_install do |installer|
  installer.pods_project.targets.each do |target|
      flutter_additional_ios_build_settings(target)
      target.build_configurations.each do |config|
         if config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'].to_f < 10.0
           config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '10.0'
         end
      end
  end
end
```

### MigratMigration to cloud_firestore 2.0.0
* The migration involves adding a `<Map<String, dynamic>>` in numerous places
* Do it only if you use newer versions of `firebase_core` and `cloud_firestore`

#### Example
```html
- StreamBuilder<DocumentSnapshot>(
+ StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
  stream: FirebaseFirestore.instance.collection('movies').doc('star-wars').snapshots(),
-  builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
+  builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
    // ...
  }
)
```

#### My Case
* Change tranbsformer in `utils.dart` from
```dart
static StreamTransformer<QuerySnapshot, List<T>> transformer<T>(
      T Function(Map<String, dynamic> json) fromJson) =>
  StreamTransformer<QuerySnapshot, List<T>>.fromHandlers(
    handleData: (QuerySnapshot data, EventSink<List<T>> sink) {
      final snaps = data.docs.map((doc) => doc.data()).toList();
      final users = snaps.map((json) => fromJson(json)).toList();

      sink.add(users);
    },
  );
```

to
```dart
  static StreamTransformer<QuerySnapshot<Map<String, dynamic>>, List<T>>
      transformer<T>(T Function(Map<String, dynamic> json) fromJson) =>
          StreamTransformer<QuerySnapshot<Map<String, dynamic>>,
              List<T>>.fromHandlers(
            handleData: (QuerySnapshot data, EventSink<List<T>> sink) {
              final snaps = data.docs.map((doc) => doc.data()).toList();
              final users = snaps
                  .map((json) => fromJson(json as Map<String, dynamic>))
                  .toList();

              sink.add(users);
            },
          );
```

### Debug mode issue on <= iOS 14
While debugging/running on devices with `iOS 14` or less, the app stopped working as soon as the program is terminated in the IDE. To resolve it, add `--release` to your flutter run command.
```console
flutter run --release --no-sound-null-safety
```

---
## Acknowledgement
Special thanks to [Johannes Mike](https://github.com/JohannesMilke) for his amazing youtube tutorial and repository.


### [Johannes's](https://www.youtube.com/channel/UC0FD2apauvegCcsvqIBceLA) Youtube Tutorials:
* [Todo App Tutorial](https://www.youtube.com/watch?v=kN9Yfd4fu04&t=963s)
* [Firebase integration tutoria](https://www.youtube.com/watch?v=EV2DyrKOqrY&t=273s)
