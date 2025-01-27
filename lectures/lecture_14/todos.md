# Denna vecka

Notiser samt bildtagning + uppladdning. 

# Steg

- [ X ] Uppdatera modeller så att t.ex. parkering har en sluttid och att en bil har en string som representerar url:en för var bilder sparas
- [ X ] Uppdatera GUI så att du kan sätta sluttid (något som ska styra dina notiser)
- [ X ] TIPS!! keyboardType: TextInputType.number,  inputFormatters: [FilteringTextInputFormatter.digitsOnly] på textinput för att föra in nummer           
- [ X ] flutter pub add intl (för att formatera tid)
- [  ] flutter pub add flutter_local_notifications
- [  ] Android - android/app/src/main/AndroidManifest.xml, add <uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED"/> 
    <uses-permission android:name="android.permission.USE_EXACT_ALARM" /> (tillåt notification efter reboot), placeras inom <manifest/> taggarna
- [  ] Notis ikon: <meta-data
  android:name="com.google.firebase.messaging.default_notification_icon"
  android:resource="@mipmap/ic_launcher"/>
        För egna ikoner, generera nya drawables, finns https://pub.dev/packages/android_notification_icons ,i givna exemplet, byt resource till ="@drawable/ic_notification"
- [  ] Initialisera plugin
- [  ] Upgrade android NDK version:         ndkVersion = "27.0.12077973" i android/app/build.gradle
- [  ] flutter pub add timezone
- [  ] flutter pub add flutter_timezone


add to app/src/main/AndroidManifest.xml inside application tag:

<!-- 

        <receiver android:exported="false" android:name="com.dexterous.flutterlocalnotifications.ScheduledNotificationReceiver" />
        <receiver android:exported="false" android:name="com.dexterous.flutterlocalnotifications.ScheduledNotificationBootReceiver">
            <intent-filter>
                <action android:name="android.intent.action.BOOT_COMPLETED"/>
                <action android:name="android.intent.action.MY_PACKAGE_REPLACED"/>
                <action android:name="android.intent.action.QUICKBOOT_POWERON" />
                <action android:name="com.htc.intent.action.QUICKBOOT_POWERON"/>
            </intent-filter>
        </receiver>

 -->


make sure android/app/build.gradle has these
<!-- 
android {
  defaultConfig {
    multiDexEnabled true
  }

  compileOptions {
    // Flag to enable support for the new language APIs
    coreLibraryDesugaringEnabled true
    // Sets Java compatibility to Java 8
    sourceCompatibility JavaVersion.VERSION_1_8
    targetCompatibility JavaVersion.VERSION_1_8
  }
}

dependencies {
  coreLibraryDesugaring 'com.android.tools:desugar_jdk_libs:1.2.2'
}
 -->

update ndkVersion in android/app/build.gradle and compileSdk

<!-- 

    //compileSdk = flutter.compileSdkVersion
    //ndkVersion = flutter.ndkVersion
    compileSdk = 35
    ndkVersion = "27.0.12077973"
    
     -->

update minSdk to 23 in android/app/build.gradle

<!-- 

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.example.admin_app"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        /* STI NOTIFICATIONS */
        //minSdk = flutter.minSdkVersion
        minSdk = 23


 -->

 in android/build.gradle

<!-- 

plugins {
    /* STI NOTIFICATIONS */
      // Add the dependency for the Google services Gradle plugin
  id 'com.google.gms.google-services' version '4.4.2' apply false
}

 -->

 also in android/app/build.gradle

 <!-- 
 
 /* STI NOTIFICATIONS */
dependencies {
  coreLibraryDesugaring 'com.android.tools:desugar_jdk_libs:1.2.2'

  // Import the Firebase BoM
  implementation(platform("com.google.firebase:firebase-bom:33.8.0"))

  // When using the BoM, you don't specify versions in Firebase library dependencies

  // TODO: Add the dependencies for Firebase products you want to use
  // See https://firebase.google.com/docs/android/setup#available-libraries
  // For example, add the dependencies for Firebase Authentication and Cloud Firestore
  implementation("com.google.firebase:firebase-auth")
  implementation("com.google.firebase:firebase-firestore")

}
 
  -->


 use this code for notifications initialization

<!-- 

late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;



Future<void> initializeNotifications() async {
  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  var initializationSettingsAndroid = const AndroidInitializationSettings(
      '@mipmap/ic_launcher'); // TODO: Change this to an icon of your choice if you want to fix it.
  var initializationSettingsIOS = const DarwinInitializationSettings();
  var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
}

 -->

use this to schedule notifications


<!-- 

int notifications = 0;

Future<void> scheduleNotification(
    {required String title,
    required String content,
    required DateTime time}) async {
  await requestPermissions();

  String channelId = const Uuid()
      .v4(); // id should be unique per message, but contents of the same notification can be updated if you write to the same id
  const String channelName =
      "notifications_channel"; // this can be anything, different channels can be configured to have different colors, sound, vibration, we wont do that here
  String channelDescription =
      "Standard notifications"; // description is optional but shows up in user system settings
  var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      channelId, channelName,
      channelDescription: channelDescription,
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker');
  var iOSPlatformChannelSpecifics = const DarwinNotificationDetails();
  var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics);

  // from docs, not sure about specifics
  //
  return await flutterLocalNotificationsPlugin.zonedSchedule(
      notifications++,
      title,
      content,
      tz.TZDateTime.from(
          time,
          tz
              .local), // TZDateTime required to take daylight savings into considerations.
      platformChannelSpecifics,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime);
}

 -->

configure timezones

 <!-- 

import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

 
 Future<void> _configureLocalTimeZone() async {
  if (kIsWeb || Platform.isLinux) {
    return;
  }
  tz.initializeTimeZones();
  if (Platform.isWindows) {
    return;
  }
  final String timeZoneName = await FlutterTimezone.getLocalTimezone();
  tz.setLocalLocation(tz.getLocation(timeZoneName));
}
 
  /* STI NOTIFICATIONS */
  tz.initializeTimeZones();
  await _configureLocalTimeZone();


  -->

request permissions

<!-- 

Future<void> requestPermissions() async {
  if (Platform.isIOS || Platform.isMacOS) {
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            MacOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  } else if (Platform.isAndroid) {
    final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
        flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    await androidImplementation?.requestNotificationsPermission();
  }
}

 -->




  IOS



  Add following to ios/Runner/AppDelegate.swift in application function ([example](https://github.com/MaikuB/flutter_local_notifications/blob/master/flutter_local_notifications/example/ios/Runner/AppDelegate.swift))

  <!-- 
  
  if #available(iOS 10.0, *) {
  UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
}
  
   -->