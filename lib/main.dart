import 'dart:io';

import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/common/navigation.dart';
import 'package:flutter_application_1/data/api/api_service.dart';
import 'package:flutter_application_1/data/db/database_helper.dart';
import 'package:flutter_application_1/data/model/restaurant_detail.dart';
import 'package:flutter_application_1/data/preferences/prefences_helper.dart';
import 'package:flutter_application_1/page/home_page.dart';
import 'package:flutter_application_1/page/restaurant_detail.dart';
import 'package:flutter_application_1/provider/database_provider.dart';
import 'package:flutter_application_1/provider/prefences_provider.dart';
import 'package:flutter_application_1/provider/restaurant_detail_provider.dart';
import 'package:flutter_application_1/provider/restaurant_provider.dart';
import 'package:flutter_application_1/provider/scheduling_provider.dart';
import 'package:flutter_application_1/utils/background_service.dart';
import 'package:flutter_application_1/utils/notification_helper.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

//Inisiasi dan mengatifkan dan menampilakn notifikasi
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();


Future<void> main() async {
  
//Inisiasi dan mengatifkan dan menampilakn notifikasi
//Kode dibawah untuk menjalankan proses 
  WidgetsFlutterBinding.ensureInitialized();

//Inisiasi dan mengatifkan dan menampilakn notifikasi
  final NotificationHelper _notificationHelper = NotificationHelper();
  final BackgroundService _service = BackgroundService();

  _service.initializeIsolate();

  if (Platform.isAndroid) {
    await AndroidAlarmManager.initialize();
  }
  
//Inisiasi dan mengatifkan dan menampilakn notifikasi
  await _notificationHelper.initNotifications(flutterLocalNotificationsPlugin);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => RestaurantProvider(apiService: ApiService())),
        ChangeNotifierProvider(
          create: (_) => SchedulingProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => PreferencesProvider(
            preferencesHelper: PreferencesHelper(
              sharedPreferences: SharedPreferences.getInstance(),
            ),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => DatabaseProvider(databaseHelper: DatabaseHelper()),
        ),
      ],
      child: Consumer<PreferencesProvider>(
        builder: (context, provider, child) {
          return MaterialApp(
            title: "Restaurant App",
        
            navigatorKey: navigatorKey,
            initialRoute: HomePage.routeName,
            routes: {
              HomePage.routeName: (context) => HomePage(),
              RestaurantDetailPage.routeName: (context) => RestaurantDetailPage(
                    restaurant:
                        ModalRoute.of(context)?.settings.arguments as String ,
                  ),
            },
          );
        },
      ),
    );
  }
}
