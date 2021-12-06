import 'dart:math';
import 'dart:ui';
import 'dart:isolate';

import 'package:flutter_application_1/data/api/api_service.dart';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/utils/notification_helper.dart';

//Kode dibawah untuk melakukan komunikasi dari isolasi background  ke isolasi UI
final ReceivePort port = ReceivePort();

class BackgroundService {
  static BackgroundService? _instance;
  static String _isolateName = 'isolate';
  static SendPort? _uiSendPort;

  BackgroundService._internal() {
    _instance = this;
  }

  factory BackgroundService() => _instance ?? BackgroundService._internal();

  //Kode dibawah untuk inisiasi ketika menjalankan tugas isolate
  void initializeIsolate() {
    IsolateNameServer.registerPortWithName(
      port.sendPort,
      _isolateName,
    );
  }

  //Kode dibawha dijalankan ketika aplikasi ditutup ,  dibuka , dan juga diminimize
  //Fungsi dibawah proses yang ingin dijalankan background dan foregorund
  static Future<void> callback() async {
    print('Alarm fired!');
    final NotificationHelper _notificationHelper = NotificationHelper();
    
    
    var result = await ApiService().list();
    
    final restaurant = result.restaurants[getRandomNumber(result.count)];

    await _notificationHelper.showNotification(
        flutterLocalNotificationsPlugin, restaurant);

    _uiSendPort ??= IsolateNameServer.lookupPortByName(_isolateName);
    _uiSendPort?.send(null);
  }
  static int getRandomNumber(int restaurant) {
    final _random = new Random();
    int randomNumber = _random.nextInt(restaurant); 
    return randomNumber;
  }
}
