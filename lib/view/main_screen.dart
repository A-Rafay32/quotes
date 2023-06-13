import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:quotes/view/album.dart';
import 'package:quotes/view/constants.dart';
import 'package:quotes/view/favourites.dart';
import 'package:quotes/view/widgets/add_button.dart';
import 'package:quotes/view/widgets/quote_card.dart';

import '../model/provider.dart';
import '../utils.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Future<List<Quote>>? futureQ;
  Future<List<Collection>>? futureC;

  @override
  void initState() {
    Provider.of<Model>(context, listen: false).init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: kbackgroundColor,
        elevation: 0,
        title: const Text(
          "Quotes",
          style: TextStyle(fontFamily: "Ramaraja", fontSize: 38),
        ),
      ),
      drawer: Drawer(
          backgroundColor: kbackgroundColor,
          child: Consumer<Model>(builder: (context, model, child) {
            return FutureBuilder(
              future: Provider.of<Model>(context, listen: false).futureC,
              builder: (context, snapshot) => ListView.separated(
                  separatorBuilder: (context, index) => const Divider(
                        thickness: 0.5,
                        indent: 10,
                        endIndent: 10,
                        color: Colors.white70,
                      ),
                  itemCount: snapshot.data?.length ?? 0,
                  itemBuilder: (context, index) => ListTile(
                        trailing: IconButton(
                            onPressed: () =>
                                model.delCollection(snapshot.data?[index]),
                            // {
                            //first delete all quotes
                            // Provider.of<Model>(context, listen: false)
                            //     .delCollection2(snapshot.data?[index].name);
                            // then collection

                            // },
                            icon: const Icon(
                                color: Colors.white70,
                                Icons.delete_outline_rounded)),
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AlbumScreen(
                                  collectionName: snapshot.data?[index].name),
                            )),
                        title: Text(
                          snapshot.data?[index].name ?? "",
                          style: const TextStyle(
                              fontFamily: "Rajdhani", fontSize: 18),
                        ),
                      )),
            );
          })
          // ]),
          ),
      body: Consumer<Model>(builder: (context, model, child) {
        return FutureBuilder(
          future:
              // Model().futureQ,
              model.futureQ,
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
                    favorites: () => model.switchFavourites(
                          snapshot.data?[index] ??
                              Quote(
                                  id: 0,
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
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text(text)));
                    },
                    delete: () =>
                        // Provider.of<Model>(context, listen: false)
                        //               .delCollection2(snapshot.data?[index].author),
                        model.delQuote(snapshot.data?[index]),
                    quoteObj: snapshot.data?[index] ??
                        Quote(
                            id: 0,
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
      floatingActionButton:
          // FloatingActionButton(onPressed: (){},),

          const AddButton(),
      bottomNavigationBar: BottomAppBar(
        height: 60,
        shape: const CircularNotchedRectangle(),
        notchMargin: 10,
        elevation: 2.0,
        color: kCardColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
                color: IconColor,
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const FavoritesScreen(),
                      ));
                },
                icon: const Icon(Icons.favorite_outline)),
            IconButton(
                color: IconColor,
                onPressed: () {},
                icon: const Icon(Icons.format_quote_sharp)),
          ],
        ),
      ),
    );
  }
}
