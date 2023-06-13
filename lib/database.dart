import 'package:quotes/utils.dart';
import 'package:sqflite/sqflite.dart';
import "package:path/path.dart";

class DBHelper {
  static const int version = 1;
  static Database? db;
  static String? path;

  //singleton pattern implemented here
  // private ctor
  static final DBHelper _dbHelper = DBHelper._internal();
  DBHelper._internal();
  // factory ctor , idk shit
  factory DBHelper() {
    return _dbHelper;
  }

  static Future<Database?> openDB() async {
    // if databse is not previously initialized
    if (db == null) {
      var databasepath = await getDatabasesPath();
      path = join(databasepath, "quote.db");

      db = await openDatabase(
        path.toString(),
        onCreate: (database, version) {
          database.execute('''
      CREATE TABLE collectionTable(
        id INTEGER ,
        name TEXT PRIMARY KEY
      )
    ''');
          database.execute('''
      CREATE TABLE quoteTable(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        collectionName TEXT,
        author TEXT,
        quote TEXT,
        isFav INTEGER,
        FOREIGN KEY(collectionName) REFERENCES collectionTable(name)
      )
    ''');
          database.execute('''
      CREATE TABLE favTable(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        quoteID INTEGER,
        FOREIGN KEY(quoteID) REFERENCES quoteTable(id)
      )
    ''');
        },
        version: version,
      );
    }
    return db;
  }

//***********************************************************************/
//***********************[ALL quoteTable Functions]******************/
  static Future<int?> insertQuote(Quote quote) async {
    int? id = await db?.insert("quoteTable", quote.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return id;
  }

  static Future<List<Quote>> getQuotes() async {
    //fetches all the data from our table
    final List<Map<String, dynamic>>? maps = await db?.query("quoteTable");
    //arrange all the data in map to quote and return it all
    return List.generate(maps?.length ?? 0, (index) {
      return Quote(
          id: maps?[index]["id"],
          isFav: maps?[index]["isFav"],
          collectionName: maps?[index]["collectionName"],
          author: maps?[index]["author"],
          quote: maps?[index]["quote"]);
    });
  }

  //update
  static Future<int?> updateQuoteAuthor(Quote quote, String author) async {
    int? result = await db?.update("quoteTable", {"author": author},
        where: "author =?  ",
        whereArgs: [(quote.author)],
        conflictAlgorithm: ConflictAlgorithm.replace);
    return result;
  }

  static Future<int?> updateQuoteContent(Quote quote, String Newquote) async {
    int? result = await db?.update("quoteTable", {"quote": Newquote},
        where: "quote =?  ", whereArgs: [(quote.quote)]);
    return result;
  }

  //delete
  static Future<int?> delQuote(Quote? quote) async {
    int? result = await db
        ?.delete("quoteTable", where: "id =?", whereArgs: ["${quote?.id}"]);
    return result;
  }

//******************************************************************************* */
//***************************[All collectionTable Functions]*******************/
  static Future<int?> insertCollection(Collection collection) async {
    int? id = await db?.insert("collectionTable", collection.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return id;
  }

  //read
  static Future<List<Collection>> getCollection() async {
    //fetches all the data from our table
    final List<Map<String, dynamic>>? maps = await db?.query("collectionTable");
    //arrange all the data in map to quote and return it all
    return List.generate(maps?.length ?? 0, (index) {
      return Collection(
        id: maps?[index]["id"],
        name: maps?[index]["name"],
      );
    });
  }

  static Future<int?> delCollection(Collection? collection) async {
    int? result = await db?.delete("collectionTable",
        where: "id =?", whereArgs: ["${collection?.id}"]);
    return result;
  }

  static Future<int?> delCollection2(String name) async {
    db = await openDB();
    int? result =
        await db?.delete("quoteTable", where: "author =?", whereArgs: [name]);
    return result;
  }

  static Future<void> clearDB() async {
    await db?.delete("quoteTable");
    await db?.delete("collectionTable");
    await db?.delete("favTable");
  }

  static Future testDB() async {
    db = await openDB();
    await db?.execute("INSERT INTO collectionTable VALUES(0,'Carlos')");
    await db?.execute("INSERT INTO quoteTable VALUES(1,0,'Carlos', 'fuck it')");
    await db?.execute("INSERT INTO quoteTable VALUES(2,0,'Carlos', 'fuck it')");
    await db?.execute("INSERT INTO quoteTable VALUES(0,0,'Carlos', 'fuck it')");
    await db?.execute("INSERT INTO quoteTable VALUES(3,0,'Carlos', 'fuck it')");
    List<Map>? collection = await db?.rawQuery("SELECT * FROM collectionTable");
    List<Map>? quote = await db?.rawQuery("SELECT * FROM quoteTable");
    print(collection.toString());
    print(quote.toString());
  }

  // RI :  referrential integrity
  //fetch all quotes having the same name
  static Future<List<Quote>> testRI(String name) async {
    db = await openDB();
    List<Map>? result = await db?.rawQuery("""
        SELECT *
        FROM quoteTable
        JOIN collectionTable ON quoteTable.collectionName = collectionTable.name
        WHERE collectionTable.name = '$name'
    """);
    return List.generate(
        result?.length ?? 0,
        (index) => Quote(
            id: result?[index]["id"],
            author: result?[index]["author"],
            quote: result?[index]["quote"],
            isFav: result?[index]["isFav"],
            collectionName: result?[index]["collectionName"]));
  }

//****************************************************************************** */
//***************************[All favTable Functions]*****************************/
//****************************************************************************** */

  static Future<int?> updateisFav(Quote quote, int isFav) async {
    db = await openDB();
    int? result = await db?.update(
      "quoteTable",
      {"isFav": isFav},
      where: "id = ?", 
      whereArgs: [quote.id],
    );
    return result;
  }

  static Future addToFav(Quote quote) async {
    db = await openDB();
    int? result = await db?.rawInsert(
      "INSERT INTO favTable(quoteID) VALUES(${quote.id})",
    );
    quote.isFav = 1;
    updateisFav(quote, 1);
    print("added to favorites");
  }

  static Future removeFromFav(Quote quote) async {
    db = await openDB();
    int? result =
        await db?.rawDelete("DELETE FROM favTable WHERE quoteID=?", [quote.id]);
    quote.isFav = 0;
    updateisFav(quote, 0);
    print("removed from favorites");
    print("quote.isFav:${quote.isFav}");
  }

  static Future switchFavourites(Quote quote) async {
    db = await openDB();
    if (quote.isFav == 1) {
      await removeFromFav(quote);
      print("removed from favorites");
    } else {
      await addToFav(quote);
      print("added to favorites");
    }
    print("quote.isFav:${quote.isFav}");
    print(await db?.rawQuery("SELECT * FROM quoteTable"));
  }

  static Future<List<Quote>> getFavQuotes() async {
    db = await openDB();
    //fetches all the data from favTable
    final List<Map<String, dynamic>>? maps = await db?.rawQuery("""
        SELECT * FROM quoteTable 
        JOIN favTable ON quoteTable.id = favTable.quoteID
        WHERE quoteTable.id = favTable.quoteID""");
    print(maps?.length);
    //arrange all the data in map to quote and return it all
    return List.generate(maps?.length ?? 0, (index) {
      return Quote(
          id: maps?[index]["id"],
          isFav: maps?[index]["isFav"],
          collectionName: maps?[index]["collectionName"],
          author: maps?[index]["author"],
          quote: maps?[index]["quote"]);
    });
  }

  static Future delFavQuotes(Quote quote) async {
    db = await openDB();
    int? result = await db?.rawDelete("""
        DELETE FROM quoteTable
        WHERE id IN (
        SELECT quoteID
        FROM favTable
        WHERE quoteID = ?
        )
        """, ["${quote.id}"]);
  }
}
