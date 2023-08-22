import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:quotes/model/helper/db_author_collection.dart';
import 'package:quotes/model/models.dart';
import 'package:quotes/res/constants.dart';
import 'package:quotes/view/widgets/quote_card.dart';
import 'package:quotes/view_model/collection_view_model/author_collection.dart';
import 'package:quotes/view_model/fav_view_model.dart';

import '../../../view_model/quotes_view_model.dart';

class AuthorCollectionScreen extends StatefulWidget {
  AuthorCollectionScreen({super.key, required this.collectionName});
  String? collectionName;
  @override
  State<AuthorCollectionScreen> createState() => _AuthorCollectionScreenState();
}

class _AuthorCollectionScreenState extends State<AuthorCollectionScreen> {
  @override
  void initState() {
    Provider.of<AuthorCollectionViewModel>(context, listen: false).futureA =
        DBAuthorCollection.getQuotesOfAuthor(widget.collectionName.toString());

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
      body: Consumer<AuthorCollectionViewModel>(builder: (context, model, child) {
        return FutureBuilder(
          future: model.futureA,
          builder: (context, snapshot) {
            return ListView.builder(
                itemCount: snapshot.data?.length,
                itemBuilder: (context, index) => QuoteTile(
                    favIcon: (snapshot.data?[index].isFav == 0)
                        ? const Icon(
                            color: Colors.white70,
                            Icons.favorite_outline_rounded)
                        : const Icon(
                            color: Colors.white70, Icons.favorite_rounded),
                    favorites: () =>
                        Provider.of<FavoriteViewModel>(context,listen: false).switchFavourites(snapshot.data![index]),
                    copy: () async {
                      await Clipboard.setData(
                          const ClipboardData(text: "your text"));
                      // copied successfully
                    },
                    delete: () =>
                        
                        Provider.of<QuotesViewModel>(context,listen: false).delQuote(snapshot.data?[index] ??
                            Quote(
                                author: "",
                                quote: "",
                                isFav: 0,
                                collectionName: "")),
                    quoteObj: snapshot.data?[index] ??
                        Quote(
                            // id: 0,
                            author: "",
                            quote: "",
                            isFav: 0,
                            collectionName: ""),
                    quote: snapshot.data?[index].quote ?? " ",
                    author: snapshot.data?[index].author ?? ""));
          },
        );
      }),
    );
  }
}
