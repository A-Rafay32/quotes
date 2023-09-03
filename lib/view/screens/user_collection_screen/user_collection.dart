import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:quotes/model/data/db_user_collection.dart';

import '../../../model/data/db_quotes.dart';
import '../../../model/models.dart';
import '../../../res/constants.dart';
import '../../../view_model/provider.dart';
import '../../widgets/add_button.dart';
import '../../widgets/insert_text.dart';
import '../../widgets/quote_card.dart';
import '../../widgets/snackbar.dart';

class UserCollectionScreen extends StatefulWidget {
  const UserCollectionScreen({required this.collectionName, super.key});
  final String collectionName;
  @override
  State<UserCollectionScreen> createState() => _UserCollectionScreenState();
}

class _UserCollectionScreenState extends State<UserCollectionScreen> {
  @override
  void initState() {
    Provider.of<Model>(context, listen: false).futureUserAlbum =
        DBUserCollection.getUserCollection(widget.collectionName);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kbackgroundColor,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(widget.collectionName,
            style: const TextStyle(
                fontSize: 28, fontFamily: "Ramaraja", color: Colors.white)),
      ),
      body: Consumer<Model>(builder: (context, model, child) {
        double h = MediaQuery.sizeOf(context).height;
        return FutureBuilder(
          future: model.futureUserAlbum,
          builder: (context, snapshot) {
            if (snapshot.data?.isEmpty ?? false) {
              return InsertQuoteText(h: h);
            }
            return ListView.builder(
                itemCount: snapshot.data?.length,
                itemBuilder: (context, index) => QuoteTile(
                    favIcon: (snapshot.data?[index].isFav == 0)
                        ? const Icon(
                            color: Colors.white70,
                            Icons.favorite_outline_rounded)
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
      }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30.0),
        child: AddButton(
          onPressed: () async {
            await DBUserCollection.addQuoteToUserCollection(
                widget.collectionName,
                Quote(
                    author: context.read<Model>().authorController.text.trim(),
                    quote: context.read<Model>().quoteController.text.trim(),
                    isFav: 0,
                    collectionName: widget.collectionName));

            context.read<Model>().authorController.clear();
            context.read<Model>().quoteController.clear();
          },
        ),
      ),
    );
  }
}
