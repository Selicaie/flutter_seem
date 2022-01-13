import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:instructions_app/services/database.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PushNotificationsManager {
  var context;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin ;
  PushNotificationsManager(BuildContext context,FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin){this.context = context;
  this.flutterLocalNotificationsPlugin =flutterLocalNotificationsPlugin;}
  //BuildContext get currentContext => context;
  // PushNotificationsManager._();

  // factory PushNotificationsManager() => _instance;

  // static final PushNotificationsManager _instance = PushNotificationsManager._();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  bool _initialized = false;
  //BuildContext get currentContext => _currentElement;
 saveToken() async {
     // For testing purposes print the Firebase Messaging token
      String token = await _firebaseMessaging.getToken();
      print("FirebaseMessaging token: $token");
      SharedPreferences prefs = await SharedPreferences.getInstance(); 
      String internalToken= prefs.getString("token");
      
      if(token!=null)
      {
        if(token!=internalToken)
        {
          prefs.setString("token",token);
          String uid = prefs.getString('uid') ?? "";
          if(uid!="")
            await DatabaseService(uid:uid).saveDeviceToken(token);
        }
        
      }
  }
  Future<void> init() async {
    if (!_initialized) {
      // For iOS request permission first.
      // if (Platform.isIOS) {
      // _firebaseMessaging.requestNotificationPermissions(IosNotificationSettings(sound: true, badge: true, alert: true, provisional: false));
    //}

//_firebaseMessaging.requestNotificationPermissions(IosNotificationSettings(sound: true, badge: true, alert: true, provisional: false));
    //_firebaseMessaging.requestNotificationPermissions();
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        //var to = message['to'] ?? '';
        var title = message['notification']['title'] ?? '';
        var body = message['notification']['body'] ?? '';  
        _showNotification(1234, title, body, "GET PAYLOAD FROM message OBJECT");
         print("onMessage: $message");
        Navigator.of(context).pushNamed("/instructions");
        //Navigator.of(context).pushNamed(message['screen']).
        //print("onMessage: "+message['notification']['title']);
       
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        Navigator.of(context).pushNamed("/instructions");
        // Navigator.pop(context);
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        // Navigator.pop(context);
        Navigator.of(context).pushNamed("/instructions");
       
      },);
     // _firebaseMessaging.configure();

      
      await saveToken();
        
      _initialized = true;

      
    }
  }
  Future<void> _showNotification(
    int notificationId,
    String notificationTitle,
    String notificationContent,
    String payload, {
    String channelId = '1234',
    String channelTitle = 'New Instructions!',
    String channelDescription = 'empty message..',
    Priority notificationPriority = Priority.High,
    Importance notificationImportance = Importance.Max,
  }) async {
    const int insistentFlag = 4;
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
      channelId,
      channelTitle,
      channelDescription,
      // playSound: false,
      importance: notificationImportance,
      priority: notificationPriority,
      additionalFlags: Int32List.fromList(<int>[insistentFlag])
    );
    //var iOSPlatformChannelSpecifics = new IOSNotificationDetails(presentSound: false);
     var iOSPlatformChannelSpecifics =
        new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      notificationId,
      notificationTitle,
      notificationContent,
      platformChannelSpecifics,
      // payload: payload,
      payload: 'Default_Sound',
    );
  }
}