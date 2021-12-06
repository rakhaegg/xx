import 'dart:async';


import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_application_1/data/api/api_service.dart';
import 'package:flutter_application_1/data/model/restaurant_detail.dart';
import 'package:flutter_application_1/data/model/restaurant_model.dart';
import 'package:flutter_application_1/utils/result_state.dart';


class RestauranDetailtProvider extends ChangeNotifier {
  final ApiService apiService;
  final String id;
  RestauranDetailtProvider({required this.apiService , required this.id}) {
    _fetchRestaurant(id);
  }

  late WelcomeDetail _restaurantResult;
  late ResultState _state;
  String _message = '';

  String get message => _message;

  WelcomeDetail get result => _restaurantResult;

  ResultState get state => _state;
 
  Future<dynamic> _fetchRestaurant(String id) async {
    try {
      _state = ResultState.Loading;
      notifyListeners();
      final restaurant = await apiService.detail(id);
      if (restaurant.restaurant == null) {
        _state = ResultState.NoData;
        notifyListeners();
        return _message = 'Empty Data';
      } else {
        _state = ResultState.HasData;
        notifyListeners();
        return _restaurantResult = restaurant;
      }
    } catch (e) {
      _state = ResultState.Error;
      notifyListeners();
      return _message = 'Error --> $e';
    }
  }
}