import 'dart:convert';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../global.dart';
import 'package:http/http.dart' as http;

import '../rest/hive_repo.dart';

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;

  // Function to initialize notifications
  Future<void> initNotifications() async {
    // Request Permission
    NotificationSettings settings = await _firebaseMessaging.requestPermission();
    if (settings.authorizationStatus == AuthorizationStatus.denied) {
      print("User denied notifications permissions.");
      return;
    }

    final fCMToken = await _firebaseMessaging.getToken();
    fcmTokenValue = fCMToken ?? '';
    if (fcmTokenValue.isEmpty) {
      print("Error: FCM Token is null or empty");
      return;
    }

    print("Token: $fCMToken");

    // Get device ID (UUID)
    String deviceId = await getDeviceId();
    print("Device ID: $deviceId");

    // Update Notification data in your provider
    await updateNotificationValue(deviceId, fcmTokenValue);

    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
  }

  // Fetch device ID
  Future<String> getDeviceId() async {
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    String deviceId = '';

    if (Platform.isAndroid) {
      final AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      deviceId = androidInfo.id;  // Unique ID for Android
    } else if (Platform.isIOS) {
      final IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      deviceId = iosInfo.identifierForVendor!;  // Unique ID for iOS
    }

    return deviceId;
  }

  // Handle background message
  Future<void> handleBackgroundMessage(RemoteMessage? message) async {
    if (message == null) return;

    print("Title: ${message.notification?.title}");
    print("Body: ${message.notification?.body}");
    // Navigate to new screen when user taps the notification
    // navigatorKey.currentState?.pushNamed("/events_screen");
  }


  Future<void> updateNotificationValue(String device_id, String token) async {
    try {

      String? baseurl = "https://wawapp.globify.in/api";

      final url = Uri.parse('$baseurl/update-device-token');
      final map = {
        "device_id": device_id,
        "token": token,
      };

      final response = await http.post(
        url,
        headers: {'api-key':'1W4YUli4lxsxl9PkkMT6pEQjJ0jBmoht','Content-Type': 'application/json'},
        body: json.encode(map),
      );

      if (response.statusCode == 200) {
        // API call was successful
        if (kDebugMode) {
          print("API Response: ${response.body}");
        }
      } else {
        // API call failed
        if (kDebugMode) {
          print("Error: ${response.statusCode}");
          print("Response body: ${response.body}");
        }
      }
    } catch (e, stackTrace) {
      // Log the error details
      if (kDebugMode) {
        print("Error occurred: $e");
        print("StackTrace: $stackTrace");
      }
    }
  }

}
