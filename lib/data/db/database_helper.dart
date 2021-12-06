import 'package:flutter_application_1/data/model/restaurant_detail.dart';
import 'package:flutter_application_1/data/model/restaurant_model.dart';
import 'package:http/http.dart';
import 'package:sqflite/sqflite.dart';

//Kelas dibawah untuk fitur favourite dengna database SQLite

//Helper

//Inisiasi objek DatabaseHelper dengan pola Singleton

class DatabaseHelper {
  static DatabaseHelper? _instance;
  static Database? _database;

  DatabaseHelper._internal() {
    _instance = this;
  }

  factory DatabaseHelper() => _instance ?? DatabaseHelper._internal();

  static const String _tblfavourite = 'restaurant_detail';
  static const String _category = 'category';
  static const String _customerReview = 'customer_review';
  static const String _food = 'food';
  static const String _drink = 'drink';

  //Kode dibawah untuk inisialisasi database
  Future<Database> _initializeDb() async {
    var path = await getDatabasesPath();
    var db = openDatabase(
      '$path/sial28.db',
      onCreate: (db, version) async {
        await db.execute('''CREATE TABLE $_tblfavourite (
             id TEXT PRIMARY KEY,
             name TEXT,
             description TEXT,
             city TEXT,
             rating TEXT,
             address TEXT,
             pictureId TEXT
           )     
        ''');
        await db.execute('''CREATE TABLE $_category (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                id_restaurant TEXT,
                name TEXT
              )
           ''');
        await db.execute('''CREATE TABLE $_food (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                id_restaurant TEXT,
                name TEXT
              )
           ''');
        await db.execute('''CREATE TABLE $_drink (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                id_restaurant TEXT,
                name TEXT
              )
           ''');
        await db.execute('''CREATE TABLE $_customerReview (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                id_restaurant TEXT,
                name TEXT,
                review TEXT,
                date TEXT
              )
           ''');

        //   await db.execute('''CREATE TABLE $_customerReview (
        //        id INTEGER PRIMARY KEY AUTOINCREMENT,
        //        name TEXT,
        //        review TEXT,
        //        date TEXT
        //      )
        //   ''');
        //   await db.execute('''CREATE TABLE $_menust (
        //        id INTEGER PRIMARY KEY AUTOINCREMENT,
        //        foods TEXT,
        //        drinks TEXT
        //      )
        //   ''');
      },
      version: 1,
    );

    return db;
  }

  //Kode dibawah untuk inisialisasi database
  Future<Database?> get database async {
    if (_database == null) {
      _database = await _initializeDb();
    }

    return _database;
  }

  //Kode dibawah untuk menyimpan data ke dalam database
  Future<void> insertFavourite(RestaurantDetail restaurant) async {
    final db = await database;

    var value = {
      "id": restaurant.id,
      "name": restaurant.name,
      "description": restaurant.description,
      "city": restaurant.city,
      "address": restaurant.address,
      "pictureId": restaurant.pictureId
    };

    await db!.insert(_tblfavourite, value);
    for (var i = 0; i < restaurant.categories.length; i++) {
      var categor = {
        "id_restaurant": restaurant.id,
        "name": restaurant.categories[i].name
      };

   
      await db.insert(_category, categor);
    }
    for (var i = 0; i < restaurant.customerReviews.length; i++) {
      var customerReview = {
        "id_restaurant": restaurant.id,
        "name": restaurant.customerReviews[i].name,
        "review": restaurant.customerReviews[i].review,
        "date": restaurant.customerReviews[i].date
      };
      
      await db.insert(_customerReview, customerReview);
    }

    for (var i = 0; i < restaurant.menus.foods.length; i++) {
      var food = {
        "id_restaurant": restaurant.id,
        "name": restaurant.menus.foods[i].name
      };
      await db.insert(_food, food);
     
    }

    for (var i = 0; i < restaurant.menus.drinks.length; i++) {
      var drink = {
        "id_restaurant": restaurant.id,
        "name": restaurant.menus.drinks[i].name
      };
      await db.insert(_drink, drink);
    }
  }

  //Kode dibawah untuk mengambil data dari database
  Future<List<RestaurantDetail>> getFavourite() async {
    final db = await database;
    //Perintah query untuk mengambil data

    List<Map<String, dynamic>> results = await db!.query(_tblfavourite);
    List<Map<String, dynamic>> newUser = [];
   

    for (var i = 0; i < results.length; i++) {
      final map = Map.of(results[i]);

      List<Map<String, dynamic>> cat = await db.query(
        _category,
        columns: ['name'],
        where: 'id_restaurant = ?',
        whereArgs: [map["id"]],
      );

      map["categories"] = cat;
      newUser.add(map);
      // print(newUser);
      // results[i].update("categories", (value) => getCat(results[i]["id"]));
    }

    for (var i = 0; i < newUser.length; i++) {
      List<Map<String, dynamic>> cat = await db.query(
        _customerReview,
        columns: ['name', 'review', 'date'],
        where: 'id_restaurant = ?',
        whereArgs: [newUser[i]["id"]],
      );
      newUser[i]["customerReviews"] = cat;
      // print(newUser[i]);
    }

    for (var i = 0; i < newUser.length; i++) {
      List<Map<String, dynamic>> food = await db.query(
        _food,
        columns: ['name'],
        where: 'id_restaurant = ?',
        whereArgs: [newUser[i]["id"]],
      );
      List<Map<String, dynamic>> drink = await db.query(
        _drink,
        columns: ['name'],
        where: 'id_restaurant = ?',
        whereArgs: [newUser[i]["id"]],
      );
      var map = {"foods": food, "drinks": drink};
      newUser[i]["menus"] = map;

    }

    return newUser.map((res) => RestaurantDetail.fromJson(res)).toList();
  }

  //Kode dibawah untuk mengambil data dengan kriteria
  Future<Map> getFavouritebyID(String id) async {
    final db = await database;

    List<Map<String, dynamic>> results = await db!.query(
      _tblfavourite,
      where: 'id = ?',
      whereArgs: [id],
    );
    

    if (results.isNotEmpty) {
      return results.first;
    } else {
      return {};
    }
  }

  //Kode dibawah untuk menghapus data dari database
  Future<void> removeFavourite(String id) async {
    final db = await database;

    await db!.delete(
      _tblfavourite,
      where: 'id = ?',
      whereArgs: [id],
    );
    await db.delete(
      _category,
      where: 'id_restaurant = ?',
      whereArgs: [id],

    );
    await db.delete(
      _customerReview,
      where: 'id_restaurant = ?',
      whereArgs: [id],

    );
    await db.delete(
      _customerReview,
      where: 'id_restaurant = ?',
      whereArgs: [id],

    );
    await db.delete(
      _food,
      where: 'id_restaurant = ?',
      whereArgs: [id],

    );
    await db.delete(
      _drink,
      where: 'id_restaurant = ?',
      whereArgs: [id],

    );
    
    
    
  }
}
