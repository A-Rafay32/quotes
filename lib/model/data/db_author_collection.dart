import 'package:sqflite/sqflite.dart';

import '../models.dart';
import 'db_quotes.dart';

class DBAuthorCollection {
  static Database? db = DBQuotes.db;

  //******************************************************************************* */
//***************************[All collectionTable Functions]*******************/
  static Future<int?> insertAuthorCollection(
      AuthorCollection collection) async {
    int? id = await db?.insert("collectionTable", collection.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return id;
  }

  //read
  static Future<List<AuthorCollection>> getAuthorCollection() async {
    //fetches all the data from our table
    final List<Map<String, dynamic>>? maps = await db?.query("collectionTable");

    //arrange all the data in map to quote and return it all
    return List.generate(maps?.length ?? 0, (index) {
      return AuthorCollection(
        id: maps?[index]["id"],
        name: maps?[index]["name"],
      );
    });
  }

  static Future<int?> delAuthorCollection(String name) async {
    int? result = await db
        ?.delete("collectionTable", where: "name =?", whereArgs: [name]);
    return result;
  }

  static Future<int?> delQuotesOfCollection(String name) async {
    int? result =
        await db?.delete("quoteTable", where: "author =?", whereArgs: [name]);
    return result;
  }

  static Future<int?> updateAuthorName(Quote quote, String updatedName) async {
    int? result = await db?.update("collectionTable", {"name ": updatedName},
        where: "name = ? ", whereArgs: [quote.author]);

    return result;
  }

  // RI :  referrential integrity
  //fetch all quotes having the same name
  static Future<List<Quote>> getQuotesOfAuthor(String authorName) async {
    // db = await openDB();
    List<Map>? result = await db?.rawQuery("""
        SELECT *
        FROM quoteTable
        JOIN collectionTable ON quoteTable.collectionName = collectionTable.name
        WHERE collectionTable.name = '$authorName'
    """);
    print(result);
    return List.generate(
        result?.length ?? 0,
        (index) => Quote(
            // id: result?[index]["id"],
            author: result?[index]["author"],
            quote: result?[index]["quote"],
            isFav: result?[index]["isFav"],
            collectionName: result?[index]["collectionName"]));
  }
}
