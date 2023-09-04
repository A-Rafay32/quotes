import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:quotes/view/widgets/insert_text.dart';
import 'package:quotes/view/widgets/quote_card.dart';
import 'package:quotes/view/widgets/snackbar.dart';
import '../../../model/data/db_quotes.dart';
import '../../../model/models.dart';

import '../../../view_model/provider.dart';
import '../../widgets/edit_pop_up.dart';

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
    Provider.of<Model>(context, listen: false).futureQ = DBQuotes.getQuotes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.sizeOf(context).height;
    return Consumer<Model>(builder: (context, model, child) {
      return FutureBuilder(
        future: model.futureQ,
        builder: (context, snapshot) {
          if (snapshot.data?.isEmpty ?? false) {
            return InsertQuoteText(h: h);
          }
          return ListView.builder(
              itemCount: snapshot.data?.length,
              itemBuilder: (context, index) => QuoteTile(
                  onDoubleTap: () => showDialog(
                      context: context,
                      builder: (context) => EditPopUpCard(
                            onTap: () {
                              //update quote
                              context
                                  .read<Model>()
                                  .updateQuote(snapshot.data![index]);
                              //Clear controllers
                              context.read<Model>().quoteController.clear();
                              context.read<Model>().authorController.clear();
                              Navigator.pop(context);
                            },
                            author: snapshot.data?[index].author ?? "",
                            quote: snapshot.data?[index].quote ?? "",
                          )),
                  favIcon: (snapshot.data?[index].isFav == 0)
                      ? const Icon(
                          color: Colors.white70, Icons.favorite_outline_rounded)
                      : const Icon(
                          color: Colors.white70, Icons.favorite_rounded),
                  favorites: () => model.switchFavourites(
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
                    DBQuotes.db?.insert("recentlyDel", {
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
