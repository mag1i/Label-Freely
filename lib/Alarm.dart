import 'dart:async';
import 'dart:developer';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:url_launcher/url_launcher.dart';

class NotificationService {

  //instance of FlutterLocalNotificationsPlugin
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  Future<void> init() async {

    //Initialization Settings for Android
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    //Initialization Settings for iOS
    const IOSInitializationSettings initializationSettingsIOS =
    IOSInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
    );

    //Initializing settings for both platforms (Android & iOS)
    const InitializationSettings initializationSettings =
    InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS);

    tz.initializeTimeZones();

    await flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
        onSelectNotification: onSelectNotification
    );
  }

  onSelectNotification(String? payload) async {
    //Navigate to wherever you want
  }
  ftr(DateTime slct, i) async {
    if (DateTime.now()==slct.add(const Duration(minutes: 2))){
      String em=  i;
      String subject = Uri.encodeComponent(" ");
      String body = Uri.encodeComponent(" ");
      Uri mail = Uri.parse("mailto:$em?subject=$subject&body=$body");
      if (await launchUrl(mail)) {
    }else{
    }
    }
  }
  Future zonedScheduleNotification(int id, String note, DateTime date, occ) async {
    // tz.TZDateTime.parse(location, formattedString)
   // int id = math.Random().nextInt(10000);
    log(date.toString());
    log(tz.TZDateTime.parse(tz.getLocation("Asia/Kolkata"), date.toString())
        .toString());
    try {
      await flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        occ,
        note,
        tz.TZDateTime.parse(tz.getLocation("Asia/Kolkata"), date.toString()),
        NotificationDetails(
          android: AndroidNotificationDetails(
              'your channel id', 'your channel name',
              channelDescription: 'your channel description',
              largeIcon: DrawableResourceAndroidBitmap("logo"),
              icon: "ic_launcher",
              playSound: true,
              sound: RawResourceAndroidNotificationSound('bell_sound')),
        ),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
      );
      return id;
    } catch (e) {
      log("Error at zonedScheduleNotification----------------------------$e");
      if (e ==
          "Invalid argument (scheduledDate): Must be a date in the future: Instance of 'TZDateTime'") {
        //Fluttertoast.showToast(msg: "Select future date");
      }
      return -1;
    }
  }
  requestIOSPermissions() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
  }


  Future<void> showNotifications({id, title, body, payload}) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails('your channel id', 'your channel name',
        channelDescription: 'your channel description',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker');
    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        id, title, body, platformChannelSpecifics,
        payload: payload);
  }
  call(d){
    launch('tel: ${ d}');
  }

  Future<void> scheduleNotifications({id, title, body, time, i}) async {
    try{
      await flutterLocalNotificationsPlugin.zonedSchedule(
          id,
          title,
          body,
          tz.TZDateTime.from(time, tz.local),
          const NotificationDetails(
              android: AndroidNotificationDetails(
                  'your channel id', 'your channel name',
                  channelDescription: 'your channel description')),
          androidAllowWhileIdle: true,
          uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime);

    /*  if (DateTime.now()==time.add(const Duration(minutes: 1))){
        String em=  i;
    //   String email = Uri.encodeComponent("bechmanel@gmail.com");
        String subject = Uri.encodeComponent(" ");
        String body = Uri.encodeComponent(" ");
        print(subject); //output: Hello%20Flutter
        Uri mail = Uri.parse("mailto:$em?subject=$subject&body=$body");
        if (await launchUrl(mail)) {
          //email app opened
        }else{
          //email app is not opened
        }
      }*/
    }catch(e){
      print(e);
    }
  }
}

