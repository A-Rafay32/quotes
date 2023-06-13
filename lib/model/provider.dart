import 'package:flutter/material.dart';

import '../database.dart';
import '../utils.dart';

class Model extends ChangeNotifier {
  List<String> list = DBHelper.getQuotes().toString().split(",");
  TextEditingController Authorcontroller = TextEditingController();
  TextEditingController Quotecontroller = TextEditingController();
  Future<List<Quote>>? futureQ;
  Future<List<Collection>>? futureC;
  Future<List<Quote>>? futureFav;
  Future<List<Quote>>? futureA;
  int id = 4;

  Map<String, dynamic> map = {
    "id": "",
    "collectionId": "",
    "author": "",
    "quote": "",
  };

  void init() {
    DBHelper.openDB();
    futureC = DBHelper.getCollection();
    futureQ = DBHelper.getQuotes();
    futureFav = DBHelper.getFavQuotes();
    // notifyListeners();
  }

  Future start() async {
    var id = quotelist.length;
    await DBHelper.openDB();
    for (int i = 0; i < quotelist.length; ++i) {
      await DBHelper.insertQuote(quotelist[i]);
      // await DBHelper.addToFav(quotelist[i]);
    }
    await DBHelper.insertCollection(collectionList[0]);
    await DBHelper.insertCollection(collectionList[1]);
    await DBHelper.insertCollection(collectionList[2]);
  }

  void add() async {
    //update the  map
    map["quote"] = Quotecontroller.text.trim();
    print("map[\"quote\"]:" + map["quote"]);
    map["author"] = Authorcontroller.text.trim();
    print("map[\"author\"]:" + map["author"]);
    //clear the field
    Quotecontroller.clear();
    Authorcontroller.clear();
    //now fetch the data from map
    Quote tempQ = Quote(
        id: id + 1,
        isFav: 0,
        collectionName: "${map["author"]}",
        author: "${map["author"]}",
        quote: "${map["quote"]}");

    // add collection if new author
    if (collectionList.contains("${map["author"]}")) {
      print("already ");
    } else {
      Collection tempC = Collection(id: id + 1, name: "${map["author"]}");
      await DBHelper.insertCollection(tempC);
      collectionList.add(tempC);
      tempC.toMap().clear;
    }

    //add quote to db
    await DBHelper.insertQuote(tempQ);

    //add to quote list
    quotelist.add(tempQ);
    // clear
    tempQ.toMap().clear;

    //update futures
    futureQ = DBHelper.getQuotes();
    futureC = DBHelper.getCollection();

    // futureA = DBHelper.testRI(collection?.name ?? "");

    //increment id
    id++;
    notifyListeners();
  }

  void delCollection(Collection? collection) async {
    // delete collection
    await DBHelper.delCollection2(collection?.name ?? "");
    await DBHelper.delCollection(collection);

    //update futures
    futureQ = DBHelper.getQuotes();
    futureC = DBHelper.getCollection();
    futureFav = DBHelper.getFavQuotes();
    futureA = DBHelper.testRI(collection?.name ?? "");
    notifyListeners();
  }

  void delCollection2(String name) async {
    // delete collection
    await DBHelper.delCollection2(name);

    //update futures
    futureC = DBHelper.getCollection();
    futureQ = DBHelper.getQuotes();
    futureFav = DBHelper.getFavQuotes();
    futureA = DBHelper.testRI(name);
    notifyListeners();
  }

  void delQuote(Quote? quote) async {
    // delete collection
    await DBHelper.delQuote(quote);
    //update futures
    futureC = DBHelper.getCollection();
    futureQ = DBHelper.getQuotes();
    futureFav = DBHelper.getFavQuotes();
    futureA = DBHelper.testRI(quote?.author ?? "");
    notifyListeners();
  }

  void updateQuote(Quote quoteObj) {
    //update quote
    DBHelper.updateQuoteContent(quoteObj, Quotecontroller.text.trim());
    DBHelper.updateQuoteAuthor(quoteObj, Authorcontroller.text.trim());
    //update futures
    futureC = DBHelper.getCollection();
    futureQ = DBHelper.getQuotes();
    futureA = DBHelper.testRI(quoteObj.author);
    notifyListeners();
  }

  void switchFavourites(Quote? quote) async {
    DBHelper.db = await DBHelper.openDB();    
    await DBHelper.switchFavourites(quote ??
        Quote(id: 0, author: "", quote: "", isFav: 0, collectionName: ""));
    // await DBHelper.removeFromFav(quote ??
    //       Quote(id: 0, author: "", quote: "", isFav: 0, collectionName: ""));

    // await DBHelper.addToFav(quote ??
    //     Quote(id: 0, author: "", quote: "", isFav: 0, collectionName: ""));

    // if (quote?.isFav == 1) {
    //   await DBHelper.removeFromFav(quote ??
    //       Quote(id: 0, author: "", quote: "", isFav: 0, collectionName: ""));
    //   quote?.isFav = 0; // Update isFav flag to 0 after removing from favorites
    // } else {
    //   await DBHelper.addToFav(quote ??
    //       Quote(id: 0, author: "", quote: "", isFav: 0, collectionName: ""));
    //   quote?.isFav = 1; // Update isFav flag to 1 after adding to favorites
    // }

    notifyListeners();

    // Update futures
    futureC = DBHelper.getCollection();
    futureQ = DBHelper.getQuotes();
    futureFav = DBHelper.getFavQuotes();
  }

  void delFavQuote(Quote? quote) async {
    await DBHelper.delFavQuotes(quote ??
        Quote(id: 0, author: "", quote: "", isFav: 0, collectionName: ""));
    futureC = DBHelper.getCollection();
    futureQ = DBHelper.getQuotes();
    futureFav = DBHelper.getFavQuotes();
    futureA = DBHelper.testRI(quote?.author ?? "");
    notifyListeners();
  }
}
