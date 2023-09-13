import 'dart:developer';

import 'package:chat_app_af_12/Components/Helpers/notification_helper.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class Notification_Screen extends StatefulWidget {
  const Notification_Screen({super.key});

  @override
  State<Notification_Screen> createState() => _Notification_ScreenState();
}

class _Notification_ScreenState extends State<Notification_Screen> {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  Future<void> getFCMToken() async {
    String? token = await messaging.getToken();
    log("===================================================");
    log("FCM TOKEN:- ${token}");
    log("===================================================");
  }

  Future<void> FCMforgroundMesage() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Flutter Chat App"),
          content: Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("${message.notification?.title}"),
                Text("${message.notification?.body}")
              ],
            ),
          ),
        ),
      );
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Notification_Helper.notification_helper.initNotification();
    FCMforgroundMesage();
    getFCMToken();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notification Screen"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () {
                  Notification_Helper.notification_helper.SimpleNotification();
                },
                child: Text("Simple Notification")),
            ElevatedButton(
                onPressed: () {
                  Notification_Helper.notification_helper
                      .ScheduledNotification();
                },
                child: Text("Scheduled Notification")),
            ElevatedButton(
                onPressed: () {
                  Notification_Helper.notification_helper
                      .mediaStyleNotification();
                },
                child: Text("Media Style Notification")),
            ElevatedButton(
                onPressed: () {
                  Notification_Helper.notification_helper
                      .bigPictureNotification();
                },
                child: Text("Big Picture Notification")),
          ],
        ),
      ),
    );
  }
}
