import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:quotes/model/data/db_user_collection.dart';

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

  void getFavQuotes() async {
    context.read<Model>().favQuotesMap = await DBFavorites.getFavQuotes();
    List<Map<String, dynamic>> favUserCol =
        await DBUserCollection.getFavQuotesUserCollection();
    print(favUserCol);
    for (int i = 0; i < favUserCol.length; ++i) {
      context.read<Model>().favQuotesMap!.add(favUserCol[i]);
    }
  }
  
  // void test() async {
  //   List<Map> favUserCol =
  //       await DBUserCollection.getFavQuotesUserCollection();
  //   for (int i = 0; i < favUserCol.length; ++i) {
  //     print(favUserCol[i].toMap());
  //   }
  // }

  @override
  void initState() {
    // Provider.of<Model>(context, listen: false).futureFav =
    //     DBFavorites.getFavQuotes();

    getFavQuotes();
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
        return ListView.builder(
            itemCount: model.favQuotesMap?.length,
            itemBuilder: (context, index) => GestureDetector(
                  onDoubleTap: () => Navigator.of(context)
                      .push(HeroDialogRoute(builder: (context) {
                    return EditPopUpCard(
                      onTap: () {
                        //update quote
                        // context
                        //     .read<Model>()
                        //     .updateQuote(model.favQuotesMap?[index].);
                        //Clear controllers
                        context.read<Model>().quoteController.clear();
                        context.read<Model>().authorController.clear();
                        Navigator.pop(context);
                      },
                      author: model.favQuotesMap?[index]["author"] ?? "",
                      quote: model.favQuotesMap?[index]["quote"] ?? "",
                    );
                  })),
                  child: QuoteTile(
                      onDoubleTap: () => showDialog(
                          context: context,
                          builder: (context) => EditPopUpCard(
                                onTap: () {
                                  //update quote
                                  // context
                                  //     .read<Model>()
                                  //     .updateQuote(model.favQuotesMap?[index]);
                                  //Clear controllers
                                  context.read<Model>().quoteController.clear();
                                  context
                                      .read<Model>()
                                      .authorController
                                      .clear();
                                  Navigator.pop(context);
                                },
                                author:
                                    model.favQuotesMap?[index]["author"] ?? "",
                                quote:
                                    model.favQuotesMap?[index]["quote"] ?? "",
                              )),
                      favIcon: (model.favQuotesMap?[index]["isFav"] == 0)
                          ? const Icon(
                              color: Colors.white70,
                              Icons.favorite_outline_rounded)
                          : const Icon(
                              color: Colors.white70, Icons.favorite_rounded),
                      copy: () async {
                        String text =
                            "${model.favQuotesMap?[index]["quote"]}   ~${model.favQuotesMap?[index]["author"]}";
                        await Clipboard.setData(ClipboardData(text: text));
                        // copied successfully
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: SnackBarContent(text: text),
                          duration: const Duration(seconds: 2),
                          elevation: 2,
                        ));

                        // copied successfully
                      },
                      favorites: () {},
                      // model.switchFavourites(model.favQuotesMap?[index]),
                      delete: () {},
                      //  model.delFavQuote(snapshot.data?[index]),
                      quoteObj:
                          // snapshot.data?[index] ??
                          Quote(
                              // id: 0,
                              author: "",
                              quote: "",
                              isFav: 0,
                              collectionName: ""),
                      quote: model.favQuotesMap?[index]["quote"] ?? " ",
                      author: model.favQuotesMap?[index]["author"] ?? ""),
                ));
      }),
    );
  }
}
