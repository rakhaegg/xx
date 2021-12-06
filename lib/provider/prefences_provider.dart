
import 'package:flutter/material.dart';
import 'package:flutter_application_1/common/styles.dart';
import 'package:flutter_application_1/data/preferences/prefences_helper.dart';

class PreferencesProvider extends ChangeNotifier {
  PreferencesHelper preferencesHelper;

  PreferencesProvider({required this.preferencesHelper}) {
  
    _getRestautarantPrefence();
  }

  bool _isDailyNewsActive = false;
  bool get isDailyNewsActive => _isDailyNewsActive;

  


  void _getRestautarantPrefence() async {
    _isDailyNewsActive = await preferencesHelper.isRestaurantActive;
    notifyListeners();
  }



  void enableDailyRestaurant(bool value) {
    preferencesHelper.setDailyRestaurant(value);
    _getRestautarantPrefence();
  }
}
