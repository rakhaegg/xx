
import 'package:flutter/foundation.dart';
import 'package:flutter_application_1/data/db/database_helper.dart';
import 'package:flutter_application_1/data/model/restaurant_detail.dart';
import 'package:flutter_application_1/data/model/restaurant_model.dart';
import 'package:flutter_application_1/provider/restaurant_provider.dart';
import 'package:flutter_application_1/utils/result_state.dart';

class DatabaseProvider extends ChangeNotifier {
  final DatabaseHelper databaseHelper;

  DatabaseProvider({required this.databaseHelper}) {
    _getBookmarks();
  }

  late ResultState _state;
  ResultState get state => _state;

  String _message = '';
  String get message => _message;

  List<RestaurantDetail> _bookmarks = [];
  List<RestaurantDetail> get bookmarks => _bookmarks;

  void _getBookmarks() async {
    _bookmarks = await databaseHelper.getFavourite();
    if (_bookmarks.length > 0) {
      _state = ResultState.HasData;
    } else {
      _state = ResultState.NoData;
      _message = 'Empty Data';
    }
    notifyListeners();
  }

  void addBookmark(RestaurantDetail restaurant) async {
    try {
       print("asd");
      await databaseHelper.insertFavourite(restaurant);
     
      _getBookmarks();
    } catch (e) {
      _state = ResultState.Error;
      _message = 'Error: $e';
      notifyListeners();
    }
  }

  Future<bool> isBookmarked(String id) async {
    final bookmarkedArticle = await databaseHelper.getFavouritebyID(id);
    return bookmarkedArticle.isNotEmpty;
  }
  /*

  * * asds
  * 
  */

  void removeBookmark(String id) async {
    try {
      await databaseHelper.removeFavourite(id);
      _getBookmarks();
    } catch (e) {
      _state = ResultState.Error;
      _message = 'Error: $e';
      notifyListeners();
    }
  }
}
