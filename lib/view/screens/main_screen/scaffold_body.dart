import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:quotes/view/widgets/insert_text.dart';
import 'package:quotes/view/widgets/quote_card.dart';
import 'package:quotes/view/widgets/snackbar.dart';
import '../../../model/helper/db_helper_quotes.dart';
import '../../../model/models.dart';
import '../../../view_model/fav_view_model.dart';
import '../../../view_model/quotes_view_model.dart';

class ScaffoldBody extends StatefulWidget {
  const ScaffoldBody({
    super.key,
  });

  @override
  State<ScaffoldBody> createState() => _ScaffoldBodyState();
}

class _ScaffoldBodyState extends State<ScaffoldBody> {
  @override
  void initState() {
    Provider.of<QuotesViewModel>(context, listen: false).futureQ =
        DBHelperQuotes.getQuotes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.sizeOf(context).height;
    return Consumer<QuotesViewModel>(builder: (context, model, child) {
      return FutureBuilder(
        future:
            // Model().futureQ,
            model.futureQ,
        builder: (context, snapshot) {
          if (snapshot.data?.isEmpty ?? false) {
            return InsertQuoteText(h: h);
          }
          return ListView.builder(
              itemCount: snapshot.data?.length,
              itemBuilder: (context, index) => QuoteTile(
                  favIcon: (snapshot.data?[index].isFav == 0)
                      ? const Icon(
                          color: Colors.white70, Icons.favorite_outline_rounded)
                      : const Icon(
                          color: Colors.white70, Icons.favorite_rounded),
                  favorites: () =>
                      Provider.of<FavoriteViewModel>(context, listen: false)
                          .switchFavourites(
                        snapshot.data?[index] ??
                            Quote(
                                // id: 0,
                                author: "",
                                quote: "",
                                collectionName: "",
                                isFav: 0),
                      ),
                  copy: () async {
                    String text =
                        "${snapshot.data![index].quote}   ~${snapshot.data![index].author}";
                    await Clipboard.setData(ClipboardData(text: text));
                    // copied successfully
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: SnackBarContent(text: text),
                      duration: const Duration(seconds: 2),
                      elevation: 2,
                    ));
                  },
                  delete: () {
                    // add the copy of quote in recentyDel table
                    DBHelperQuotes.db?.insert("recentlyDel", {
                      "collectionName": snapshot.data![index].collectionName,
                      "quote": snapshot.data![index].quote,
                      "author": snapshot.data![index].author,
                      "isFav": snapshot.data![index].isFav,
                    });

                    // delete the quote from everywhere
                    model.delQuote(snapshot.data?[index]);
                  },
                  quoteObj: snapshot.data?[index] ??
                      Quote(
                          // id: 0,
                          author: "",
                          quote: "",
                          collectionName: "",
                          isFav: 0),
                  quote: snapshot.data?[index].quote ?? "",
                  author: snapshot.data?[index].author ?? ""));
        },
      );
    });
  }
}
