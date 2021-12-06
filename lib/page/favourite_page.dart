
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/data/model/restaurant_detail.dart';

import 'package:flutter_application_1/page/restaurant_detail.dart';
import 'package:flutter_application_1/provider/database_provider.dart';
import 'package:flutter_application_1/provider/restaurant_detail_provider.dart';
import 'package:flutter_application_1/utils/result_state.dart';
import 'package:flutter_application_1/widget/platform.dart';

import 'package:provider/provider.dart';

class FavouritePage extends StatelessWidget {
  static const String bookmarksTitle = 'Bookmarks';

  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(bookmarksTitle),
      ),
      body: _buildList(),
    );
  }

  Widget _buildIos(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(bookmarksTitle),
      ),
      child: _buildList(),
    );
  }

  Widget _buildList() {
   return Consumer<DatabaseProvider>(
      builder: (context, provider, child) {
        if (provider.state == ResultState.HasData) {
          return ListView.builder(
            itemCount: provider.bookmarks.length,
            itemBuilder: (context, index) {
              return CardRestaurant(restaurant: provider.bookmarks[index]);
            },
          );
        } else {
          return Center(
            child: Text(provider.message),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder : _buildAndroid,
      iosBuilder: _buildIos,
    );
  }
}
class CardRestaurant extends StatelessWidget {
  final RestaurantDetail restaurant;

  const CardRestaurant({required this.restaurant});

  @override
  Widget build(BuildContext context) {
    return Consumer<DatabaseProvider>(
      builder: (context, provider, child) {
        return FutureBuilder<bool>(
          future: provider.isBookmarked(restaurant.id),
          builder: (context, snapshot) {
            var isBookmarked = snapshot.data ?? false;
            return Material(
              child: ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
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
                trailing: isBookmarked
                    ? IconButton(
                        icon: Icon(Icons.favorite),
                        color: Theme.of(context).accentColor,
                        onPressed: () => provider.removeBookmark(restaurant.id),
                      )
                    : IconButton(
                        icon: Icon(Icons.favorite_border),
                        color: Theme.of(context).accentColor,
                        onPressed: () => provider.addBookmark(restaurant),
                      ),
                      onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => RestaurantDetailPage(restaurant: restaurant.id)));
                  },
              ),
            );
          },
        );
      },
    );
  }
}
