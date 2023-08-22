import 'package:flutter/material.dart';
import 'package:quotes/model/helper/db_author_collection.dart';
import 'package:quotes/model/helper/db_helper_quotes.dart';
import 'package:quotes/view_model/collection_view_model/author_collection.dart';
import 'package:quotes/view_model/quotes_view_model.dart';
import '../model/helper/db_helper_fav.dart';
import '../model/models.dart';

class FavoriteViewModel extends ChangeNotifier {
  Future<List<Quote>>? futureFav;

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

    // Update futures
    AuthorCollectionViewModel().futureC =
        DBAuthorCollection.getAuthorCollection();
    QuotesViewModel().futureQ = DBHelperQuotes.getQuotes();
    futureFav = DBHelperFav.getFavQuotes();
    notifyListeners();
  }

  void delCollection(AuthorCollection? collection) async {
    // delete collection
    await DBAuthorCollection.delQuotesOfCollection(collection?.name ?? "");
    await DBAuthorCollection.delAuthorCollection(collection?.name ?? "");

    //update futures
    QuotesViewModel().futureQ = DBHelperQuotes.getQuotes();
    AuthorCollectionViewModel().futureC =
        DBAuthorCollection.getAuthorCollection();
    futureFav = DBHelperFav.getFavQuotes();
    AuthorCollectionViewModel().futureA =
        DBAuthorCollection.getQuotesOfAuthor(collection?.name ?? "");

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
    AuthorCollectionViewModel().futureC =
        DBAuthorCollection.getAuthorCollection();
    QuotesViewModel().futureQ = DBHelperQuotes.getQuotes();
    futureFav = DBHelperFav.getFavQuotes();
    AuthorCollectionViewModel().futureA =
        DBAuthorCollection.getQuotesOfAuthor(quote?.author ?? "");

    notifyListeners();
  }
}
