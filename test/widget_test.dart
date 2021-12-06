// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_application_1/data/api/api_service.dart';
import 'package:flutter_application_1/data/model/restaurant_model.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_application_1/main.dart';

void main() {
  test('Test http', () async {
  
    // final file = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/albums/1'));
    final Welcome json = await ApiService().list();
 
    print('userId: ${json.restaurants[0].id}');
    final userId = json.restaurants[0].id;
    expect(userId, "rqdv5juczeskfw1e867");
  });
}
