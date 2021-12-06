import 'dart:convert';
import 'dart:io';

import 'package:flutter_application_1/data/model/restaurant_detail.dart';
import 'package:flutter_application_1/data/model/restaurant_model.dart';

import 'package:http/http.dart' as http;

class ApiService {
  static final String _baseUrl = "https://restaurant-api.dicoding.dev/";

  Future<Welcome> list() async {
    var response;
    try {
      response = await http.get(Uri.parse(_baseUrl + "list"));
      switch (response.statusCode) {
        case 200:

          return Welcome.fromJson(json.decode(response.body));
        case 400:
          throw BadRequestException(response.body.toString());
        case 401:
        case 403:
          throw UnauthorisedException(response.body.toString());
        case 500:
        default:
          throw FetchDataException(
              'Error occured while Communication with Server with StatusCode: ${response.statusCode}');
      }
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
  }

  Future<WelcomeDetail> detail(String search) async {
    var response;
    try {
      response = await http.get(Uri.parse(_baseUrl + 'detail/$search'));
      switch (response.statusCode) {
        case 200:

          return WelcomeDetail.fromJson(json.decode(response.body));
        case 400:
          throw BadRequestException(response.body.toString());
        case 401:
        case 403:
          throw UnauthorisedException(response.body.toString());
        case 500:
        default:
          throw FetchDataException(
              'Error occured while Communication with Server with StatusCode: ${response.statusCode}');
      }
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
  }

 

  // dynamic _response(http.Response response) async {}
}

class CustomException implements Exception {
  final _message;
  final _prefix;

  CustomException([this._message, this._prefix]);

  String toString() {
    return "$_prefix$_message";
  }
}

class FetchDataException extends CustomException {
  FetchDataException([String? message])
      : super(message, "Error During Communication: ");
}

class BadRequestException extends CustomException {
  BadRequestException([message]) : super(message, "Invalid Request: ");
}

class UnauthorisedException extends CustomException {
  UnauthorisedException([message]) : super(message, "Unauthorised: ");
}

class InvalidInputException extends CustomException {
  InvalidInputException([String? message]) : super(message, "Invalid Input: ");
}
