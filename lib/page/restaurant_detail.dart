import 'package:flutter/material.dart';
import 'package:flutter_application_1/common/navigation.dart';
import 'package:flutter_application_1/data/api/api_service.dart';
import 'package:flutter_application_1/data/model/restaurant_detail.dart';
import 'package:flutter_application_1/provider/database_provider.dart';
import 'package:flutter_application_1/provider/restaurant_detail_provider.dart';
import 'package:provider/provider.dart';

class RestaurantDetailPage extends StatefulWidget {
  static const routeName = '/restaurant_detail';
  final String restaurant;

  const RestaurantDetailPage({required this.restaurant});
  @override
  State<RestaurantDetailPage> createState() => _RestaurantDetailPageState();
}

class _RestaurantDetailPageState extends State<RestaurantDetailPage> {
  late Future<WelcomeDetail> _restaurantList;

  void initState() {
    // TODO: implement initState
    super.initState();
    _restaurantList = ApiService().detail(widget.restaurant);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _restaurantList,
        builder: (context, AsyncSnapshot<WelcomeDetail> snapshot) {
          var state = snapshot.connectionState;

          if (state != ConnectionState.done) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (snapshot.hasData) {
              var restaurant = snapshot.data!.restaurant;
              //  return CardRestaurant(restaurant: restaurant! , id : restaurant.id);
              return RestaurantPage(restaurant: restaurant);
            } else if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            } else {
              return Text('');
            }
          }
        });
  }
}

class RestaurantPage extends StatefulWidget {
  final RestaurantDetail restaurant;
  const RestaurantPage({required this.restaurant});

  @override
  State<RestaurantPage> createState() => _RestaurantPageState();
}

class _RestaurantPageState extends State<RestaurantPage> {
  late List<dynamic> category;
  late List<dynamic> foods;
  late List<dynamic> drinks;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    category = widget.restaurant.categories;
    foods = widget.restaurant.menus.foods;
    drinks = widget.restaurant.menus.drinks;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Consumer<DatabaseProvider>(
      builder: (context, provider, child) {
        return FutureBuilder<bool>(
          future: provider.isBookmarked(widget.restaurant.id),
          builder: (context, snapshot) {
            var isBookmarked = snapshot.data ?? false;
            return Scaffold(
              appBar: AppBar(
                title: Text(widget.restaurant.name),
              ),
              body: Padding(
                padding: const EdgeInsets.all(5.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Hero(
                        tag: widget.restaurant.pictureId,
                        child: Image.network(
                            "https://restaurant-api.dicoding.dev/images/small/" +
                                widget.restaurant.pictureId),
                      ),
                      isBookmarked
                          ? IconButton(
                              icon: Icon(Icons.favorite),
                              color: Theme.of(context).accentColor,
                              onPressed: () =>
                                  provider.removeBookmark(widget.restaurant.id),
                            )
                          : IconButton(
                              icon: Icon(Icons.favorite_border),
                              color: Theme.of(context).accentColor,
                              onPressed: () =>
                                  provider.addBookmark(widget.restaurant),
                            ),
                      Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Text(widget.restaurant.name),
                            Divider(
                              color: Colors.grey,
                            ),
                            Text(widget.restaurant.description),
                            Divider(
                              color: Colors.grey,
                            ),
                            Text(widget.restaurant.city),
                            Divider(
                              color: Colors.grey,
                            ),
                            Text(widget.restaurant.rating.toString()),
                            Divider(
                              color: Colors.grey,
                            ),
                            ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: category.length,
                                itemBuilder: (context, index) {
                                  return Builder(
                                    builder: (context) {
                                      return ListTile(
                                        title: Text(category[index].name),
                                      );
                                    },
                                  );
                                }),
                            Divider(
                              color: Colors.grey,
                            ),
                            ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: foods.length,
                                itemBuilder: (context, index) {
                                  return Builder(
                                    builder: (context) {
                                      return ListTile(
                                        title: Text(foods[index].name),
                                      );
                                    },
                                  );
                                }),
                            Divider(
                              color: Colors.grey,
                            ),
                            ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: foods.length,
                                itemBuilder: (context, index) {
                                  return Builder(
                                    builder: (context) {
                                      return ListTile(
                                        title: Text(drinks[index].name),
                                      );
                                    },
                                  );
                                }),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
  /*
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.restaurant.name)),
      body: Padding(
        padding: EdgeInsets.all(5),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Hero(
                tag: widget.restaurant.pictureId,
                child: Image.network(
                    "https://restaurant-api.dicoding.dev/images/small/" +
                        widget.restaurant.pictureId),
              ),
              Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                     isBookmarked
                      ? IconButton(
                          icon: Icon(Icons.favorite),
                          color: Theme.of(context).accentColor,
                          onPressed: () =>
                              provider.removeBookmark(restaurant.id),
                        )
                      : IconButton(
                          icon: Icon(Icons.favorite_border),
                          color: Theme.of(context).accentColor,
                      ),
                    Divider(
                      color: Colors.grey,
                    ),
                    Text(widget.restaurant.name),
                    Divider(
                      color: Colors.grey,
                    ),
                    Text(widget.restaurant.description),
                    Divider(
                      color: Colors.grey,
                    ),
                    Text(widget.restaurant.city),
                    Divider(
                      color: Colors.grey,
                    ),
                    Text(widget.restaurant.rating.toString()),
                    Divider(
                      color: Colors.grey,
                    ),
                    ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: category.length,
                        itemBuilder: (context, index) {
                          return Builder(
                            builder: (context) {
                              return ListTile(
                                title: Text(category[index].name),
                              );
                            },
                          );
                        }),
                    Divider(
                      color: Colors.grey,
                    ),
                    ListView.builder(
                       physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                      itemCount: foods.length,
                      itemBuilder: (context , index){
                         return Builder(
                            builder: (context) {
                              return ListTile(
                                title: Text(foods[index].name),
                              );
                            },
                          );
                      }
                      ),
                       Divider(
                      color: Colors.grey,
                    ),
                    ListView.builder(
                       physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                      itemCount: drinks.length,
                      itemBuilder: (context , index){
                         return Builder(
                            builder: (context) {
                              return ListTile(
                                title: Text(drinks[index].name),
                              );
                            },
                          );
                      }
                      ),

                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
  */
}
