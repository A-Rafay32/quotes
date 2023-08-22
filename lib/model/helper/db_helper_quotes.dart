import 'package:quotes/model/models.dart';
import 'package:sqflite/sqflite.dart';
import "package:path/path.dart";

class DBHelperQuotes {
  static const int version = 1;
  static Database? db;
  static String? path;

  // //singleton pattern implemented here
  // // private ctor
  // static final DBHelper _dbHelper = DBHelper._internal();
  // DBHelper._internal();
  // // factory ctor , idk shit
  // factory DBHelper() {
  //   return _dbHelper;
  // }

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
        id INTEGER AUTO INCREMENT,
        name TEXT PRIMARY KEY
      )
    ''');
          database.execute('''
      CREATE TABLE quoteTable(
        id INTEGER AUTO INCREMENT,
        collectionName TEXT,
        author TEXT,
        quote TEXT PRIMARY KEY,
        isFav INTEGER,                
        UNIQUE (quote),
        FOREIGN KEY(collectionName) REFERENCES collectionTable(name)
      )
    ''');

          // UNIQUE (quote) ON CONFLICT IGNORE,

          database.execute('''
      CREATE TABLE favTable(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        favQuote TEXT,
        FOREIGN KEY(favQuote) REFERENCES quoteTable(quote)
      )
    ''');

          database.execute('''
      CREATE TABLE recentlyDel(
        id INTEGER AUTO INCREMENT,
        collectionName TEXT,
        author TEXT,
        quote TEXT PRIMARY KEY,
        isFav INTEGER                
      ) 
    ''');
          database.execute('''
      CREATE TABLE UserCollections(
        id INTEGER PRIMARY KEY AUTOINCREMENT ,
        collectionName TEXT 
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
    if (db == null) {
      await openDB();
    }
    int? id = await db?.insert(
      "quoteTable", quote.toMap(),
      // conflictAlgorithm: ConflictAlgorithm.ignore
    );
    return id;
  }

  static Future<List<Quote>> getQuotes() async {
    //fetches all the data from our table
    final List<Map<String, dynamic>>? maps = await db?.query("quoteTable");
    //arrange all the data in map to quote and return it all
    return List.generate(maps?.length ?? 0, (index) {
      return Quote(
          // id: maps?[index]["id"],
          isFav: maps?[index]["isFav"],
          collectionName: maps?[index]["collectionName"],
          author: maps?[index]["author"],
          quote: maps?[index]["quote"]);
    });
  }

  static Future<List<Quote>> getQuotesFrom(String tableName) async {
    //fetches all the data from our table
    final List<Map<String, dynamic>>? maps = await db?.query(tableName);
    //arrange all the data in map to quote and return it all
    return List.generate(maps?.length ?? 0, (index) {
      return Quote(
          // id: maps?[index]["id"],
          isFav: maps?[index]["isFav"],
          collectionName: maps?[index]["collectionName"],
          author: maps?[index]["author"],
          quote: maps?[index]["quote"]);
    });
  }

  //update
  static Future<int?> updateQuoteAuthor(Quote quote, String author) async {
    int? result = await db?.update(
        "quoteTable", {"author": author, "collectionName": author},
        where: "quote =?  ",
        whereArgs: [(quote.quote)],
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
    int? result = await db?.delete("quoteTable",
        where: "quote =?", whereArgs: ["${quote?.quote}"]);
    return result;
  }

  // static Future<void> clearDB() async {
  //   await db?.delete("quoteTable");
  //   await db?.delete("collectionTable");
  //   await db?.delete("favTable");
  // }

  // static Future testDB() async {
  //   // db = await openDB();
  //   await db?.execute("INSERT INTO collectionTable VALUES(0,'Carlos')");
  //   await db?.execute("INSERT INTO quoteTable VALUES(1,0,'Carlos', 'fuck it')");
  //   await db?.execute("INSERT INTO quoteTable VALUES(2,0,'Carlos', 'fuck it')");
  //   await db?.execute("INSERT INTO quoteTable VALUES(0,0,'Carlos', 'fuck it')");
  //   await db?.execute("INSERT INTO quoteTable VALUES(3,0,'Carlos', 'fuck it')");
  //   List<Map>? collection = await db?.rawQuery("SELECT * FROM collectionTable");
  //   List<Map>? quote = await db?.rawQuery("SELECT * FROM quoteTable");
  //   print(collection.toString());
  //   print(quote.toString());
  // }
  
}
