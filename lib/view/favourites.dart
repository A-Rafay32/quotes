import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:quotes/view/widgets/quote_card.dart';

import '../database.dart';
import '../model/provider.dart';
import '../utils.dart';
import 'constants.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  @override
  void initState() {
    Provider.of<Model>(context, listen: false).futureFav =
        DBHelper.getFavQuotes();
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
      body: Consumer<Model>(builder: (context, model, child) {
        return FutureBuilder(
          future: model.futureFav,
          builder: (context, snapshot) {
            return ListView.builder(
              itemCount: snapshot.data?.length ?? 0,
              itemBuilder: (context, index) => QuoteTile(
                  favIcon: (snapshot.data?[index].isFav == 0)
                      ? const Icon(
                          color: Colors.white70, Icons.favorite_outline_rounded)
                      : const Icon(
                          color: Colors.white70, Icons.favorite_rounded),
                  copy: () async {
                    await Clipboard.setData(
                        const ClipboardData(text: "your text"));
                    // copied successfully
                  },
                  favorites: () =>
                      model.switchFavourites(snapshot.data?[index]),
                  delete: () => model.delFavQuote(snapshot.data?[index]),
                  quoteObj: snapshot.data?[index] ??
                      Quote(
                          id: 0,
                          author: "",
                          quote: "",
                          isFav: 0,
                          collectionName: ""),
                  quote: snapshot.data?[index].quote ?? " ",
                  author: snapshot.data?[index].author ?? ""),
            );
          },
        );
      }),
    );
  }
}
