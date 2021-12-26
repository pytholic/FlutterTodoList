---------------------------------------------------------

iOS run needs Podile, will be generated automatically after Flutter run

-----------------------------------------------------------
if xcode doesn't work (in general or in copied project)

remove ios/Podfile (lockfile and pods as well)

flutter clean
flutter pub get
flutter run

-------------------------------------------------------

flutter run --no-sound-null-safety => resolves issues for provider and other packages
--------------------------------
issue: I/Process ( 5084): Sending signal. PID: 5084 SIG: 9
resolved by adding 'implementation "io.grpc:grpc-okhttp:1.32.2"' in dependice inside android/app/build.gradle

dependencies {
    .
    .
    implementation "io.grpc:grpc-okhttp:1.32.2"
}
---------------------------
changign name

Android
Open AndroidManifest.xml (located at android/app/src/main)

<application
    android:label="App Name" ...> // Your app name here
iOS
Open info.plist (located at ios/Runner)

<key>CFBundleName</key>
<string>App Name</string> // Your app name here

-----------------------------------------

flutter icons

Unhandled exception:
FormatException: Invalid number (at character 1)

In lib/android.dart:
change


    if (line.contains('minSdkVersion')) {
      // remove anything from the line that is not a digit
      final String minSdk = line.replaceAll(RegExp(r'[^\d]'), '');
      return int.parse(minSdk);
    }
  }
  return 0; // Didn't find minSdk, assume the worst


to

    if (line.contains('minSdkVersion')) {
      // remove anything from the line that is not a digit
      final String minSdk = line.replaceAll(RegExp(r'[^\d]'), '');
      try {
        return int.parse(minSdk);
      } on FormatException catch (_) {
        printStatus("minSdk '${minSdk}' cannot be parsed as int ");
      }
    }
  }
  return 0; // Didn't find minSdk, assume the worst

------------------------------------------------
'IPHONEOS_DEPLOYMENT_TARGET' version error

ADD to Podfile:
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

----------------------------------------------------
MigratMigration to cloud_firestore 2.0.0
The migration involves adding a <Map<String, dynamic>> in numerous places.

**Do it only if you use newer versions of firebase_core and cloud_firestore
Examplew
- StreamBuilder<DocumentSnapshot>(
+ StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
  stream: FirebaseFirestore.instance.collection('movies').doc('star-wars').snapshots(),
-  builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
+  builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
    // ...
  }
)

my case
change tranbsformer in utils.dart:
static StreamTransformer<QuerySnapshot, List<T>> transformer<T>(
      T Function(Map<String, dynamic> json) fromJson) =>
  StreamTransformer<QuerySnapshot, List<T>>.fromHandlers(
    handleData: (QuerySnapshot data, EventSink<List<T>> sink) {
      final snaps = data.docs.map((doc) => doc.data()).toList();
      final users = snaps.map((json) => fromJson(json)).toList();

      sink.add(users);
    },
  );

to:


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

