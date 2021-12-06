import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_application_1/data/api/api_service.dart';
import 'package:flutter_application_1/data/model/restaurant_model.dart';
import 'package:flutter_application_1/utils/result_state.dart';


class RestaurantProvider extends ChangeNotifier {
  final ApiService apiService;

  RestaurantProvider({required this.apiService}) {
    _fetchRestaurant();
  }

  late Welcome _restaurantResult;
  late ResultState _state;

  ResultState get state => _state;

  set state(ResultState state) {
    _state = state;
  }
  String _message = '';

  String get message => _message;

  Welcome get result => _restaurantResult;


 
  Future<dynamic> _fetchRestaurant() async {
    try {
      _state = ResultState.Loading;
      notifyListeners();
      final restaurant = await apiService.list();
      if (restaurant.restaurants.isEmpty) {
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