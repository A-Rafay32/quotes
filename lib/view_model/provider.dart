import 'package:flutter/material.dart';

import '../model/data/db_author_collection.dart';
import '../model/data/db_fav.dart';
import '../model/data/db_quotes.dart';
import '../model/data/db_user_collection.dart';
import '../model/models.dart';

class Model extends ChangeNotifier {
  TextEditingController authorController = TextEditingController();
  TextEditingController quoteController = TextEditingController();
  Future<List<Quote>>? futureFav;
  Future<List<Quote>>? futureQ;
  Future<List<Quote>>? futureDel;
  Future<List<Quote>>? futureA;
  Future<List<AuthorCollection>>? futureC;
  Future<List<UserCollection>>? futureUC;
  Future<List<Quote>>? futureUserAlbum;
  List<Map<String, dynamic>>? favQuotesMap;

  bool isSelected = false;
  Color borderColor = Colors.white70;
  double borderWidth = 1;

  int id = 0;

  Map<String, dynamic> map = {
    "id": "",
    "collectionId": "",
    "author": "",
    "quote": "",
  };

  void init() async {
    DBQuotes.openDB();
    futureC = DBAuthorCollection.getAuthorCollection();
    futureQ = DBQuotes.getQuotes();
    favQuotesMap = await DBFavorites.getFavQuotes();
    notifyListeners();
  }

  void setId() async {
    List<Quote> data = await DBQuotes.getQuotes();
    id = data.length;
    print("id : $id");
  }

  Future start() async {
    var id = quotelist.length;
    await DBQuotes.openDB();
    for (int i = 0; i < quotelist.length; ++i) {
      await DBQuotes.insertQuote(quotelist[i]);
      // await DBHelper.addToFav(quotelist[i]);
    }

    await DBAuthorCollection.insertAuthorCollection(collectionList[0]);
    await DBAuthorCollection.insertAuthorCollection(collectionList[1]);
    await DBAuthorCollection.insertAuthorCollection(collectionList[2]);
  }

  void addQuote() async {
    //update the  map
    map["quote"] = quoteController.text.trim();
    print("map[\"quote\"]:" + map["quote"]);
    map["author"] = authorController.text.trim();
    print("map[\"author\"]:" + map["author"]);
    //clear the field
    quoteController.clear();
    authorController.clear();
    //now fetch the data from map
    Quote tempQ = Quote(
        // id: id + 1,
        isFav: 0,
        collectionName: "${map["author"]}",
        author: "${map["author"]}",
        quote: "${map["quote"]}");

    // add collection if new author
    if (collectionList.contains("${map["author"]}")) {
      print("already ");
    } else {
      AuthorCollection tempC =
          AuthorCollection(id: id + 1, name: "${map["author"]}");
      await DBAuthorCollection.insertAuthorCollection(tempC);
      collectionList.add(tempC);
      tempC.toMap().clear;
    }

    //add quote to db
    int? result = await DBQuotes.insertQuote(tempQ);
    print("addition status : $result");

    //add to quote list
    quotelist.add(tempQ);
    // clear
    tempQ.toMap().clear;

    //update futures
    futureQ = DBQuotes.getQuotes();
    futureC = DBAuthorCollection.getAuthorCollection();

    // futureA = DBHelper.testRI(collection?.name ?? "");

    //increment id
    id++;
    setId();
    notifyListeners();
  }

  // void delQuotesOfCollection2(Quote quote) async {
  //   // delete collection
  //   await DBHelper.delQuote(quote);
  //   // check if no quote exist in a collection
  //   List<Quote> data = await DBHelper.testRI(quote.author);
  //   print("data : $data ");
  //   if (data.isEmpty) {
  //     // then delete the collection
  //     // await DBHelper.delCollection(collection)
  //     await DBHelper.delCollection(quote.author);
  //   }
  //   // delete collection

  //   //update futures
  //   futureC = DBHelper.getCollection();
  //   futureQ = DBHelper.getQuotes();
  //   futureFav = DBHelper.getFavQuotes();
  //   futureA = DBHelper.testRI(quote.author);
  //   //update Id
  //   setId();
  //   notifyListeners();
  // }

  void delQuote(Quote? quote) async {
    // delete collection
    await DBQuotes.delQuote(quote);
    // check if no quote exist in a collection
    List<Quote> data =
        await DBAuthorCollection.getQuotesOfAuthor(quote?.author ?? "");
    print("data : $data ");
    if (data.isEmpty) {
      // then delete the collection
      // await DBHelper.delCollection(collection)
      await DBAuthorCollection.delAuthorCollection(quote?.author ?? "");
    }
    //update futures
    futureC = DBAuthorCollection.getAuthorCollection();
    futureQ = DBQuotes.getQuotes();
    favQuotesMap = await DBFavorites.getFavQuotes();
    futureA = DBAuthorCollection.getQuotesOfAuthor(quote?.author ?? "");
    //update Id
    setId();
    notifyListeners();
  }

  void updateQuote(Quote quoteObj) async {
    //update quote
    DBQuotes.updateQuoteContent(quoteObj, quoteController.text.trim());
    DBQuotes.updateQuoteAuthor(quoteObj, authorController.text.trim());
    DBAuthorCollection.updateAuthorName(quoteObj, authorController.text.trim());

    //update futures
    futureC = DBAuthorCollection.getAuthorCollection();
    // print(await DBHelper.db?.query("collectionTable"));
    favQuotesMap = await DBFavorites.getFavQuotes();
    futureQ = DBQuotes.getQuotes();
    // print(await futureC);
    futureA =
        DBAuthorCollection.getQuotesOfAuthor(authorController.text.trim());
    // print(await DBHelper.db?.query("quoteTable"));
    notifyListeners();
  }

  void switchFavourites(Quote? quote) async {
    await DBFavorites.switchFavourites(quote ??
        Quote(
            // id: 0,
            author: "",
            quote: "",
            isFav: 0,
            collectionName: ""));

    notifyListeners();
    // Update futures
    futureC = DBAuthorCollection.getAuthorCollection();
    futureQ = DBQuotes.getQuotes();
    favQuotesMap = await DBFavorites.getFavQuotes();
  }

  void delCollection(AuthorCollection? collection) async {
    // delete collection
    await DBAuthorCollection.delQuotesOfCollection(collection?.name ?? "");
    await DBAuthorCollection.delAuthorCollection(collection?.name ?? "");

    //update futures
    futureQ = DBQuotes.getQuotes();
    futureC = DBAuthorCollection.getAuthorCollection();
    favQuotesMap = await DBFavorites.getFavQuotes();
    futureA = DBAuthorCollection.getQuotesOfAuthor(collection?.name ?? "");

    notifyListeners();
  }

  void delFavQuote(Quote? quote) async {
    //del FavQuotes
    await DBFavorites.delFavQuotes(quote ??
        Quote(
            // id: 0,
            author: "",
            quote: "",
            isFav: 0,
            collectionName: ""));

    // check if no quote exist in a collection
    List<Quote> data =
        await DBAuthorCollection.getQuotesOfAuthor(quote?.author ?? "");
    print("data : $data ");
    if (data.isEmpty) {
      // then delete the collection
      // await DBHelper.delCollection(collection)
      await DBAuthorCollection.delAuthorCollection(quote?.author ?? "");
    }

    //update futures
    futureC = DBAuthorCollection.getAuthorCollection();
    futureQ = DBQuotes.getQuotes();
    favQuotesMap = await DBFavorites.getFavQuotes();
    futureA = DBAuthorCollection.getQuotesOfAuthor(quote?.author ?? "");

    notifyListeners();
  }

  void delAuthorCollection(String authorName) {
    DBAuthorCollection.delAuthorCollection(authorName);
    notifyListeners();
  }

  void addUserCollection(String collectionName) async {
    DBUserCollection.addUserCollection(collectionName);
    futureUC = DBUserCollection.getUserCollections();
    notifyListeners();
  }

  void delRecentDelTable() async {
    await DBQuotes.db?.delete("recentlyDel");
    futureDel = DBQuotes.getQuotesFrom("recentlyDel");
    notifyListeners();
  }

  void delRecentDelQuote(String quote) async {
    await DBQuotes.db
        ?.delete("recentlyDel", where: "quote=?", whereArgs: [quote]);
    futureDel = DBQuotes.getQuotesFrom("recentlyDel");
    notifyListeners();
  }

  void unSelectAlbum() {
    isSelected = !isSelected;
    notifyListeners();
  }

  void addQuoteToUserCollection(String collectionName, Quote quote) async {
    await DBUserCollection.addQuoteToUserCollection(collectionName, quote);
    futureUserAlbum = DBUserCollection.getUserCollection(collectionName);
    notifyListeners();
  }

  void updateUserCollectionQuote({
    required String collectionName,
    required String newQuote,
    required String oldQuote,
    required String newAuthor,
  }) async {
    await DBUserCollection.updateUserCollectionQuote(
        collectionName, newQuote, oldQuote, newAuthor);
    futureUserAlbum = DBUserCollection.getUserCollection(collectionName);
    notifyListeners();
  }

  void delUserCollectionQuote(String collectionName, String quote) async {
    await DBUserCollection.delUserCollectionQuote(collectionName, quote);
    futureUserAlbum = DBUserCollection.getUserCollection(collectionName);
    notifyListeners();
  }

  void switchFavUserCollection(String collectionName, Quote quote) async {
    await DBUserCollection.switchFavUserCollection(collectionName, quote);
    // futureFav = DBUse  rCollection.getFavQuotesUserCollection();
    futureUserAlbum = DBUserCollection.getUserCollection(collectionName);
    notifyListeners();
  }
}
