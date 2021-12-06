import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/common/navigation.dart';
import 'package:flutter_application_1/provider/prefences_provider.dart';
import 'package:flutter_application_1/provider/scheduling_provider.dart';
import 'package:flutter_application_1/widget/platform.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  static const String settingsTitle = 'Settings';

  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(settingsTitle),
      ),
      body: _buildList(context),
    );
  }

  Widget _buildIos(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(settingsTitle),
      ),
      child: _buildList(context),
    );
  }

  Widget _buildList(BuildContext context) {
    return Consumer<PreferencesProvider>(
      builder: (context, provider, child) {
        return ListView(
          children: [
          
            Material(
              child: ListTile(
                title: Text('Scheduling News'),
                trailing: Consumer<SchedulingProvider>(
                  builder: (context, scheduled, _) {
                    return Switch.adaptive(
                      value: provider.isDailyNewsActive,
                      onChanged: (value) async {
                        if (Platform.isIOS) {
                          customDialog(context);
                        } else {
                          scheduled.schedeuleAlarm(value);
                          //scheduled.scheduledNews(value);
                          provider.enableDailyRestaurant(value);
                        }
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder: _buildAndroid,
      iosBuilder: _buildIos,
    );
  }

  customDialog(BuildContext context) {
    if (Platform.isIOS) {
      showCupertinoDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text('Coming Soon!'),
            content: Text('This feature will be coming soon!'),
            actions: [
              CupertinoDialogAction(
                child: Text('Ok'),
                onPressed: () {
                  Navigation.back();
                },
              ),
            ],
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Coming Soon!'),
            content: Text('This feature will be coming soon!'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigation.back();
                },
                child: Text('Ok'),
              ),
            ],
          );
        },
      );
    }
  }
}
