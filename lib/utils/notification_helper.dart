import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/common/navigation.dart';
import 'package:flutter_application_1/data/api/api_service.dart';
import 'package:flutter_application_1/data/model/restaurant_detail.dart';
import 'package:flutter_application_1/data/model/restaurant_model.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/subjects.dart';

final selectNotificationSubject = BehaviorSubject<String>();

class NotificationHelper {
 

  static NotificationHelper? _instance;

  NotificationHelper._internal() {
    _instance = this;

    
  }



  factory NotificationHelper() => _instance ?? NotificationHelper._internal();

  Future<void> initNotifications(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('@mipmap/ic_launcher');

    var initializationSettingsIOS = IOSInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String? payload) async {
      if (payload != null) {
        print('notification payload: ' + payload);
      }
      selectNotificationSubject.add(payload ?? 'empty payload');
    });
  }

  //Kode dibawah untuk menampilkan notifikasi sederhana
  Future<void> showNotification(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
      Restaurant  restaurant) async {
    var _channelId = "1";
    var _channelName = "channel_01";
    var _channelDescription = "restaurant channel";

    //Kode dibawah untuk mengatur konfigurasi notifikasi pada platform android
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      _channelId, _channelName, channelDescription: _channelDescription,
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',

      //StyleInformation untuk memberikan style pada notifikasi Android melalui markup HTML
      styleInformation: DefaultStyleInformation(true, true),
    );

    //Kode dibawah untuk mengatur konfigurasi notifikasi pada platform IOS
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();

    //Kode dibawah untuk pengatur notifikasi setiap platform
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);

    var titleNotification = "<b>Restaurant</b>";
    // var titleNews = articles.articles[0].title;

    //Generator Random Number
    //number = await getRandomNumber(restaurant.count);

    //

    var titleNews = restaurant.name;

    //Kode dibawha untuk menampilkan notifikasi
    await flutterLocalNotificationsPlugin.show(
        0, titleNotification, titleNews, platformChannelSpecifics,
        //payload untuk diterus kembali melalui aplikasi saat pengguna mengentuk aplikasi
        payload: json.encode(restaurant.toJson()) );
  }

  void configureSelectNotificationSubject(String route) {
    selectNotificationSubject.stream.listen(
      (String payload) async {
       
        // var data = Welcome.fromJson(json.decode(payload));
        var data = Restaurant.fromJson(json.decode(payload) );
       
          var article = data.id;
          Navigation.intentWithData(route, article);
        }
      
    );
  }

  int getRandomNumber(int restaurant) {
    final _random = new Random();
    int randomNumber = _random.nextInt(restaurant); 
    return randomNumber;
  }
}
