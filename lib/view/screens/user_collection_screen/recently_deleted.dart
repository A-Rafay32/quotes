import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:quotes/utils/helper.dart';
import 'package:quotes/view/widgets/quote_card.dart';
import 'package:quotes/view/widgets/snackbar.dart';

import '../../../model/data/db_quotes.dart';
import '../../../res/constants.dart';
import '../../../model/models.dart';
import '../../../view_model/provider.dart';
import '../../widgets/edit_pop_up.dart';

class RecentlyDelScreen extends StatefulWidget {
  const RecentlyDelScreen({super.key});

  @override
  State<RecentlyDelScreen> createState() => _RecentlyDelScreenState();
}

class _RecentlyDelScreenState extends State<RecentlyDelScreen> {
  @override
  void initState() {
    Provider.of<Model>(context, listen: false).futureDel =
        DBQuotes.getQuotesFrom("recentlyDel");

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.sizeOf(context).height;
    double w = MediaQuery.sizeOf(context).width;

    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
              onPressed: () async {
                DateTime time = await getTimer();
                if (time.day > 10) {
                  Provider.of<Model>(context, listen: false)
                      .delRecentDelTable();
                }
              },
              child: Container()),
          IconButton(
              tooltip: "Delete All",
              onPressed: () {
                Provider.of<Model>(context, listen: false).delRecentDelTable();
              },
              icon: const Icon(
                  size: 29,
                  color: Colors.white70,
                  Icons.delete_outline_rounded))
        ],
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
            child: Consumer<Model>(builder: (context, model, child) {
              return FutureBuilder(
                future: model.futureDel,
                builder: (context, snapshot) {
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
                          favorites: () =>
                              Provider.of<Model>(context, listen: false)
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
                          delete: () => model.delRecentDelQuote(
                              snapshot.data?[index].quote ?? ""),
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
