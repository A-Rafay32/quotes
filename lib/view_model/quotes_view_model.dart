import 'package:flutter/material.dart';
import 'package:quotes/model/helper/db_author_collection.dart';

import '../model/helper/db_helper_fav.dart';
import '../model/helper/db_helper_quotes.dart';
import '../model/models.dart';
import 'collection_view_model/author_collection.dart';
import 'fav_view_model.dart';

class QuotesViewModel extends ChangeNotifier {
  // List<String> list = DBHelperQuotes.getQuotes().toString().split(",");
  TextEditingController Authorcontroller = TextEditingController();
  TextEditingController Quotecontroller = TextEditingController();
  Future<List<Quote>>? futureQ;

  // Future<List<CustomCollection>>? futureUC;

  Future<List<Quote>>? futureDel;

  int id = 0;

  Map<String, dynamic> map = {
    "id": "",
    "collectionId": "",
    "author": "",
    "quote": "",
  };

  void init() async {
    DBHelperQuotes.openDB();
    AuthorCollectionViewModel().futureC =
        DBAuthorCollection.getAuthorCollection();
    futureQ = DBHelperQuotes.getQuotes();
    FavoriteViewModel().futureFav = DBHelperFav.getFavQuotes();

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
    AuthorCollectionViewModel().futureC =
        DBAuthorCollection.getAuthorCollection();

    // AuthorCollectionViewModel().futureA =
    //     DBAuthorCollection.getQuotesOfAuthor(tempC.collection?.name ?? "");

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
    AuthorCollectionViewModel().futureC =
        DBAuthorCollection.getAuthorCollection();
    QuotesViewModel().futureQ = DBHelperQuotes.getQuotes();
    FavoriteViewModel().futureFav = DBHelperFav.getFavQuotes();
    AuthorCollectionViewModel().futureA =
        DBAuthorCollection.getQuotesOfAuthor(quote?.author ?? "");
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
    AuthorCollectionViewModel().futureC =
        DBAuthorCollection.getAuthorCollection();
    // print(await DBHelper.db?.query("collectionTable"));

    QuotesViewModel().futureQ = DBHelperQuotes.getQuotes();
    // print(await futureC);
    AuthorCollectionViewModel().futureA =
        DBAuthorCollection.getQuotesOfAuthor(Authorcontroller.text.trim());
    // print(await DBHelper.db?.query("quoteTable"));
    notifyListeners();
  }
}
