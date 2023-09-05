import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:quotes/model/data/db_user_collection.dart';
import 'package:quotes/view/screens/user_collection_screen/user_collection_fav.dart';

import '../../../model/data/db_quotes.dart';
import '../../../model/models.dart';
import '../../../res/constants.dart';
import '../../../view_model/provider.dart';
import '../../widgets/add_button.dart';
import '../../widgets/edit_pop_up.dart';
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
  // void test() async {
  //   List<Quote> data =
  //       await DBUserCollection.getUserCollection(widget.collectionName);
  //   for (int i = 0; i < data.length; ++i) {
  //     print(data[i].toMap());
  //   }
  // }

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
        actions: [
          PopupMenuButton(
            color: kCardColor,
            icon: const Icon(
              Icons.more_vert,
              color: Colors.white,
            ),
            itemBuilder: (context) => [
              PopupMenuItem(
                onTap: () {
                  context
                      .read<Model>()
                      .delUserCollection(widget.collectionName);
                  Navigator.pop(context);
                },
                child: const Text(
                  "Delete Collection",
                  style: TextStyle(
                      color: Colors.white70, fontFamily: "Kanit", fontSize: 17),
                ),
              ),
              PopupMenuItem(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserCollectionFavScreen(
                              collectionName: widget.collectionName),
                        ));
                  },
                  child: const Text(
                    "See Favorites",
                    style: TextStyle(
                        color: Colors.white70,
                        fontFamily: "Kanit",
                        fontSize: 17),
                  ),
                ),
              )
            ],
          )
        ],
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
                    onDoubleTap: () => showDialog(
                        context: context,
                        builder: (context) => EditPopUpCard(
                              onTap: () {
                                //update quote
                                context.read<Model>().updateUserCollectionQuote(
                                      oldQuote:
                                          snapshot.data?[index].quote ?? "",
                                      collectionName: widget.collectionName,
                                      newAuthor: context
                                              .read<Model>()
                                              .authorController
                                              .text
                                              .isNotEmpty
                                          ? context
                                              .read<Model>()
                                              .authorController
                                              .text
                                              .trim()
                                          : snapshot.data?[index].author ?? "",
                                      newQuote: context
                                              .read<Model>()
                                              .quoteController
                                              .text
                                              .isNotEmpty
                                          ? context
                                              .read<Model>()
                                              .quoteController
                                              .text
                                              .trim()
                                          : snapshot.data?[index].quote ?? "",
                                    );
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
                            color: Colors.white70,
                            Icons.favorite_outline_rounded)
                        : const Icon(
                            color: Colors.white70, Icons.favorite_rounded),
                    favorites: () => model.switchFavUserCollection(
                          widget.collectionName,
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
                        "collectionName": "",
                        "quote": snapshot.data![index].quote,
                        "author": snapshot.data![index].author,
                        "isFav": snapshot.data![index].isFav,
                      });

                      // delete the quote from everywhere
                      model.delUserCollectionQuote(widget.collectionName,
                          snapshot.data?[index].quote ?? "");
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
          onPressed: () {
            context.read<Model>().addQuoteToUserCollection(
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
