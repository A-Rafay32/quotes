import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:quotes/view/widgets/add_button.dart';
import 'package:quotes/view/widgets/edit_pop_up.dart';
import 'package:quotes/view/widgets/quote_card.dart';
import 'package:quotes/view/widgets/snackbar.dart';

import '../../../model/data/db_fav.dart';

import '../../../model/models.dart';
import '../../../res/constants.dart';
import '../../../view_model/provider.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  @override
  void initState() {
    Provider.of<Model>(context, listen: false).futureFav =
        DBFavorites.getFavQuotes();

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
        title: const Text("Favorites",
            style: TextStyle(
                fontSize: 37, fontFamily: "Ramaraja", color: Colors.white)),
      ),
      // (futureA.isEmpty) ? Consumer : Wow such Empty
      body: Consumer<Model>(builder: (context, model, child) {
        return FutureBuilder(
          future: model.futureFav,
          builder: (context, snapshot) {
            return ListView.builder(
                itemCount: snapshot.data?.length ?? 0,
                itemBuilder: (context, index) => GestureDetector(
                      onDoubleTap: () => Navigator.of(context)
                          .push(HeroDialogRoute(builder: (context) {
                        return EditPopUpCard(
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
                        );
                      })),
                      child: QuoteTile(
                          onDoubleTap: () => showDialog(
                              context: context,
                              builder: (context) => EditPopUpCard(
                                    onTap: () {
                                      //update quote
                                      context
                                          .read<Model>()
                                          .updateQuote(snapshot.data![index]);
                                      //Clear controllers
                                      context
                                          .read<Model>()
                                          .quoteController
                                          .clear();
                                      context
                                          .read<Model>()
                                          .authorController
                                          .clear();
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
                                  color: Colors.white70,
                                  Icons.favorite_rounded),
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

                            // copied successfully
                          },
                          favorites: () =>
                              model.switchFavourites(snapshot.data?[index]),
                          delete: () =>
                              model.delFavQuote(snapshot.data?[index]),
                          quoteObj: snapshot.data?[index] ??
                              Quote(
                                  // id: 0,
                                  author: "",
                                  quote: "",
                                  isFav: 0,
                                  collectionName: ""),
                          quote: snapshot.data?[index].quote ?? " ",
                          author: snapshot.data?[index].author ?? ""),
                    ));
          },
        );
      }),
    );
  }
}
