import 'package:sqflite/sqflite.dart';

import '../models.dart';
import 'db_quotes.dart';

class DBUserCollection {
  static Database? db = DBQuotes.db;

  static Future<List<UserCollection>> getUserCollections() async {
    List<Map<String, dynamic>> data = await db!.query("UserCollections");
    return List.generate(
        data.length,
        (index) => UserCollection(
              collectionName: data[index]["collectionName"],
              id: 0,
            ));
  }

  static Future<int> addUserCollection(String collectionName) async {
    int result =
        await db!.insert("UserCollections", {"collectionName": collectionName});
    return result;
  }

  static void createTable(String tableName) {
    db!.execute("""CREATE TABLE $tableName (
                        id INTEGER AUTO INCREMENT,
                        UserCollectionName TEXT,
                        author TEXT,
                        quote TEXT PRIMARY KEY,
                        isFav INTEGER,                  
                        FOREIGN KEY(UserCollectionName) REFERENCES UserCollections(collectionName)
                      )""");
  }

  static Future<List<Quote>> getUserCollection(String collectionName) async {
    List<Map<String, dynamic>> result = await db!.rawQuery("""
      SELECT * FROM $collectionName 
      
""");
// JOIN UserCollections ON $collectionName.UserCollectionName = UserCollections.collectionName
    // print(result);
    return List.generate(
        result.length ?? 0,
        (index) => Quote(
            // id: result?[index]["id"],
            author: result[index]["author"],
            quote: result[index]["quote"],
            isFav: result[index]["isFav"],
            collectionName: ""));
  }

  static Future<int> addQuoteToUserCollection(
      String collectionName, Quote quote) async {
    int result = await db!.database.insert(collectionName,
        {"author": quote.author, "quote": quote.quote, "isFav": quote.isFav});
    return result;
  }

  static Future<int> updateUserCollectionQuote(
    collectionName,
    String newQuote,
    String oldQuote,
    String newAuthor,
  ) async {
    int result = await db!.database.update(
        collectionName, {"quote": newQuote, "author": newAuthor},
        where: "quote=?",
        whereArgs: [(oldQuote)],
        conflictAlgorithm: ConflictAlgorithm.replace);
    return result;
  }

  static Future<int> delUserCollectionQuote(
    collectionName,
    String quote,
  ) async {
    int result = await db!.database
        .delete(collectionName, where: "quote=?", whereArgs: [quote]);

    return result;
  }

  static Future<List<Quote>> getFavQuotesUserCollection(
      String collectionName) async {
    //fetches all the data from favTable
    final List<Map<String, dynamic>>? maps = await db?.rawQuery("""
        SELECT * FROM $collectionName 
        WHERE isFav = 1""");

    print(maps);
    //arrange all the data in map to quote and return it all
    return List.generate(maps?.length ?? 0, (index) {
      return Quote(
          // id: maps?[index]["quoteID"],
          isFav: maps?[index]["isFav"],
          collectionName: "",
          author: maps?[index]["author"],
          quote: maps?[index]["quote"]);
    });
  }

  static void addToFavUserCollection(String collectionName, Quote quote) async {
    await db?.update(collectionName, {"isFav": 1},
        where: "quote=?", whereArgs: [quote.quote]);

    print('Added to favorites');
    return null;
  }

  static void removeFavUserCollection(
      String collectionName, Quote quote) async {
    await db?.update(collectionName, {"isFav": 0},
        where: "quote=?", whereArgs: [quote.quote]);
  }

  static Future switchFavUserCollection(
      String collectionName, Quote quote) async {
    // db = await openDB();
    if (quote.isFav == 1) {
      removeFavUserCollection(collectionName, quote);
      print("removed from favorites");
    } else {
      addToFavUserCollection(collectionName, quote);
      print("added to favorites");
    }
  }

  static Future delUserCollection(collectionName) async {
    await db?.delete(collectionName);
    await db?.delete("UserCollections",
        where: "collectionName=?", whereArgs: [collectionName]);
  }
}
