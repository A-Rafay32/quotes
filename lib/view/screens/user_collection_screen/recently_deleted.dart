import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:quotes/view/widgets/quote_card.dart';
import 'package:quotes/view/widgets/snackbar.dart';

import '../../../model/helper/db_helper_quotes.dart';
import '../../../res/constants.dart';
import '../../../model/models.dart';
import '../../../view_model/fav_view_model.dart';
import '../../../view_model/quotes_view_model.dart';

class RecentlyDelScreen extends StatefulWidget {
  const RecentlyDelScreen({super.key});

  @override
  State<RecentlyDelScreen> createState() => _RecentlyDelScreenState();
}

class _RecentlyDelScreenState extends State<RecentlyDelScreen> {
  @override
  void initState() {
    Provider.of<QuotesViewModel>(context, listen: false).futureDel =
        DBHelperQuotes.getQuotesFrom("recentlyDel");

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.sizeOf(context).height;
    double w = MediaQuery.sizeOf(context).width;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: kbackgroundColor,
        elevation: 0,
        title: const Text(
          "Recently Deleted",
          style: TextStyle(fontFamily: "Ramaraja", fontSize: 23),
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
            child: const Text(
              "Recently Deleted Notes will be kept here for 10 days after which they will be automatically deleted",
              style: TextStyle(
                  color: Colors.white70, fontFamily: "Kanit", fontSize: 14),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            height: h * 0.8,
            width: w,
            child: Consumer<QuotesViewModel>(builder: (context, model, child) {
              return FutureBuilder(
                future: model.futureDel,
                builder: (context, snapshot) {
                  return ListView.builder(
                      itemCount: snapshot.data?.length,
                      itemBuilder: (context, index) => QuoteTile(
                          favIcon: (snapshot.data?[index].isFav == 0)
                              ? const Icon(
                                  color: Colors.white70,
                                  Icons.favorite_outline_rounded)
                              : const Icon(
                                  color: Colors.white70,
                                  Icons.favorite_rounded),
                          favorites: () => Provider.of<FavoriteViewModel>(context,listen: false).switchFavourites(
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
                          delete: () => model.delQuote(snapshot.data?[index]),
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
          )
        ],
      ),
    );
  }
}
