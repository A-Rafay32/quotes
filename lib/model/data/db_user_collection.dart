import 'package:sqflite/sqflite.dart';

import '../models.dart';
import 'db_quotes.dart';

class DBUserCollection {
  static Database? db = DBQuotes.db;

  static Future<List<UserCollection>> getUserCollections() async {
    // db = await openDB();
    List<Map<String, dynamic>> data = await db!.query("UserCollections");
    return List.generate(
        data.length,
        (index) => UserCollection(
              collectionName: data[index]["collectionName"],
              id: data[index]["id"],
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
      JOIN UserCollections ON $collectionName.UserCollectionName = UserCollections.collectionName 
""");
    print(result);
    return List.generate(
        result.length ?? 0,
        (index) => Quote(
            // id: result?[index]["id"],
            author: result[index]["author"],
            quote: result[index]["quote"],
            isFav: result[index]["isFav"],
            collectionName: result[index]["collectionName"]));
  }

  static Future<int> addQuoteToUserCollection(
      String collectionName, Quote quote) async {
    int result = await db!.database.insert(collectionName,
        {"author": quote.author, "quote": quote.quote, "isFav": quote.isFav});
    return result;
  }
}
