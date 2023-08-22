import 'package:sqflite/sqflite.dart';

import '../models.dart';
import 'db_helper_quotes.dart';

class DBUserCollection {
  static Database? db = DBHelperQuotes.db;

  static Future<List<UserCollection>> getUserCollection() async {
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
                        collectionName TEXT,
                        author TEXT,
                        quote TEXT PRIMARY KEY,
                        isFav INTEGER,                  
                        UNIQUE (quote),
                        FOREIGN KEY(collectionName) REFERENCES collectionTable(name)
                      )""");
  }
}
