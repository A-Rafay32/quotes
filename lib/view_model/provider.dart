import 'package:flutter/material.dart';

import '../model/helper/db_author_collection.dart';
import '../model/helper/db_helper_fav.dart';
import '../model/helper/db_helper_quotes.dart';
import '../model/helper/db_user_collection.dart';
import '../model/models.dart';

class Model extends ChangeNotifier {
  TextEditingController Authorcontroller = TextEditingController();
  TextEditingController Quotecontroller = TextEditingController();
  Future<List<Quote>>? futureFav;
  Future<List<Quote>>? futureQ;
  Future<List<Quote>>? futureDel;
  Future<List<Quote>>? futureA;
  Future<List<AuthorCollection>>? futureC;

  int id = 0;

  Map<String, dynamic> map = {
    "id": "",
    "collectionId": "",
    "author": "",
    "quote": "",
  };

  void init() async {
    DBHelperQuotes.openDB();
    futureC = DBAuthorCollection.getAuthorCollection();
    futureQ = DBHelperQuotes.getQuotes();
    futureFav = DBHelperFav.getFavQuotes();

    // print(await DBHelper.db?.query('quoteTable'));
    // print(await DBHelper.db?.query('favTable'));
    // print(await DBHelper.db?.query('collectionTable'));
    notifyListeners();
  }

  void setId() async {
    List<Quote> data = await DBHelperQuotes.getQuotes();
    id = data.length;
    print("id : $id");
  }

  Future start() async {
    var id = quotelist.length;
    await DBHelperQuotes.openDB();
    for (int i = 0; i < quotelist.length; ++i) {
      await DBHelperQuotes.insertQuote(quotelist[i]);
      // await DBHelper.addToFav(quotelist[i]);
    }

    await DBAuthorCollection.insertAuthorCollection(collectionList[0]);
    await DBAuthorCollection.insertAuthorCollection(collectionList[1]);
    await DBAuthorCollection.insertAuthorCollection(collectionList[2]);
  }

  void addQuote() async {
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
    await DBHelperQuotes.insertQuote(tempQ);

    //add to quote list
    quotelist.add(tempQ);
    // clear
    tempQ.toMap().clear;

    //update futures
    futureQ = DBHelperQuotes.getQuotes();
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
    await DBHelperQuotes.delQuote(quote);
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
    futureQ = DBHelperQuotes.getQuotes();
    futureFav = DBHelperFav.getFavQuotes();
    futureA = DBAuthorCollection.getQuotesOfAuthor(quote?.author ?? "");
    //update Id
    setId();
    notifyListeners();
  }

  void updateQuote(Quote quoteObj) async {
    //update quote
    DBHelperQuotes.updateQuoteContent(quoteObj, Quotecontroller.text.trim());
    DBHelperQuotes.updateQuoteAuthor(quoteObj, Authorcontroller.text.trim());
    DBAuthorCollection.updateAuthorName(quoteObj, Authorcontroller.text.trim());

    //update futures
    futureC = DBAuthorCollection.getAuthorCollection();
    // print(await DBHelper.db?.query("collectionTable"));

    futureQ = DBHelperQuotes.getQuotes();
    // print(await futureC);
    futureA =
        DBAuthorCollection.getQuotesOfAuthor(Authorcontroller.text.trim());
    // print(await DBHelper.db?.query("quoteTable"));
    notifyListeners();
  }

  void switchFavourites(Quote? quote) async {
    await DBHelperFav.switchFavourites(quote ??
        Quote(
            // id: 0,
            author: "",
            quote: "",
            isFav: 0,
            collectionName: ""));
    // await DBHelper.removeFromFav(quote ??
    //       Quote(id: 0, author: "", quote: "", isFav: 0, collectionName: ""));

    // await DBHelper.addToFav(quote ??
    //     Quote(id: 0, author: "", quote: "", isFav: 0, collectionName: ""));

    notifyListeners();
    // Update futures
    futureC = DBAuthorCollection.getAuthorCollection();
    futureQ = DBHelperQuotes.getQuotes();
    futureFav = DBHelperFav.getFavQuotes();
  }

  void delCollection(AuthorCollection? collection) async {
    // delete collection
    await DBAuthorCollection.delQuotesOfCollection(collection?.name ?? "");
    await DBAuthorCollection.delAuthorCollection(collection?.name ?? "");

    //update futures
    futureQ = DBHelperQuotes.getQuotes();
    futureC = DBAuthorCollection.getAuthorCollection();
    futureFav = DBHelperFav.getFavQuotes();
    futureA = DBAuthorCollection.getQuotesOfAuthor(collection?.name ?? "");

    notifyListeners();
  }

  void delFavQuote(Quote? quote) async {
    //del FavQuotes
    await DBHelperFav.delFavQuotes(quote ??
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
    futureQ = DBHelperQuotes.getQuotes();
    futureFav = DBHelperFav.getFavQuotes();
    futureA = DBAuthorCollection.getQuotesOfAuthor(quote?.author ?? "");

    notifyListeners();
  }

  void delAuthorCollection(String authorName) {
    DBAuthorCollection.delAuthorCollection(authorName);
    notifyListeners();
  }

  Future<List<UserCollection>>? futureUC;

  void addUserCollection(String collectionName) async {
    DBUserCollection.addUserCollection(collectionName);
    futureUC = DBUserCollection.getUserCollection();
    notifyListeners();
  }
}
