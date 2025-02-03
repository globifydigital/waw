
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:path/path.dart';

import '../global.dart';

class FirebaseApi {

  // instance of firebase messaging
  final _firebaseMessaging = FirebaseMessaging.instance;

  // function to initialize notifications
  Future<void> initNotifications() async {
    // request Permission
    await _firebaseMessaging.requestPermission();

    final fCMToken = await _firebaseMessaging.getToken();

    fcmTokenValue = fCMToken ?? '';
    print("Token $fCMToken");
    //dDGuMZEvR3yv2YDGCd7H9e:APA91bHNpmyNJZjmM_P_A5hPWKkfZ7uZzTtGT-2L0PhXoZJJBWWfKsLo1U4tVXnyCGUu4WjsL6VQjB6HNqqcCddxY1m59cYwlX9_jN1HDFC8D7OgJQKccrk
    //dDGuMZEvR3yv2YDGCd7H9e:APA91bHNpmyNJZjmM_P_A5hPWKkfZ7uZzTtGT-2L0PhXoZJJBWWfKsLo1U4tVXnyCGUu4WjsL6VQjB6HNqqcCddxY1m59cYwlX9_jN1HDFC8D7OgJQKccrk
    print("fcmTokenValue Firebase Api $fcmTokenValue");
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
    // await initPushNotification();
  }


  Future<void> handleBackgroundMessage (RemoteMessage? message) async{

    if(message == null)  return;

    print("title : ${message.notification?.title}");
    print("body : ${message.notification?.body}");
    // navigate to new screen when user tap the notification
    // navigatorKey.currentState?.pushNamed("/events_screen");

  }


  // handle background settings
  // Future initPushNotification() async {
  //   FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
  //   FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
  // }

}