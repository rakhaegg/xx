import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_application_1/common/navigation.dart';
import 'package:flutter_application_1/data/model/restaurant_model.dart';
import 'package:flutter_application_1/page/restaurant_detail.dart';
import 'package:flutter_application_1/provider/database_provider.dart';
import 'package:provider/provider.dart';

class CardRestaurant extends StatelessWidget {
  final Restaurant restaurant;

  const CardRestaurant({required this.restaurant});

  @override
  Widget build(BuildContext context) {
        return  ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  leading: Hero(
                    tag: restaurant.pictureId,
                    child: Image.network(
                      "https://restaurant-api.dicoding.dev/images/small/" +
                          restaurant.pictureId,
                      width: 100,
                    ),
                  ),
                  title: Text(
                    restaurant.name,
                  ),
                  subtitle: Text(restaurant.name),
                  onTap: () {
                    Navigation.intentWithData(
                        RestaurantDetailPage.routeName, restaurant.id);
                  }

                  /*
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => RestaurantDetailPage(restaurant: restaurant.id)));
                  },
                  */
                  );
    }
}
          
