import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:quotes/utils.dart';
import 'package:quotes/view/constants.dart';
import 'package:quotes/view/widgets/quote_card.dart';

import '../database.dart';
import '../model/provider.dart';

class AlbumScreen extends StatefulWidget {
  AlbumScreen({super.key, required this.collectionName});
  String? collectionName;
  @override
  State<AlbumScreen> createState() => _AlbumScreenState();
}

class _AlbumScreenState extends State<AlbumScreen> {
  
  @override
  void initState() {
    Provider.of<Model>(context, listen: false).futureA =
        DBHelper.testRI(widget.collectionName.toString());

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
        title: Text(widget.collectionName.toString(),
            style: const TextStyle(
                fontSize: 37, fontFamily: "Ramaraja", color: Colors.white)),
      ),
      body: Consumer<Model>(builder: (context, model, child) {
        return FutureBuilder(
          future: model.futureA,
          builder: (context, snapshot) {
            return ListView.builder(
              itemCount: snapshot.data?.length,
              itemBuilder: (context, index) => QuoteTile(
                  favIcon: (snapshot.data?[index].isFav == 0)
                      ? const Icon(
                          color: Colors.white70, Icons.favorite_outline_rounded)
                      : const Icon(
                          color: Colors.white70, Icons.favorite_rounded),
                  favorites: () =>
                      model.switchFavourites(snapshot.data![index]),
                  copy: () async {
                    await Clipboard.setData(
                        const ClipboardData(text: "your text"));
                    // copied successfully
                  },
                  delete: () =>
                      // Provider.of<Model>(context, listen: false)
                      model.delCollection2(snapshot.data?[index].author ?? ""),
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
