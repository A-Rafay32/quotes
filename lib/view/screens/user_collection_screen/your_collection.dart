import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:quotes/model/data/db_quotes.dart';
import 'package:quotes/model/data/db_user_collection.dart';
import 'package:quotes/view/screens/user_collection_screen/recently_deleted.dart';
import 'package:quotes/view/screens/user_collection_screen/user_collection.dart';
import 'package:quotes/view/widgets/collection_card.dart';

import '../../../res/constants.dart';
import '../../../view_model/provider.dart';

class YourCollectionScreen extends StatefulWidget {
  const YourCollectionScreen({super.key});

  @override
  State<YourCollectionScreen> createState() => _YourCollectionScreenState();
}

class _YourCollectionScreenState extends State<YourCollectionScreen> {
  @override
  void initState() {
    Provider.of<Model>(context, listen: false).futureUC =
        DBUserCollection.getUserCollections();
    super.initState();
    test();
  }

  void test() async {
    List result = await DBUserCollection.getUserCollections();
    print(result);
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
          "Your Collection",
          style: TextStyle(fontFamily: "Ramaraja", fontSize: 28),
        ),
      ),
      body: Column(
        children: [
          CreateCollection(),
          const RecentlyDeletedWidget(),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            height: h * 0.7,
            width: w,
            child: Consumer<Model>(
              builder: (context, model, child) {
                return FutureBuilder(
                  future: model.futureUC,
                  builder: (context, snapshot) {
                    return GridView.builder(
                      scrollDirection: Axis.vertical,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              childAspectRatio: 2.0, crossAxisCount: 2),
                      itemCount: snapshot.data?.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => UserCollectionScreen(
                                  collectionName:
                                      snapshot.data?[index].collectionName ??
                                          ""),
                            ));
                          },
                          child: CollectionCard(
                              text: snapshot.data?[index].collectionName ?? ""),
                        );
                      },
                    );
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }
}

class CreateCollection extends StatelessWidget {
  CreateCollection({
    super.key,
  });
  TextEditingController collectionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showDialog(
          barrierDismissible: true,
          useSafeArea: true,
          context: context,
          builder: (context) => AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Cancel",
                      style: TextStyle(
                        fontFamily: "Rajdhani",
                        fontWeight: FontWeight.w600,
                        fontSize: 19,
                        color: PopupCardColor,
                      ))),
              TextButton(
                  onPressed: () async {
                    DBUserCollection.createTable(
                        collectionController.text.toString());
                    Provider.of<Model>(context, listen: false)
                        .addUserCollection(
                            collectionController.text.toString());

                    Navigator.pop(context);
                    List<Map> result =
                        await DBQuotes.db!.query("UserCollections");
                    print(result);
                  },
                  child: const Text("OK",
                      style: TextStyle(
                        fontFamily: "Rajdhani",
                        fontWeight: FontWeight.w600,
                        fontSize: 19,
                        color: PopupCardColor,
                      )))
            ],
            content: SizedBox(
              height: 110,
              width: 200,
              // padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  const Text("New Collection",
                      style: TextStyle(
                          fontFamily: "Kanit",
                          fontWeight: FontWeight.w500,
                          fontSize: 19,
                          color: Colors.white70)),
                  const SizedBox(
                    height: 20,
                  ),
                  TextField(
                    controller: collectionController,
                    cursorColor: Colors.white70,
                    // cursorHeight: 19,
                    style: const TextStyle(
                        fontFamily: "Kanit",
                        fontSize: 19,
                        color: Colors.white70),
                    decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                const BorderSide(color: Colors.white60)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                const BorderSide(color: Colors.white60))),
                  )
                ],
              ),
            ),
            backgroundColor: kbackgroundColor,
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: const Row(children: [
          Icon(
            Icons.add,
            color: Colors.white70,
          ),
          SizedBox(
            width: 20,
          ),
          Text(
            "Create Collection",
            style: TextStyle(
                fontFamily: "Rajdhani", fontSize: 20, color: Colors.white70),
          )
        ]),
      ),
    );
  }
}

class RecentlyDeletedWidget extends StatelessWidget {
  const RecentlyDeletedWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const RecentlyDelScreen(),
            ));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: const Row(children: [
          Icon(
            Icons.delete_outline_rounded,
            color: Colors.white,
          ),
          SizedBox(
            width: 20,
          ),
          Text(
            "Recently Deleted",
            style: TextStyle(
                fontFamily: "Rajdhani", fontSize: 20, color: Colors.white),
          )
        ]),
      ),
    );
  }
}
