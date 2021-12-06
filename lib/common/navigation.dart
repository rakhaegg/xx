import 'package:flutter/material.dart';




final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();


//Dibutuhkan untuk NOTIFICATION HELPER tanpa harus context
class Navigation {
  static intentWithData(String routeName, String arguments) {
    navigatorKey.currentState?.pushNamed(routeName, arguments: arguments);
  }

  static back() => navigatorKey.currentState?.pop();
}
