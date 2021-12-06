// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

WelcomeDetail welcomeFromJson(String str) =>
    WelcomeDetail.fromJson(json.decode(str));

String welcomeToJson(WelcomeDetail data) => json.encode(data.toJson());

class WelcomeDetail {
  WelcomeDetail({
    required this.error,
    required this.message,
    required this.restaurant,
  });

  bool error;
  String message;
  RestaurantDetail restaurant;

  factory WelcomeDetail.fromJson(Map<String, dynamic> json) => WelcomeDetail(
        error: json["error"],
        message: json["message"],
        restaurant: RestaurantDetail.fromJson(json["restaurant"]),
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "message": message,
        "restaurant": restaurant.toJson(),
      };
}

class RestaurantDetail {
  RestaurantDetail({
    required this.id,
    required this.name,
    required this.description,
    required this.city,
    required this.address,
    required this.pictureId,
    required this.categories,
     required this.menus,
    required this.rating,
    required this.customerReviews,
  });

  String id;
  String name;
  String description;
  String city;
  String address;
  String pictureId;
  List<CategoryRestaurant> categories;
  Menus menus;
  String rating;
   List<CustomerReview> customerReviews;

  factory RestaurantDetail.fromJson(Map<String, dynamic> json) =>
      RestaurantDetail(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        city: json["city"],
        address: json["address"],
        pictureId: json["pictureId"],
        categories: List<CategoryRestaurant>.from(
             json["categories"].map((x) => CategoryRestaurant.fromJson(x))),
        menus: Menus.fromJson(json["menus"]),
        rating: json["rating"].toString(),
         customerReviews: List<CustomerReview>.from(
         json["customerReviews"].map((x) => CustomerReview.fromJson(x))),
      );
      
   
    
  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "city": city,
        "address": address,
        "pictureId": pictureId,
        "categories": List<dynamic>.from(categories.map((x) => x.toJson())),
         
         "menus": menus.toJson().toString(),
        "rating": rating,
         "customerReviews":
              List<dynamic>.from(customerReviews.map((x) => x.toJson())).toString(),
      };
      
}

class CategoryRestaurant {
  CategoryRestaurant({
    required this.name,
  });

  String name;

  factory CategoryRestaurant.fromJson(Map<String, dynamic> json) => CategoryRestaurant(
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
      };
}

class CustomerReview {
  CustomerReview({
    required this.name,
    required this.review,
    required this.date,
  });

  String name;
  String review;
  String date;

  factory CustomerReview.fromJson(Map<String, dynamic> json) => CustomerReview(
        name: json["name"],
        review: json["review"],
        date: json["date"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "review": review,
        "date": date,
      };
}

class Menus {
  Menus({
    required this.foods,
    required this.drinks,
  });

  List<CategoryRestaurant> foods;
  List<CategoryRestaurant> drinks;

  factory Menus.fromJson(Map<String, dynamic> json) => Menus(
        foods:
            List<CategoryRestaurant>.from(json["foods"].map((x) => CategoryRestaurant.fromJson(x))),
        drinks: List<CategoryRestaurant>.from(
            json["drinks"].map((x) => CategoryRestaurant.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "foods": List<dynamic>.from(foods.map((x) => x.toJson())),
        "drinks": List<dynamic>.from(drinks.map((x) => x.toJson())),
      };
}

