import 'package:sqflite/sqflite.dart';

import '../models.dart';
import 'db_helper_quotes.dart';

class DBHelperFav {
  static Database? db = DBHelperQuotes.db;

  //****************************************************************************** */
//***************************[All favTable Functions]*****************************/
//****************************************************************************** */

  static Future<int?> updateisFav(Quote quote, int isFav) async {
    // db = await openDB();
    int? result = await db?.update(
      "quoteTable",
      {"isFav": isFav},
      where: "quote = ?",
      whereArgs: [quote.quote],
    );
    return result;
  }

  static Future addToFav(Quote quote) async {
    // db = await openDB();
    int? result = await db?.rawInsert(
      'INSERT INTO favTable(favQuote) VALUES(?)',
      [quote.quote],
    );
    quote.isFav = 1;
    updateisFav(quote, 1);
    print('Added to favorites');
    return result;
  }

  static Future removeFromFav(Quote quote) async {
    // db = await openDB();
    int? result = await db
        ?.delete("favTable", where: " favQuote = ? ", whereArgs: [quote.quote]);
    quote.isFav = 0;
    updateisFav(quote, 0);
    print("removed from favorites");
    print("quote.isFav:${quote.isFav}");
    return result;
  }

  static Future switchFavourites(Quote quote) async {
    // db = await openDB();
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
    // db = await openDB();
    //fetches all the data from favTable
    final List<Map<String, dynamic>>? maps = await db?.rawQuery("""
        SELECT * FROM quoteTable
        JOIN favTable ON quoteTable.quote = favTable.favQuote
        WHERE quoteTable.quote = favTable.favQuote""");
    print(maps?.length);
    // print(maps);
    //arrange all the data in map to quote and return it all
    return List.generate(maps?.length ?? 0, (index) {
      return Quote(
          // id: maps?[index]["quoteID"],
          isFav: maps?[index]["isFav"],
          collectionName: maps?[index]["collectionName"],
          author: maps?[index]["author"],
          quote: maps?[index]["quote"]);
    });
  }

  static Future delFavQuotes(Quote quote) async {
    int? result = await db?.rawDelete("""
        DELETE FROM quoteTable
        WHERE quote IN (
        SELECT favQuote
        FROM favTable
        WHERE favQuote= ?
        )
        """, [(quote.quote)]);
    return result;
  }
}
