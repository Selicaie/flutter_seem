import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class PushNotificationsManager {
  PushNotificationsManager._();

  factory PushNotificationsManager() => _instance;

  static final PushNotificationsManager _instance =
      PushNotificationsManager._();

  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  bool _initialized = false;

  Future<void> init() async {
    if (!_initialized) {
      // For iOS request permission first.
      _firebaseMessaging.requestNotificationPermissions();
      _firebaseMessaging.configure();

      // For testing purposes print the Firebase Messaging token
      String token = await _firebaseMessaging.getToken();
      print("Device Token:---->$token");
      
      _initialized = true;

      handlePushNotificationEvents();
    }
  }

  @override
  void dispose() {
    _initialized = false;
    _firebaseMessaging = null;
  }

  void handlePushNotificationEvents() {
    _firebaseMessaging.configure(
      onLaunch: (Map<String, dynamic> message) async {
        print(message);
        //Add some navigation logic here
        //Navigator.of(context).pushNamed("/instructions");
      },
      onResume: (Map<String, dynamic> message) async {
        print(message);
      },
      onMessage: (Map<String, dynamic> message) async {
        print(message);
      },
    );
  }
}